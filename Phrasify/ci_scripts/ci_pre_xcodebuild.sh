#!/bin/sh

#  ci_pre_xcodebuild.sh
#  Phraseon
#
#  Created by Robert Adamczyk on 08.02.24.
#
echo "InHouse: PRE-Xcode Build is activated .... "
echo $CI_XCODE_SCHEME
echo $CI_PRODUCT_PLATFORM
echo $CI_PRODUCT
echo $CI_XCODE_PROJECT

# Write a JSON File containing all the environment variables and secrets.
printf "{\"ALGOLIA_APP_ID\":\"%s\",\"ALGOLIA_ADMIN_KEY\":\"%s\"}" "$ALGOLIA_APP_ID" "$ALGOLIA_ADMIN_KEY" >> ../Phraseon_InHouse/Resources/secrets.json

# Check if the file was created
if test -f "../Phraseon_InHouse/Resources/secrets.json"; then
    echo "The secrets.json file has been successfully created."
else
    echo "Failed to create the secrets.json file."
    exit 1  # Optional: exit with an error if the file doesn't exist
fi

echo "Wrote Secrets.json file."

echo "InHouse: PRE-Xcode Build is DONE .... "

exit 0
