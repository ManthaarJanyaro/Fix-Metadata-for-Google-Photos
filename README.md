# Fix-Metadata-for-Google-Photos

This PowerShell script helps you restore crucial metadata (like capture time, GPS coordinates, descriptions, and more) to your photos and videos downloaded from Google Takeout. Google Takeout often provides this rich metadata in separate .json files, which this script intelligently reads and then embeds directly into your media files using ExifTool.

Features
Automated Metadata Embedding: Reads supplemental JSON files from Google Takeout and writes relevant metadata directly into corresponding media files.

Comprehensive Data Transfer: Transfers date/time, GPS coordinates, descriptions, titles, URLs, view counts, and device information.

Recursive Processing: Scans subfolders to find all relevant JSON and media files.

Automatic Backups: Creates a .\backup directory and saves original copies of your media files before making any modifications, ensuring data safety.

Video Support: Compatible with various image and video formats supported by ExifTool, including HEIC/HEIF and MP4.

Requirements
ExifTool: This script requires ExifTool to be installed and accessible from your system's PATH environment variable.

Installation (Windows): Download the exiftool(-k).exe and rename it to exiftool.exe. Place it in a directory that's included in your system's PATH, or directly in the same folder as this PowerShell script.

Recommended Version: It's highly recommended to use a recent version of ExifTool (e.g., v12.38 or newer, ideally v13.33+) for the best compatibility with modern formats like HEIC/HEIF and various video types.

How to Use
Download the Script: Save the provided PowerShell code as a .ps1 file (e.g., Fix-GoogleTakeoutMetadata.ps1).

Place the Script: Put the Fix-GoogleTakeoutMetadata.ps1 file in the root directory of your Google Takeout photo/video export (the folder containing your image/video files and their accompanying *.supplemental.json files).

Run the Script:

Open PowerShell (search for "PowerShell" in the Start Menu).

Navigate to the directory where you saved the script using cd C:\Path\To\Your\GoogleTakeoutFolder.

Execute the script by typing: .\FixMetadata.ps1

Monitor Progress: The script will display messages indicating which files are being processed and if any issues are encountered.

Check Backups: Upon completion, a backup folder will be created in the script's directory, containing copies of all original files that were modified.

Important Notes
Data Safety: While the script creates backups, it's always good practice to have a separate full backup of your Google Takeout data before running any automation scripts.

JSON Structure: The script relies on the standard .supplemental.json file structure provided by Google Takeout. If your JSON files have a different format, the script may not work as expected.

File Naming: The script expects media files to be in the same directory as their corresponding .supplemental.json files, with the filename specified in the JSON's title field.
