#!/bin/bash

# Path to your JSON file containing messages
json_file="email_responses.json"

# Count the number of responses in the JSON file
NUM_RESPONSES=$(jq '. | length' "$json_file")

# Generate a random number between 0 and the number of responses - 1
RANDOM_INDEX=$(shuf -i 0-$(($NUM_RESPONSES - 1)) -n 1)

# Extract the randomly selected response and output it
selected_message=$(jq -r ".[$RANDOM_INDEX]" "$json_file")


# Define the recipient and subject
recipient="plants@maillist.ox.ac.uk"
subject="Weekly Plant Reminder"

# Create the email content
email_content="Subject: $subject\nTo: $recipient\n\n$selected_message"

# Send the email using sendmail
echo -e "$email_content" | /usr/sbin/sendmail -t

# Check if the email was sent successfully
if [ $? -eq 0 ]; then
    echo "Random message sent successfully to $recipient."
else
    echo "Failed to send message to $recipient."
fi

