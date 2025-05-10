# Aglan ABG Analysis App

A comprehensive Arterial Blood Gas (ABG) analysis application designed for healthcare professionals. This Flutter-based application provides specialized tools for analyzing blood gas measurements in different clinical scenarios, with a focus on accurate diagnosis and treatment planning.

## Main Features

### 1. ABG Admission Analysis
- Initial blood gas analysis for new patients
- Support for both normal and high-altitude conditions
- Detailed interpretation of acid-base balance
- Patient type-specific calculations

### 2. Follow-up ABG Analysis
- Metabolic acid-base disorder tracking
- Respiratory acid-base disorder monitoring
- Progress comparison with previous measurements
- Treatment response evaluation

### 3. COPD Patient Management
- Specialized calculations for COPD patients
- Normal and high-altitude condition support
- Respiratory function assessment
- Treatment optimization tools

## Key Functionality

- **Patient Type Selection**: Choose between different patient categories for appropriate analysis
- **Input Data Management**: Enter and validate blood gas measurements
- **Results Analysis**: Get detailed interpretation of ABG results
- **Follow-up Tracking**: Monitor patient progress over time
- **COPD-specific Tools**: Specialized calculations for COPD patients

## Technical Features

- Cross-platform support (Windows, macOS, Linux, iOS, Android)
- Modern Material Design UI with adaptive layouts
- Responsive desktop window sizing
- Code push updates via Shorebird
- State management using Riverpod
- Platform-specific optimizations

## Requirements

- Flutter SDK >=3.2.3
- Dart SDK >=3.2.3
- For desktop development:
  - Windows: Visual Studio with C++ development tools
  - macOS: Xcode
  - Linux: Required development libraries

## Installation

1. Clone the repository:
```bash
git clone [repository-url]
cd Aglan-ABG-App
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Dependencies

- flutter_riverpod: ^2.4.4 - State management
- google_fonts: ^6.1.0 - Custom typography
- adaptive_dialog: ^2.0.0 - Platform-adaptive dialogs
- rflutter_alert: ^2.0.7 - Alert dialogs
- url_launcher: ^6.1.14 - URL handling
- mailer: ^6.0.1 - Email functionality
- desktop_window: ^0.4.0 - Desktop window management
- universal_platform: ^1.0.0+1 - Platform detection

## Project Structure

The project follows a clean architecture pattern:

- `lib/`
  - `views/` - UI components (pages, organisms, molecules, atoms)
  - `models/` - Data models
  - `services/` - Business logic and calculators
  - `providers/` - State management
  - `resources/` - Constants, themes, and assets
  - `generated/` - Auto-generated code

## Building for Production

### Desktop
```bash
flutter build windows
flutter build macos
flutter build linux
```

### Mobile
```bash
flutter build apk
flutter build ios
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Version

Current version: 0.3.0+4
