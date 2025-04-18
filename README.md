# IguruAssignment

A Flutter application that displays a users list from API, with location services and image upload functionality.

## Features

- Display users fetched from API
- Display Current location
- Upload images for users (from camera or gallery)
- Local storage for offline access

## Installation

1. Clone the repository:
   ```
   git clone [repository-url]
   ```

2. Navigate to the project directory:
   ```
   cd iguru_assignment
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Run the app:
   ```
   flutter run
   ```


## Usage


### User Images

- Tap the camera icon on a user's avatar to:
  - Take a new photo with the camera
  - Select an image from the gallery

### Location

- The app will request location permissions on startup
- Your current location is displayed at the top of the screen

## Dependencies

- GetX: State management
- http: API requests
- Hive: Local storage
- Geolocator: Location services
- Image_picker: Image selection

## Permissions

The app requires the following permissions:

### Android
- INTERNET
- ACCESS_FINE_LOCATION
- ACCESS_COARSE_LOCATION
- CAMERA
- READ_EXTERNAL_STORAGE

### iOS
- Location When In Use Usage
- Camera Usage
- Photo Library Usage

## Troubleshooting

- For location services issues:
  - Ensure location permissions are granted
  - Enable location services on your device

- For image picking issues:
  - Ensure camera and storage permissions are granted
