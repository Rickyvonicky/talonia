#!/bin/bash

# Define the directory you want to compress
DIR_TO_COMPRESS="shared"

# Define the output archive file name
OUTPUT_ARCHIVE="cache/taloniadata.tar.gz"

# Check if directory exists
if [ ! -d "$DIR_TO_COMPRESS" ]; then
    echo "Directory does not exist!"
    exit 1
fi

# Compress the directory into a tar.gz file
tar -czvf "$OUTPUT_ARCHIVE" "$DIR_TO_COMPRESS"

echo "Directory $DIR_TO_COMPRESS has been compressed into $OUTPUT_ARCHIVE"
