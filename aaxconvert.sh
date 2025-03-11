#!/bin/bash

# Configuration option: Activation Bytes
# You can retrieve your Activation Bytes from great websites such as:
# https://audible-tools.kamsker.at
# Once obtained, these bytes do not change.
ACTIVATION_BYTES="YOUR_ACTIVATION_BYTES_HERE"

# Default bitrate settings
BITRATE_OPUS="128k"
BITRATE_MP3="160k"
BITRATE_M4B="160k"

# Default format
FORMAT="opus"

# Help function
usage() {
    echo "Usage: $0 -i <inputfile.aax> -t <opus|mp3|m4b> [-b <bitrate>]"
    echo "\nThis script converts Audible AAX files into Opus, MP3, or M4B format."
    echo "It automatically extracts metadata and creates filenames in the format:"
    echo "    'Artist - Title.ext'"
    echo "\nExample usage:"
    echo "    ./script.sh -i my_audiobook.aax -t mp3 -b 192k"
    echo "\nSupported formats:"
    echo "    - opus (default, 128k)"
    echo "    - mp3 (160k)"
    echo "    - m4b (160k, optimized for audiobooks)"
    echo "\nNote: Activation Bytes must be set in the script before use!"
    echo "      Retrieve them from: https://audible-tools.kamsker.at"
    exit 1
}

# Parse arguments
while getopts ":i:b:t:" opt; do
    case ${opt} in
        i ) INPUT_FILE=$OPTARG ;;
        b ) BITRATE=$OPTARG ;;
        t ) FORMAT=$OPTARG ;;
        * ) usage ;;
    esac
done

# Check if an input file was provided
if [ -z "$INPUT_FILE" ]; then
    usage
fi

# Check if the file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File $INPUT_FILE does not exist."
    exit 1
fi

# Extract metadata (Artist and Title)
ARTIST=$(ffprobe -v error -show_entries format_tags=artist -of default=noprint_wrappers=1:nokey=1 "$INPUT_FILE")
TITLE=$(ffprobe -v error -show_entries format_tags=title -of default=noprint_wrappers=1:nokey=1 "$INPUT_FILE")

# Fallback if metadata is missing
if [ -z "$ARTIST" ]; then ARTIST="Unknown Artist"; fi
if [ -z "$TITLE" ]; then TITLE="Unknown Title"; fi

# Sanitize filename
SAFE_ARTIST=$(echo "$ARTIST" | tr -d '/:*?"<>|')
SAFE_TITLE=$(echo "$TITLE" | tr -d '/:*?"<>|')
OUTPUT_FILE="${SAFE_ARTIST} - ${SAFE_TITLE}.${FORMAT}"

# Set default bitrate based on format
case "$FORMAT" in
    opus) BITRATE=${BITRATE:-$BITRATE_OPUS} ;;
    mp3)  BITRATE=${BITRATE:-$BITRATE_MP3}  ;;
    m4b)  BITRATE=${BITRATE:-$BITRATE_M4B}  ;;
    *) echo "Error: Invalid format specified. Use opus, mp3, or m4b."; exit 1 ;;
esac

# Convert to selected format
case "$FORMAT" in
    opus) ffmpeg -activation_bytes "$ACTIVATION_BYTES" -i "$INPUT_FILE" -vn -c:a libopus -b:a "$BITRATE" "$OUTPUT_FILE" ;;
    mp3)  ffmpeg -activation_bytes "$ACTIVATION_BYTES" -i "$INPUT_FILE" -vn -c:a libmp3lame -b:a "$BITRATE" "$OUTPUT_FILE" ;;
    m4b)  ffmpeg -activation_bytes "$ACTIVATION_BYTES" -i "$INPUT_FILE" -vn -c:a aac -b:a "$BITRATE" -movflags +faststart -f mp4 "$OUTPUT_FILE" ;;
esac

echo "\n🎉 Conversion completed: $OUTPUT_FILE"
echo "\nNow go forth and enjoy your audiobook in the format of your choice!"
