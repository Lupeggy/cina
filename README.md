# Cina - Movie Scene Travel App

Discover and explore famous movie scenes while you travel! Cina helps you find nearby filming locations, organize your trips, and create personalized itineraries based on your favorite movies.

## Features

- 🎬 Discover nearby movie scenes and filming locations
- 🗺️ Interactive map with movie scene markers
- 📅 AI-powered trip planning and scheduling
- 📝 Travel diary and social sharing
- 🎥 Add scenes to your watchlist
- 🏆 Earn badges for visiting famous filming locations

## Tech Stack

- **Frontend**: Flutter (iOS & Android)
- **Backend**: Firebase (Authentication, Firestore, Storage)
- **Maps**: Google Maps API
- **AI**: OpenAI API for recommendations
- **State Management**: Provider/Bloc

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- Android Studio / Xcode (for emulators)
- Firebase project setup
- Google Maps API key

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/cina.git
   cd cina
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Set up environment variables:
   - Create a `.env` file in the root directory
   - Add your API keys:
     ```
     GOOGLE_MAPS_API_KEY=your_google_maps_api_key
     OPENAI_API_KEY=your_openai_api_key
     ```

4. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
/lib
  /screens       # App screens
  /widgets      # Reusable UI components
  /services     # Business logic and API calls
  /models       # Data models
  /utils        # Helper functions and constants
  /assets       # Images, fonts, etc.
```

## Contributing

Contributions are welcome! Please read our [contributing guidelines](CONTRIBUTING.md) before submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Movie data provided by [The Movie Database (TMDb)](https://www.themoviedb.org/)
- Icons from [Material Design Icons](https://material.io/resources/icons/)
- Inspired by movie lovers and travelers around the world
