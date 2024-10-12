# oxfordplantsreminders


# Run fetch_responses.sh once a day at 00:00 (midnight)
0 0 * * * /bin/bash /root/Plants/fetch_responses.sh

# Run check_error.sh one hour after fetch_responses.sh (01:00)
0 1 * * * /bin/bash /root/Plants/check_error.sh

# Run send_random_message.sh every Saturday at 09:00
0 9 * * 6 /bin/bash /root/Plants/send_random_message.sh

