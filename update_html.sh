#!/bin/bash
# This script updates HTML in the specified directory, converting strings like
# <source type=\"image/webp\" srcset=\"photos/\(.*\).webp\" \/>
# to include images of differnet sizes in <source>

directory="$1"

# Check if the directory argument is provided
if [ -z "$directory" ]; then
    echo "Usage: ./update_html.sh directory_name"
    exit 1
fi

echo "Updating PNG files..."
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
                                       imgs/${filename_noext}_low.webp 300w\" \\
    sizes=\"(max-width: 320px) 280px, (max-width: 600px) 600px, (max-height: 480px) 480px, (max-height: 768px) 768px, 1200px\" \/>\\
    <source type=\"image/png\" srcset=\"imgs/${filename_noext}_high.png 1200w,\\
                                      imgs/${filename_noext}_medium.png 600w,\\
                                      imgs/${filename_noext}_low.png 300w\" \\
    sizes=\"(max-width: 320px) 280px, (max-width: 600px) 600px, (max-height: 480px) 480px, (max-height: 768px) 768px, 1200px\" \/>|" "$html_file"
                # sed -i "s|<img src=\"imgs/${filename_noext}.png\" alt=\"${filename_noext}\" \/>|<img src=\"imgs/${filename_noext}_low.png\" alt=\"${filename_noext}\" \/>|" "$html_file"
            fi
        done
    fi
done

echo "Updating JPG files..."
html_file="$directory/photo.html"

# Check if the HTML file exists
if [ -f "$html_file" ]; then
    echo "Processing HTML file: $html_file"

    # Update HTML
    sed -i "s|<source type=\"image/webp\" srcset=\"photos/\(.*\).webp\" \/>|<source type=\"image/webp\" srcset=\"photos/\1_high.webp 1200w,\\
                                       photos/\1_medium.webp 600w,\\
                                       photos/\1_low.webp 300w\" \\
    sizes=\"(max-width: 320px) 280px, (max-width: 600px) 600px, (max-height: 480px) 480px, (max-height: 768px) 768px, 1200px\" \/>\\
    <source type=\"image/jpeg\" srcset=\"photos/\1_high.jpg 1200w,\\
                                      photos/\1_medium.jpg 600w,\\
                                      photos/\1_low.jpg 300w\" \\
    sizes=\"(max-width: 320px) 280px, (max-width: 600px) 600px, (max-height: 480px) 480px, (max-height: 768px) 768px, 1200px\" \/>|" "$html_file"

    # sed -i "s|<img src=\"photos/\(.*\).jpg\"|<img src=\"photos/\1_low.jpg\"|g" "$html_file"
else
    echo "Error: $html_file does not exist."
    exit 1
fi
