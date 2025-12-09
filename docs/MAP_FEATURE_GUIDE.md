# Map & Location Feature Guide

This guide explains the map and location logic used in the **Customer App**. You can use this logic in other projects to implement location features **without needing a Google Maps API Key** (or as a cost-effective fallback).

## Core Logic
The app uses a **non-visual location picker** combined with OpenStreetMap APIs. It does **not** currently use the interactive `MapView` (Google Maps) component, which saves on API costs and setup time.

### 1. Technology Stack
*   **`expo-location`**: Used to access the device's GPS to get the current Latitude & Longitude.
*   **OpenStreetMap Nominatim API**: A free, public API used for:
    *   **Reverse Geocoding**: Converting GPS coordinates (Lat, Lng) into a readable address (e.g., "123 Main St").
    *   **Search**: Searching for place names (e.g., "Koramangala") and getting their coordinates.

### 2. Key Components
To replicate this feature, you need the following two files:

#### A. `CustomerLocationScreen.js`
*   **Purpose**: The main screen that requests permissions and auto-detects the user's current location.
*   **Path**: `src/screens/customer/CustomerLocationScreen.js`
*   **Key Functions**:
    *   `Location.requestForegroundPermissionsAsync()`: Asks user for permission.
    *   `Location.getCurrentPositionAsync()`: Gets GPS coords.
    *   `Location.reverseGeocodeAsync()`: Expo's built-in geocoding (basic).

#### B. `LocationPicker.js`
*   **Purpose**: A search interface to manually pick a location if GPS is wrong or if the user wants to select a different address.
*   **Path**: `src/components/LocationPicker.js`
*   **Key Functions**:
    *   `getAddressFromCoordinates(lat, long)`: Calls `https://nominatim.openstreetmap.org/reverse`.
    *   `searchLocation(query)`: Calls `https://nominatim.openstreetmap.org/search`.

## Implementation Steps for New Project

**1. Install Dependencies**
```bash
npx expo install expo-location
# Note: react-native-maps is NOT utilized in this specific logic, so you can skip it if you only want this text-based location picker.
```

**2. Copy Permissions Logic**
Use the code from `CustomerLocationScreen.js` to handle permissions gracefully.

**3. Implement Search Logic (API)**
Copy the `fetch` calls from `LocationPicker.js`.
*   **Endpoint**: `https://nominatim.openstreetmap.org/search`
*   **Headers**: ALWAYS include a `User-Agent` (e.g., `User-Agent: MyAppName/1.0`) as required by OpenStreetMap's usage policy.

**4. Data Structure**
The app saves the location in `AsyncStorage` with this structure:
```json
{
  "label": "Home",
  "address": "Full Address String",
  "latitude": 12.9716,
  "longitude": 77.5946,
  "addressComponents": { ... }
}
```

## Why this is useful
*   **Free**: No Google Cloud billing required.
*   **Simple**: No complex API key restrictions or SHA-1 certificate fingerprinting.
*   **Lightweight**: App size is smaller without heavy map SDKs.
