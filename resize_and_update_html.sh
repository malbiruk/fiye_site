#!/bin/bash
# This script converts PNG images and updates HTML in the specified directory
# Usage: ./convert_and_update_html.sh directory_name

directory="$1"

# Check if the directory argument is provided
if [ -z "$directory" ]; then
    echo "Usage: ./convert_and_update_html.sh directory_name"
    exit 1
fi

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

# Loop through all HTML files in the specified directory
for html_file in "$directory"/*.html; do
    # Check if there are HTML files
    if [ -f "$html_file" ]; then
        echo "Processing HTML file: $html_file"

        # Loop through all PNG files in the imgs/ folder
        for png_file in "$directory/imgs"/*.png; do
            # Check if there are PNG files
            if [ -f "$png_file" ]; then
                filename=$(basename "$png_file")
                filename_noext="${filename%.*}"

                # Update HTML
                sed -i "s|<source type=\"image/webp\" srcset=\"imgs/${filename_noext}.webp\" \/>|<source type=\"image/webp\" srcset=\"imgs/${filename_noext}_high.webp 1200w,\\
                                       imgs/${filename_noext}_medium.webp 600w,\\
                                       imgs/${filename_noext}_low.webp 300w\" \/>\\
    <source type=\"image/png\" srcset=\"imgs/${filename_noext}_high.png 1200w,\\
                                      imgs/${filename_noext}_medium.png 600w,\\
                                      imgs/${filename_noext}_low.png 300w\" \/>|" "$html_file"
                sed -i "s|<img src=\"imgs/${filename_noext}.png\" alt=\"${filename_noext}\" \/>|<img src=\"imgs/${filename_noext}_low.png\" alt=\"${filename_noext}\" \/>|" "$html_file"
            fi
        done
    fi
done
