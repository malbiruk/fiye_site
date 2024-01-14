#!/bin/bash
# This script converts PNGs im ./imgs/ and JPGs in ./photos/ to webp
# and makes sizes of different versions of them in the specified directory
# Usage: ./resize_images.sh directory_name

directory="$1"

# Check if the directory argument is provided
if [ -z "$directory" ]; then
    echo "Usage: ./resize_images.sh directory_name"
    exit 1
fi

echo "Resizing PNG images..."
# Loop through all PNG files in the imgs/ folder
for png_file in "$directory/imgs"/*.png; do
    # Check if there are PNG files
    if [ -f "$png_file" ]; then
        filename=$(basename "$png_file")
        filename_noext="${filename%.*}"

        # Get the original width of the image
        original_width=$(identify -format "%w" "$png_file")

        # Convert PNG to WebP
        cwebp -q 80 "$png_file" -o "$directory/imgs/${filename_noext}.webp"

        # Resize PNG versions only if larger than the specified widths
        if [ "$original_width" -gt 1200 ]; then
            convert "$png_file" -resize 1200x "$directory/imgs/${filename_noext}_high.png"
            cwebp -q 80 "$directory/imgs/${filename_noext}_high.png" -o "$directory/imgs/${filename_noext}_high.webp"
        else
            cp "$png_file" "$directory/imgs/${filename_noext}_high.png"
            cwebp -q 80 "$directory/imgs/${filename_noext}_high.png" -o "$directory/imgs/${filename_noext}_high.webp"
        fi

        if [ "$original_width" -gt 600 ]; then
            convert "$png_file" -resize 600x "$directory/imgs/${filename_noext}_medium.png"
            cwebp -q 80 "$directory/imgs/${filename_noext}_medium.png" -o "$directory/imgs/${filename_noext}_medium.webp"
        else
            cp "$png_file" "$directory/imgs/${filename_noext}_medium.png"
            cwebp -q 80 "$directory/imgs/${filename_noext}_medium.png" -o "$directory/imgs/${filename_noext}_medium.webp"
        fi

        if [ "$original_width" -gt 300 ]; then
            convert "$png_file" -resize 300x "$directory/imgs/${filename_noext}_low.png"
            cwebp -q 80 "$directory/imgs/${filename_noext}_low.png" -o "$directory/imgs/${filename_noext}_low.webp"
        else
            cp "$png_file" "$directory/imgs/${filename_noext}_low.png"
            cwebp -q 80 "$directory/imgs/${filename_noext}_low.png" -o "$directory/imgs/${filename_noext}_low.webp"
        fi
    fi
done

echo "Resizing JPG images..."
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
