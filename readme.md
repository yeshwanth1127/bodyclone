# BodyClone

A mobile application built with Flutter and Python backend.

## Project Structure

```
bodyclone/
├── lib/                    # Flutter app source code
│   ├── main.dart          # App entry point
│   └── screens/           # App screens
│       └── splash_screen.dart
├── backend/               # Python backend
│   ├── app.py            # Flask application
│   └── requirements.txt  # Python dependencies
└── pubspec.yaml          # Flutter dependencies
```

## Setup Instructions

### Flutter App

1. Make sure Flutter is installed on your system
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

### Python Backend

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Create a virtual environment:
   ```bash
   python -m venv venv
   ```
3. Activate the virtual environment:
   - Windows: `venv\Scripts\activate`
   - macOS/Linux: `source venv/bin/activate`
4. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
5. Run the backend server:
   ```bash
   python app.py
   ```

The backend will run on `http://localhost:5000`

## Features

- Splash screen with logo and branding
- RESTful API backend
- CORS enabled for mobile app communication

## Next Steps

- Replace the logo placeholder with your actual logo asset
- Add more screens and navigation
- Implement API endpoints for your app features

