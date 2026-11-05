# YGUIDE – Virtual Tour Guide

A Flutter travel guide and trip planner for Android and iOS. The first version uses local sample data and stores saved destinations, trips, and profile preferences on-device so the core experience works without Firebase or map credentials.

## Run the app

Install Flutter (Dart 3.13 or newer), then run:

```sh
flutter pub get
flutter run
```

To run the checks:

```sh
flutter analyze
flutter test
```

## Included features

- Purple YGUIDE visual theme, responsive home discovery, destination search and category filters.
- Reusable destination guides with sample weather, local time, currency, attractions, and travel tips.
- Save and remove favorite destinations.
- Create and edit trip plans with date ranges and a starting point; view upcoming, past, and cancelled trips.
- Mock map preview that runs without a map key.
- Profile editing, language and currency selection, and notification preference.
- Local persistence for trip, saved-place, and profile data using `shared_preferences`.

Destination photos use remote Unsplash image URLs when connected. Each image has an in-app fallback, and destination facts and trip data are available offline.

## Optional integrations

- **Google Maps:** The map view is intentionally a mock preview. To enable live maps, add `google_maps_flutter`, configure Android/iOS API keys in the platform projects, and add location permission handling.
- **Firebase:** Authentication, Firestore, and Storage are not required for this local demo. Add Firebase configuration and repository implementations when a backend is needed.
- **Weather / exchange rates:** Current weather and destination local times are sample values; connect a service in place of `sample_destinations.dart` when API access is available.

The Figma file could not be opened from this environment (Figma returned an authorization error), so the supplied YGUIDE prompt and palette were used as the visual reference.
