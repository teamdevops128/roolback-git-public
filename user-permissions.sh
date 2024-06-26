#!/bin/bash

# GitHub personal access token
GITHUB_TOKEN="your_github_token"

# GitHub repository information
OWNER="repository_owner"
REPO="repository_name"

# Output CSV file
OUTPUT_FILE="admins.csv"

# Function to get repository collaborators with admin permissions
get_admins() {
  curl -s -H "Authorization: token $GITHUB_TOKEN" \
    "https://api.github.com/repos/$OWNER/$REPO/collaborators" | \
    jq -r '.[] | select(.permissions.admin == true) | [.login, .html_url] | @csv'
}

# Check if jq is installed
if ! command -v jq &> /dev/null
then
    echo "jq could not be found. Please install jq to run this script."
    exit
fi

# Get the admins and save to CSV
echo "username,url" > "$OUTPUT_FILE"
get_admins >> "$OUTPUT_FILE"

# Print message
echo "Admins for the repository $OWNER/$REPO have been saved to $OUTPUT_FILE."
