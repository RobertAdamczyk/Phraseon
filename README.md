# Phraseon

## Overview
Phraseon is a robust key management and localization tool designed for application developers. It simplifies the process of creating and storing translation keys, ensuring a streamlined workflow for multi-language applications.

## Architecture

At the heart of Phraseon's design is the MVVM-C (Model-View-ViewModel-Coordinator) architecture, which provides a modular and structured approach to app development.

### The Role of Coordinators
In Phraseon, Coordinators are pivotal in managing the application's flow. They are responsible for initiating and presenting different screens. Each view within Phraseon is backed by its own ViewModel, which in turn references a Coordinator. This setup allows the ViewModel to delegate the responsibility of screen transitions to the Coordinator, promoting a clear separation of navigation from presentation logic.

Furthermore, Coordinators hold dependencies such as Repositories, which are essential for fetching data and performing actions that reflect back on the UI. This strategy not only makes our views more lightweight but also encapsulates the navigation logic, making the app more manageable and scalable.

By adhering to the MVVM-C architecture, Phraseon ensures that each component stays focused on its primary role, making the codebase more readable, maintainable, and testable.

## Features
- **Firebase Integration**: Utilizes Firebase for backend infrastructure, authentication, and dynamic configuration through Remote Config.
- **Algolia Search**: Incorporates Algolia Search for quick and efficient search capabilities within the app.
- **Xcode Cloud**: Uses Xcode Cloud for continuous integration and continuous delivery to automate the build, test, and deployment process.
- **SwiftUI**: Leverages SwiftUI to build user interfaces across all Apple platforms with the power of Swift.
- **StoreKit v2**: Implements the latest StoreKit version for an improved in-app purchase and subscription management experience.
- **Lottie Animations**: Employs Lottie for adding high-quality animation to the app, enhancing the user interface.
- **Google Sign-In**: Integrates Google Sign-In to provide users with a secure and convenient authentication option.
- **Apple Sign-In**: Offers Apple Sign-In for a seamless authentication experience, ensuring privacy and ease of use.
- **Remote Config**: Uses Firebase Remote Config to modify the app's appearance and behavior without publishing an app update.
- **Unit Tests**: Includes a suite of unit tests to maintain code quality and ensure that each component functions as intended.

## Directory Structure
- `Shared`: Common code shared across the entire application.
  - `Sources`: Source files for shared components.
  - `Resources`: Assets and other resources.
- `iOS`: Code specific to the iOS version of the app.
  - `Shared`: Shared code specific to iOS.
  - `Phraseon_Live`: Live app specific configurations for iOS.
  - `Phraseon_InHouse`: In-house app specific configurations for iOS.
- `macOS`: Code specific to the macOS version of the app.
  - `Shared`: Shared code specific to macOS.
  - `Phraseon_Live`: Live app specific configurations for macOS.
  - `Phraseon_InHouse`: In-house app specific configurations for macOS.
- `Modules`: Distinct functional units of the app.
  - `Domain`: Business logic and domain entities.
  - `Model`: Data models.
  - `Common`: Code common to all modules.
- `PhraseonTests`: Unit and integration tests for Phraseon.

### Modules (SPM Local Packages)
Phraseon's modular architecture is underpinned by local Swift Package Manager (SPM) packages within the `Modules` directory:

- `Domain`
- `Model`
- `Common`

To utilize these packages in the application, use `import PackageName` within your code files.

## Continuous Integration
Phraseon uses Xcode Cloud for Continuous Integration (CI), ensuring that each build is tested and that the quality is maintained throughout the development process.

### Pre-Xcode Build Script
The pre-Xcode build script is a crucial part of our CI process. Here is a brief description of what each part of the script does:

- Creates a `secrets.json` file containing necessary secrets for Algolia Search API using the environment variables.
- Updates the `GoogleService-Info.plist` with Firebase configuration values using the environment variables.
- Checks and updates the `Info.plist` with the required configuration.

## Getting Started

### Prerequisites
Building the Phraseon project requires specific API keys and configuration settings for Firebase and Algolia Search. Ensure you have the following before attempting to build the project:
- Firebase API keys for the in-house variant.
- Algolia Search API keys.

### Installation
Setting up Phraseon is as simple as cloning the repository and opening it in Xcode. Here's how to get started:

#### Step 1: Clone the Repository
First, clone the Phraseon repository from GitHub to your local machine. Open your terminal, navigate to your directory of choice, and run the following command:

```bash
git clone https://github.com/RobertAdamczyk/Phraseon.git
```

#### Step 2: Open the Project in Xcode
After cloning, move into the project's directory and simply open the project with Xcode:

```bash
open Phraseon.xcodeproj
```

This command will launch Xcode with the project's workspace, where you'll find everything you need neatly configured for you.

#### Step 3: Build and Run
With the project open in Xcode, choose the target you wish to run — whether that's an iOS simulator, a macOS app, or directly on a connected Apple device.

