# Flutter MVVM News App

A Flutter news application implementing the MVVM (Model-View-ViewModel) architecture pattern. This project demonstrates clean architecture, responsive design, and modern Flutter development practices.

## Features

- Clean MVVM Architecture
- Responsive Design (Mobile & Desktop)
- Authentication Flow
- News Article Listings
- Category Filtering
- Sidebar Navigation
- State Management
- API Integration

## Project Structure

```
lib/
├── core/
│   ├── network/         # API service and network utilities
│   └── utils/           # Responsive design and utilities
├── features/
│   ├── auth/           # Authentication feature
│   │   ├── models/     
│   │   └── presentation/
│   └── home/           # Home feature with news articles
│       ├── models/     
│       ├── presentation/
│       └── widgets/    
```

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- VS Code or Android Studio
- Git

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Rapheal555/mvvm-take-home-test-rapheal.git
```

2. Navigate to the project directory:
```bash
cd mvvm-take-home-test-rapheal
```

3. Install dependencies:
```bash
flutter pub get
```

4. Generate build files:
```bash
dart pub run build_runner build --delete-conflicting-outputs
```

### Build and Run

#### Quick Start Script (build.sh)
```bash
#!/bin/bash

# Ensure you're in the project directory
cd "$(dirname "$0")"

# Get dependencies
echo "Installing dependencies..."
flutter pub get

# Run build runner
echo "Generating build files..."
dart pub run build_runner build --delete-conflicting-outputs

# Build the app
echo "Building the app..."
flutter build

# Run the app
echo "Running the app..."
flutter run
```

To use the script:
1. Save it as `build.sh` in your project root
2. Make it executable: `chmod +x build.sh`
3. Run it: `./build.sh`

## Code Overview

### Core Components

1. **API Service** (`lib/core/network/api_service.dart`)
   - Handles all network requests
   - Implements error handling and response parsing

2. **Responsive Design** (`lib/core/utils/responsive.dart`)
   - Manages responsive layouts
   - Provides utility methods for screen size detection

### Features

1. **Authentication** (`lib/features/auth/`)
   - Login page implementation
   - Authentication state management
   - Form validation

2. **Home** (`lib/features/home/`)
   - News article listing
   - Category filtering
   - Responsive sidebar navigation

### Key Widgets

1. **Sidebar** (`lib/features/home/widgets/sidebar.dart`)
   - Responsive navigation drawer
   - Handles both mobile and desktop layouts
   - Implements proper gesture handling for mobile view

2. **Article Card** (`lib/features/home/widgets/article_card.dart`)
   - Displays article information
   - Responsive layout adaptation
   - Image handling and error states

## Architecture Decisions

1. **MVVM Pattern**
   - Clear separation of concerns
   - Better testability
   - Improved maintainability

2. **Responsive Design**
   - Single codebase for mobile and desktop
   - Adaptive layouts using `Responsive` utility
   - Consistent user experience across devices

3. **State Management**
   - Local state for simple UI components
   - Shared state for feature-level state

## Testing

Run tests using:
```bash
flutter test
```

## Build for Production

To build for production:

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License.
