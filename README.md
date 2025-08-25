# Coin Market App

A Flutter application that displays cryptocurrency exchange information using Clean Architecture, Flutter BLoC pattern, and the CoinMarketCap API.

## 🏗️ Architecture

This project follows **Clean Architecture** principles with three main layers:

### 📁 Project Structure

```
lib/
├── core/                          # Core business logic and utilities
│   ├── api/                       # API configuration
│   ├── config/                     # App configuration and constants
│   ├── errors/                    # Error handling (Failures, Exceptions)
│   ├── injection/                 # Dependency injection setup
│   ├── theme/                     # App theming
│   ├── usecase/                   # Base use case classes
│   └── utils/                     # Utility classes (logger, formatters)
│
├── features/                      # Feature-based modules
│   └── exchanges/                 # Exchange feature module
│       ├── data/                  # Data layer
│       │   ├── datasources/       # Remote and local data sources
│       │   ├── models/            # Data models for API communication
│       │   └── repositories_impl/ # Repository implementations
│       ├── domain/                # Domain layer (Business Logic)
│       │   ├── entities/          # Business entities
│       │   ├── repositories/      # Repository interfaces
│       │   └── usecases/          # Use cases (application logic)
│       └── presentation/          # Presentation layer
│           ├── bloc/             # BLoC state management
│           ├── pages/            # UI pages/screens
│           └── widgets/          # Reusable UI components
│
└── main.dart                      # App entry point
```

### 🏛️ Clean Architecture Principles

- **Separation of Concerns**: Each layer has a specific responsibility
- **Dependency Rule**: Inner layers don't depend on outer layers
- **Testability**: Business logic is isolated from external dependencies
- **Maintainability**: Changes in one layer don't affect others

## 🚀 Features

- 📊 **Exchange Listing**: View all cryptocurrency exchanges
- 🔍 **Search**: Search exchanges by name
- 📱 **Clean UI**: Modern Material Design 3 interface
- 💾 **Caching**: Local storage with Hive for offline support
- 🔄 **State Management**: Flutter BLoC for reactive state management
- 🌐 **API Integration**: CoinMarketCap API v1 integration
- ⚡ **Performance**: Optimized with caching and efficient state management

## 🛠️ Setup Instructions

### Prerequisites

- Flutter SDK (>=3.8.1)
- Dart SDK (>=3.8.1)
- Android Studio or VS Code
- CoinMarketCap API Key (free at [coinmarketcap.com/api](https://coinmarketcap.com/api))

### 1. Clone and Install Dependencies

````bash
git clone <repository-url>
cd coin_market_app
flutter pub get
### 2. API Key Configuration

1. Get your free API key from [CoinMarketCap API](https://coinmarketcap.com/api)

2. Configure the launch settings in `.vscode/launch.json`:

3. Run the App

```bash
flutter run
```

## 📚 Dependencies

### Main Dependencies

- **flutter_bloc**: State management using BLoC pattern
- **get_it**: Dependency injection
- **http**: HTTP client for API calls
- **hive**: Local storage database
- **dartz**: Functional programming (Either, Right, Left)
- **equatable**: Value comparison for immutable objects
- **intl**: Internationalization and formatting

### Development Dependencies

- **flutter_lints**: Code linting rules

## 🎯 Key Concepts

### BLoC Pattern

The app uses **Business Logic Component (BLoC)** pattern for state management:

- **Events**: User actions (e.g., `GetAllExchangesEvent`)
- **States**: UI states (e.g., `ExchangesLoaded`, `ExchangeError`)
- **BLoC**: Business logic coordinator

### Repository Pattern

Data access is abstracted through repositories:

- **Repository Interface** (domain layer): Defines contracts
- **Repository Implementation** (data layer): Implements data access logic
- **Data Sources**: Remote API and local cache

### Error Handling

- **Failures**: Domain layer error representations
- **Exceptions**: Data layer implementation errors
- **Error Mapper**: Converts exceptions to failures

## 🔧 Configuration

### Environment Variables

The app supports the following environment variables:

- `COINMARKETCAP_API_KEY`: Your CoinMarketCap API key
- `IS_PRODUCTION`: Enable production mode
- `ENABLE_LOGGING`: Enable/disable logging
- `ENABLE_CACHE`: Enable/disable caching

### API Configuration

API endpoints and settings are configured in `lib/core/api/api_config.dart`.

### Theme

App theming is configured in `lib/core/theme/app_theme.dart` with support for light and dark modes.

## 🧪 Testing

Run tests with:

```bash
flutter test
```

## 📱 Building for Production

### Android APK

```bash
flutter build apk --release
```

### iOS

```bash
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🔗 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [BLoC Pattern](https://bloclibrary.dev/)
- [CoinMarketCap API](https://coinmarketcap.com/api/documentation/v1/)
````
