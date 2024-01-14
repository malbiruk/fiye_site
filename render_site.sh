#!/bin/bash
# creates responsive images and updates fiye_site/ folder

cp -r /home/klim/Documents/music/fiye_site_init /home/klim/Documents/music/fiye_site_dev

if [ "$1" = "--skip-resize" ]; then
    cp -r /home/klim/Documents/music/fiye_site/imgs /home/klim/Documents/music/fiye_site_dev/
    cp -r /home/klim/Documents/music/fiye_site/photos /home/klim/Documents/music/fiye_site_dev/
    /home/klim/Documents/music/fiye_site_init/update_html.sh /home/klim/Documents/music/fiye_site_dev
else
    /home/klim/Documents/music/fiye_site_init/resize_images.sh /home/klim/Documents/music/fiye_site_dev
    /home/klim/Documents/music/fiye_site_init/update_html.sh /home/klim/Documents/music/fiye_site_dev
fi

rsync -a --delete --exclude='.*' /home/klim/Documents/music/fiye_site_dev/ /home/klim/Documents/music/fiye_site/
rm -rf /home/klim/Documents/music/fiye_site_dev

rsync -a --delete --exclude='.*' /home/klim/Documents/music/fiye_site_dev/ /home/klim/Documents/music/fiye_site/
rm -rf /home/klim/Documents/music/fiye_site_dev
