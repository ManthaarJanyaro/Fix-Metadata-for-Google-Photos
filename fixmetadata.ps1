# Recursively fixes metadata in images using Google Takeout supplemental JSON files
# Requires: exiftool in PATH

$BackupDir = ".\backup"

# Create a backup folder if it doesn't exist
if (-not (Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir | Out-Null
}

# Process all JSON files matching supplemental metadata format
Get-ChildItem -Recurse -Filter *.json | Where-Object { $_.Name -like '*.supplemental*' } | ForEach-Object {
    $jsonPath = $_.FullName
    $json = Get-Content -Raw -Path $jsonPath | ConvertFrom-Json

    $imageName = $json.title
    $imagePath = Join-Path $_.DirectoryName $imageName

    if (-not (Test-Path $imagePath)) {
        Write-Warning "❌ Image file not found for metadata: $imageName"
        return
    }

    # Extract metadata
    $datetime = ""
    if ($json.photoTakenTime.timestamp) {
        $timestamp = $json.photoTakenTime.timestamp
        $datetime = [System.DateTimeOffset]::FromUnixTimeSeconds($timestamp).LocalDateTime.ToString("yyyy:MM:dd HH:mm:ss")
    }

    $lat = $json.geoData.latitude
    $lon = $json.geoData.longitude
    $alt = $json.geoData.altitude
    $latRef = if ($lat -ge 0) { "N" } else { "S" }
    $lonRef = if ($lon -ge 0) { "E" } else { "W" }

    $description = $json.description
    $title = $json.title
    $url = $json.url
    $views = $json.imageViews

    $deviceType = $null
    if ($json.googlePhotosOrigin.mobileUpload.deviceType) {
        $deviceType = $json.googlePhotosOrigin.mobileUpload.deviceType
    }

    # Backup original
    $relPath = $imagePath.Substring((Get-Location).Path.Length).TrimStart('\')
    $backupTarget = Join-Path $BackupDir $relPath
    $backupFolder = Split-Path $backupTarget -Parent
    if (-not (Test-Path $backupFolder)) {
        New-Item -ItemType Directory -Path $backupFolder -Force | Out-Null
    }
    Copy-Item -Path $imagePath -Destination $backupTarget -Force

    # Build and execute exiftool command
    $args = @("-overwrite_original")

    if ($datetime) {
        $args += "-DateTimeOriginal=$datetime"
        $args += "-CreateDate=$datetime"
        $args += "-ModifyDate=$datetime"
    }

    if ($description) { $args += "-ImageDescription=$description" }
    if ($title)       { $args += "-Title=$title" }
    if ($url)         { $args += "-Comment=$url" }
    if ($views)       { $args += "-XPComment=Views: $views" }

    if ($lat -ne $null -and $lon -ne $null) {
        $args += "-GPSLatitude=$lat"
        $args += "-GPSLatitudeRef=$latRef"
        $args += "-GPSLongitude=$lon"
        $args += "-GPSLongitudeRef=$lonRef"
    }

    if ($alt -ne $null) {
        $args += "-GPSAltitude=$alt"
    }

    # Always set Google as Make
    $args += "-Make=Google"
    if ($deviceType) {
        $args += "-Model=$deviceType"
    }

    $args += $imagePath

    exiftool @args

    Write-Host "✅ Updated metadata: $imageName"
}

Write-Host "`n🎉 All done! Backups saved in '$BackupDir'"
