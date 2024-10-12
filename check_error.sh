#!/bin/bash

# Define the error file name and the recipient email
error_file="error"
recipient="tobias.bretschneider@balliol.ox.ac.uk"
subject="Error Notification"

# Check if the error file exists
if [ -f "$error_file" ]; then
    # Create the email content
    email_content="Subject: $subject\nTo: $recipient\n\nAn error file was detected in the directory. Please check the details in $error_file."

    # Send the email using sendmail
    echo -e "$email_content" | /usr/sbin/sendmail -t

    # Check if the email was sent successfully
    if [ $? -eq 0 ]; then
        echo "Error notification sent successfully to $recipient."
    else
        echo "Failed to send error notification to $recipient."
    fi
else
    echo "No error file found. All systems are functioning normally."
fi

