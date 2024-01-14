#!/usr/bin/python3

import os
import re
import sys

from PIL import Image

if len(sys.argv) != 2:
    print("Usage: python add_dimenions_to_imgs.py <directory>")
    sys.exit(1)

directory = sys.argv[1]

print("Adding dimensions to <img>'s...'\n")
for html_file in os.listdir(directory):
    if html_file.endswith(".html"):
        html_path = os.path.join(directory, html_file)
        # print("Processing HTML file:", html_path)

        with open(html_path, "r", encoding="utf-8") as f:
            html_content = f.read()

        img_lines = re.findall(r'<img[^>]+>', html_content)

        for img_line in img_lines:
            src_match = re.search(r'src="([^"]+)"', img_line)
            if src_match:
                img_src = src_match.group(1)
                img_path = os.path.join(directory, img_src)

                if os.path.exists(img_path):
                    img = Image.open(img_path)
                    new_img_line = re.sub(
                        r'(<img[^>]+src="[^"]+")',
                        (r'\1 width="%spx" height="%spx" '
                        'style="color: transparent;" '
                         'onload="this.style.color=\'#7f7d78\'" '
                         'onerror="this.style.color=\'#7f7d78\'"') % (
                            img.width, img.height), img_line)
                    html_content = html_content.replace(img_line, new_img_line)
                else:
                    print("Image not found:", img_path)

        with open(html_path, "w", encoding="utf-8") as f:
            f.write(html_content)
