#!/bin/bash
# creates responsive images and updates fiye_site/ folder
cp -r /home/klim/Documents/music/fiye_site_init /home/klim/Documents/music/fiye_site_dev &&
/home/klim/Documents/music/fiye_site_init/resize_and_update_html.sh /home/klim/Documents/music/fiye_site_dev &&
/home/klim/Documents/music/fiye_site_init/resize_and_update_jpgs_in_html.sh /home/klim/Documents/music/fiye_site_dev &&
rsync -a --delete --exclude='.*' /home/klim/Documents/music/fiye_site_dev/ /home/klim/Documents/music/fiye_site/ &&
rm -rf /home/klim/Documents/music/fiye_site_dev
