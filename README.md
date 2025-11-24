# Daily Mood & Habit Tracker

A  Flutter application that helps you track your daily mood and habits, enabling you to build better routines and gain insights into your well-being patterns.

##  Features

### Daily Tracking
- **Mood Tracking**: Select your daily mood from 8 emoji options (😊 Happy, 😴 Tired, 😰 Stressed, 😌 Calm, 😢 Sad, 😃 Excited, 😔 Down, 😐 Neutral)
- **Habit Tracking**: Mark your daily habits as completed with an intuitive checkbox interface
- **Daily Entries**: Save your mood and completed habits for each day
- **Visual Feedback**: Color-coded mood selection with clear visual indicators

### History & Insights
- **View Past Entries**: Browse all your previous daily entries
- **Filter Options**: Filter entries by:
  - All time
  - Last week
  - Last month
- **Entry Details**: See mood, date, and habit completion statistics for each entry

### Habit Management
- **Custom Habits**: Add, edit, and delete your personal habits
- **Default Habits**: Pre-configured with common habits:
  - Drank water
  - Studied
  - Exercised
  - Slept early
- **Easy Management**: Simple interface to customize your habit list

## 🛠️ Technology Stack

- **Framework**: Flutter
- **Language**: Dart
- **Storage**: SharedPreferences (local data persistence)
- **UI**: Material Design 3
- **Dependencies**:
  - `shared_preferences: ^2.2.2` - Local data storage
  - `intl: ^0.19.0` - Date formatting and internationalization
  - `cupertino_icons: ^1.0.8` - iOS-style icons



##  Installation

1. **Clone the repository**
   git clone https://github.com/zahraasaleh64/DailyRoutine.git
   cd DailyRoutine
   2. **Install dependencies**
   
   flutter pub get
   3. **Run the app**
   flutter run
   ## 📖 Usage

### Getting Started
1. Launch the app - you'll see today's date and the mood selection interface
2. Select your mood by tapping on one of the emoji options
3. Check off the habits you've completed today
4. Tap "Save Today" to store your entry

### Managing Habits
1. Tap the Settings icon  in the app bar
2. Use the "Add New Habit" button to create custom habits
3. Tap the edit icon to modify a habit's name
4. Tap the delete icon  to remove a habit

### Viewing History
1. Tap the History icon  in the app bar
2. Use the filter buttons (All/Week/Month) to view entries from different time periods
3. Pull down to refresh the history list

## Project Structure
lib/
├── main.dart                 # App entry point and theme configuration
├── models/
│   ├── daily_entry.dart     # Daily entry data model
│   ├── habit.dart           # Habit data model
│   └── mood_entry.dart      # Mood entry data model
├── screens/
│   ├── home_screen.dart     # Main tracking screen
│   ├── history_screen.dart  # History and past entries view
│   └── settings_screen.dart # Habit management screen
└── services/
    └── data_service.dart    # Data persistence service (SharedPreferences)

##Viewing History
Tap the History icon  in the app bar
Use the filter buttons (All/Week/Month) to view entries from different time periods
Pull down to refresh the history list

 ##Data Storage
The app uses SharedPreferences to store data locally on your device:
Daily Entries: Stored as JSON with date keys (format: "yyyy-MM-dd")
Habits: Stored as a JSON array
All data persists between app session

##Settings Screen
List of all habits with edit/delete options
Add new habit dialog
Confirmation dialogs for destructive actions

##Features in Detail
Home Screen
Displays current date
Interactive mood selector with 8 mood options
Habit checklist with visual completion indicators
Save button with success feedback
Navigation to History and Settings

##History Screen
Chronological list of all entries (newest first)
Filter by time period (All/Week/Month)
Shows mood emoji, date, and habit completion ratio
Pull-to-refresh functionality

##Settings Screen
List of all habits with edit/delete options
Add new habit dialog
Confirmation dialogs for destructive actions
