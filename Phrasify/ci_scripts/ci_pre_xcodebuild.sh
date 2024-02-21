#!/bin/sh

#  ci_pre_xcodebuild.sh
#  Phraseon
#
#  Created by Robert Adamczyk on 08.02.24.
#
echo "PRE-Xcode Build is activated .... "

# Display the current directory path
echo "Current directory path:"
pwd

# Listing current directory contents
echo "Listing contents of the current directory:"
ls -l

# Listing parent directory contents
echo "Listing contents of the parent directory:"
ls -l ..

# Go up two levels to the "grandparent" directory
cd ../..

# Now list the contents of the "grandparent" directory
echo "Listing contents of the grandparent directory:"
ls -l

# Display the path of the "grandparent" directory
echo "Grandparent directory path:"
pwd


# Write a JSON File containing all the environment variables and secrets.
filePath="../$CI_PRODUCT/Resources/secrets.json"
printf "{\"ALGOLIA_APP_ID\":\"%s\",\"ALGOLIA_SEARCH_KEY\":\"%s\"}" "$ALGOLIA_APP_ID" "$ALGOLIA_SEARCH_KEY" >> "$filePath"

# Check if the file was created
if test -f "$filePath"; then
    echo "The secrets.json file has been successfully created."
else
    echo "Failed to create the secrets.json file."
    exit 1  # Optional: exit with an error if the file doesn't exist
fi

echo "PRE-Xcode Build is DONE .... "

exit 0
