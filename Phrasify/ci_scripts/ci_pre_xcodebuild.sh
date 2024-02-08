#!/bin/sh

#  ci_pre_xcodebuild.sh
#  Phraseon
#
#  Created by Robert Adamczyk on 08.02.24.
#
echo "InHouse: PRE-Xcode Build is activated .... "
echo $CI_WORKSPACE
echo $ALGOLIA_APP_ID
echo $ALGOLIA_ADMIN_KEY

# Move to the place where the scripts are located.
# This is important because the position of the subsequently mentioned files depend of this origin.
cd ci_scripts || exit 1

# Write a JSON File containing all the environment variables and secrets.
printf "{\"ALGOLIA_APP_ID\":\"%s\",\"ALGOLIA_ADMIN_KEY\":\"%s\"}" "$ALGOLIA_APP_ID" "$ALGOLIA_ADMIN_KEY" >> ../Phraseon/Phraseon_InHouse/Resources/secrets.json

echo "Wrote Secrets.json file."

echo "InHouse: PRE-Xcode Build is DONE .... "

exit 0
