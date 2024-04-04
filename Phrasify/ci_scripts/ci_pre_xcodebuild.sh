#!/bin/sh

#  ci_pre_xcodebuild.sh
#  Phraseon
#
#  Created by Robert Adamczyk on 08.02.24.
#
echo "PRE-Xcode Build is activated .... "

# Display all environment variables
echo "Listing all environment variables:"
printenv

# Check if CI_TEST_DESTINATION_RUNTIME exists
if [ ! -z "$CI_TEST_DESTINATION_RUNTIME" ]; then
    # Define the path to the google plist file
    googleFilePath="../$CI_PRODUCT_PLATFORM/$CI_PRODUCT/Resources/Firebase"
    ls googleFilePath
    echo "CI_TEST_DESTINATION_RUNTIME is set, skipping the script"
    exit 0
fi

# Write a JSON File containing all the environment variables and secrets.
secretsFilePath="../$CI_PRODUCT_PLATFORM/$CI_PRODUCT/Resources/secrets.json"
printf "{\"ALGOLIA_APP_ID\":\"%s\",\"ALGOLIA_SEARCH_KEY\":\"%s\"}" "$ALGOLIA_APP_ID" "$ALGOLIA_SEARCH_KEY" >> "$secretsFilePath"

# Check if the file was created
if test -f "$secretsFilePath"; then
    echo "The secrets.json file has been successfully created."
else
    echo "Failed to create the secrets.json file."
    exit 1  # Optional: exit with an error if the file doesn't exist
fi

# Define the path to the google plist file
googleFilePath="../$CI_PRODUCT_PLATFORM/$CI_PRODUCT/Resources/Firebase/GoogleService-Info.plist"

# Check if the plist file exists
if test -f "$googleFilePath"; then
    # File exists, proceed with replacing placeholder values
    sed -i '' "s/CLIENT_ID_VALUE/${GOOGLE_CLIENT_ID}/g" "$googleFilePath"
    sed -i '' "s/REVERSED_CLIENT_ID_VALUE/${GOOGLE_REVERSED_CLIENT_ID}/g" "$googleFilePath"
    sed -i '' "s/API_KEY_VALUE/${GOOGLE_API_KEY}/g" "$googleFilePath"
    sed -i '' "s/GOOGLE_APP_ID_VALUE/${GOOGLE_APP_ID}/g" "$googleFilePath"

    echo "Updated GoogleService-Info.plist with environment variables."
else
    # File does not exist, print error message and exit with status 1
    echo "Error: GoogleService-Info.plist file does not exist at $googleFilePath."
    exit 1
fi

# Define the path to the info plist file
infoFilePath="../$CI_PRODUCT_PLATFORM/$CI_PRODUCT/Resources/Info.plist"

# Check if the plist file exists
if test -f "$infoFilePath"; then
    # File exists, proceed with replacing placeholder values
    sed -i '' "s/REVERSED_CLIENT_ID_VALUE/${GOOGLE_REVERSED_CLIENT_ID}/g" "$infoFilePath"

    echo "Updated Info.plist with environment variables."
else
    # File does not exist, print error message and exit with status 1
    echo "Error: Info.plist file does not exist at $infoFilePath."
    exit 1
fi

# Define the path to the FirebaseSecrets plist file
firebaseSecretsFilePath="../$CI_PRODUCT_PLATFORM/$CI_PRODUCT/Resources/Firebase/FirebaseSecrets.plist"

# Create FirebaseSecrets.plist with a basic plist structure
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict></dict>
</plist>" > "$firebaseSecretsFilePath"
echo "An empty FirebaseSecrets.plist file has been created at $firebaseSecretsFilePath."

# Define the path to the InfoSecrets plist file
infoSecretsFilePath="../$CI_PRODUCT_PLATFORM/$CI_PRODUCT/Resources/InfoSecrets.plist"

# Create FirebaseSecrets.plist with a basic plist structure
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict></dict>
</plist>" > "$infoSecretsFilePath"
echo "An empty InfoSecrets.plist file has been created at $infoSecretsFilePath."

echo "PRE-Xcode Build is DONE .... "

exit 0
