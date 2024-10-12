#!/bin/bash

# The file where responses will be saved
RESPONSE_FILE="email_responses.json"
ERROR_FILE="error"
API_URL="https://openrouter.ai/api/v1/chat/completions"
AUTH_TOKEN="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"

# Function to make the API call
make_api_call() {
  RESPONSE=$(curl -s $API_URL \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $AUTH_TOKEN" \
    -d '{
      "model": "meta-llama/llama-3.1-405b-instruct:free",
      "temperature": 0.8,
      "messages": [
        {
          "role": "user",
          "content": "Write an email acting as a weekly reminder for people to water their plants. Include a plant-related joke, and a tip for looking after plants. Do just the text body. Make it random. Start with Hey Plant Lovers :)), and sign off with Happy Watering!!"
        }
      ]
    }')
}

# Function to check if the API response contains an error
check_for_error() {
  echo "$1" | jq -e '.error' > /dev/null 2>&1
}

# Function to initialize the JSON array if the file is empty
initialize_json_file() {
  if [[ ! -s $RESPONSE_FILE ]]; then
    echo "[]" > "$RESPONSE_FILE"
  fi
}

# Function to save the content to the response file
save_responses() {
  # Extract the email content from the response and append it to the JSON file
  EMAIL_CONTENT=$(echo "$1" | jq '.choices[0].message.content' | jq '.')
  
  # Append the new response to the JSON file
  jq --argjson new "$EMAIL_CONTENT" '. += [$new]' "$RESPONSE_FILE" > tmp.json && mv tmp.json "$RESPONSE_FILE"
  echo "Response appended to $RESPONSE_FILE"
}

# Initialize the JSON file if it doesn't exist or is empty
initialize_json_file

# Initial API call
make_api_call

# Check if the response contains an error
if check_for_error "$RESPONSE"; then
  echo "Error detected in response. Retrying in 5 minutes..."
  sleep 300  # Wait for 5 minutes

  # Retry API call
  make_api_call

  # If still an error, create the error file
  if check_for_error "$RESPONSE"; then
    echo "Still getting an error after retry. Creating error file."
    echo "$RESPONSE" > "$ERROR_FILE"
    echo "Error details saved to $ERROR_FILE"
    exit 1
  else
    # If retry was successful, save responses
    save_responses "$RESPONSE"
  fi
else
  # If no error, save responses
  save_responses "$RESPONSE"
fi

