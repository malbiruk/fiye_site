#!/usr/bin/python3

import smtplib
import ssl
import argparse
import pandas as pd
from email.message import EmailMessage
from email.utils import formataddr
from email.utils import make_msgid
from PIL import Image


def get_recipients(url: str) -> list:
    df = pd.read_csv(url)
    return df.email.to_list()


def send_email(sender, gmail_password, recipients, subject, body, image_path='', link='', add_html=True):
    msg = EmailMessage()
    msg['Subject'] = subject
    msg['From'] = formataddr(('flowers in your eyes', sender))
    msg['To'] = formataddr(('flowers in your eyes', sender))
    msg['Bcc'] = recipients
    unfollow = '\n\n_____\n'\
    '(чтобы отписаться, напишите об этом в ответном письме)'
    msg.set_content('\n'.join(body)+unfollow)

    if add_html:
        # Add the html version.  This converts the message into a multipart/alternative
        # container, with the original text message as the first part and the new html
        # message as the second part.
        image_cid = make_msgid()

        html_head = '<html>\n<head></head>\n<body>\n'
        linked_image = f'<a href="{link}">\n'\
            '<img src="cid:{image_cid}" />\n</a>'
        html_body = '<p>' + '<br>'.join(body) + '</p>\n<br><br><hr><p>(чтобы отписаться, напишите об этом в ответном письме)</p>'

        html_tail = '\n</body>\n</html>'

        html = ''.join([html_head, linked_image, html_body, html_tail])

        msg.add_alternative(html.format(
            image_cid=image_cid[1:-1]), subtype='html')
        # note that we needed to peel the <> off the msgid for use in the html.

        # Now add the related image to the html part.
        with open(f'{image_path}', 'rb') as img:
            msg.get_payload()[1].add_related(img.read(), 'image', 'jpeg',
                                             cid=image_cid)
    try:
        ctx = ssl.create_default_context()
        smtp_server = smtplib.SMTP_SSL('smtp.gmail.com', 465, context=ctx)
        smtp_server.ehlo()
        smtp_server.login(sender, gmail_password)
        smtp_server.send_message(msg)
        smtp_server.close()
        print("Email sent successfully!")
    except Exception as ex:
        print("Something went wrong…", ex)


def decrease_image_size(image_path):
    size = 300, 300
    with Image.open(image_path) as im:
        im.thumbnail(size, Image.ANTIALIAS)
        im.save('/tmp/thumbnail.jpg')


def main():
    parser = argparse.ArgumentParser(
        description='Send email from flowers in your eyes')
    parser.add_argument('-t', '--theme',
                        help='theme of email')
    parser.add_argument('-b', '--body', nargs='*',
                        help='body of email (lines in list)')
    parser.add_argument('-i', '--image', default='',
                        help='path to image')
    parser.add_argument('-l', '--link', default='',
                        help='link to include')
    parser.add_argument(
        '-s', '--sender', default='fiyefiyefiye@gmail.com', help='sender email')
    parser.add_argument('-sp', '--sender_password', default='obwolbnksqutayec',
                        help='sender email password')
    parser.add_argument('--test', action='store_true',
                        help='send email only to myself')
    args = parser.parse_args()

    url = 'https://docs.google.com/spreadsheet/ccc?key=1fwddcJJkoNyaX_zbz2-9L61c3TwkmL5jy4XLOi2qgKc&output=csv'

    if args.test:
        recipients = ['2601074@gmail.com']
    else:
        recipients = get_recipients(url)

    if args.image == '':
        send_email(
            args.sender,
            args.sender_password,
            recipients,
            args.theme,
            args.body,
            add_html=False)
    else:
        decrease_image_size(args.image)
        send_email(
            args.sender,
            args.sender_password,
            recipients,
            args.theme,
            args.body,
            '/tmp/thumbnail.jpg',
            args.link)


if __name__ == '__main__':
    main()
