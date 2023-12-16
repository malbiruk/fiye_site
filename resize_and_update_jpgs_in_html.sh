#!/bin/bash
# This script converts JPG images, creates adaptive sizes, and updates HTML in the specified directory
# Usage: ./convert_and_update_html_photos.sh directory_name

directory="$1"
html_file="$directory/photo.html"

# Check if the directory argument is provided
if [ -z "$directory" ]; then
    echo "Usage: ./convert_and_update_html_photos.sh directory_name"
    exit 1
fi

# Loop through all JPG files in the photos/ folder
for jpg_file in "$directory/photos"/*.jpg; do
    # Check if there are JPG files
    if [ -f "$jpg_file" ]; then
        filename=$(basename "$jpg_file")
        filename_noext="${filename%.*}"

        # Get the original width of the image
        original_width=$(identify -format "%w" "$jpg_file")

        # Convert JPG to WebP
        cwebp -q 80 "$jpg_file" -o "$directory/photos/${filename_noext}.webp"

        # Resize JPG versions only if larger than the specified widths

        convert "$jpg_file" -resize 1200x "$directory/photos/${filename_noext}_high.jpg"
        cwebp -q 80 "$directory/photos/${filename_noext}_high.jpg" -o "$directory/photos/${filename_noext}_high.webp"

        convert "$jpg_file" -resize 600x "$directory/photos/${filename_noext}_medium.jpg"
        cwebp -q 80 "$directory/photos/${filename_noext}_medium.jpg" -o "$directory/photos/${filename_noext}_medium.webp"

        convert "$jpg_file" -resize 300x "$directory/photos/${filename_noext}_low.jpg"
        cwebp -q 80 "$directory/photos/${filename_noext}_low.jpg" -o "$directory/photos/${filename_noext}_low.webp"

    fi
done

# Check if the HTML file exists
if [ -f "$html_file" ]; then
    echo "Processing HTML file: $html_file"

    # Update HTML
    sed -i "s|<source type=\"image/webp\" srcset=\"photos/\(.*\).webp\" \/>|<source type=\"image/webp\" srcset=\"photos/\1_high.webp 1200w,\\
                                       photos/\1_medium.webp 600w,\\
                                       photos/\1_low.webp 300w\" \/>\\
    <source type=\"image/jpeg\" srcset=\"photos/\1_high.jpg 1200w,\\
                                      photos/\1_medium.jpg 600w,\\
                                      photos/\1_low.jpg 300w\" \/>|" "$html_file"

    sed -i "s|<img src=\"photos/\(.*\).jpg\"|<img src=\"photos/\1_low.jpg\"|g" "$html_file"
else
    echo "Error: $html_file does not exist."
    exit 1
fi
