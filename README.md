# Resume Builder App

This is a simple Flutter app that lets you create, edit, and export professional resumes. It’s built
with clean architecture, uses SQLite for storing data locally, and allows exporting resumes as PDF.

## Features

- Add, edit, delete, and reorder sections like Personal Info, Education, Experience, Skills, and
  Projects.
- Live preview of your resume.
- Export resumes as PDF.
- Responsive design 
- Smooth navigation with slide transitions.

## Setup

1. Make sure you have Flutter SDK (>=3.24.0) installed.(  sdk: '>=3.0.0 <4.0.0'
   )
2. Clone the repository:
 
   git clone <https://github.com/Trilok1110/resume_builder.git>


3. Install dependencies:

flutter pub get

4. Run the app:

    `flutter run`

## Tech Stack

* Flutter for cross-platform UI.
* SQLite (`sqflite`) for local data persistence.
* Provider for state management.
* PDF package for exporting resumes.
* Material 3 for modern UI.

## Folder Structure

```
lib/
├── core/         # Theme, constants, utilities
├── data/         # Models, SQLite service, repositories
├── presentation/ # Providers, screens, widgets
```

## How to Use

1. Open the app and tap any section (like Education or Skills) to add or edit items.
2. Drag and reorder items using the handle icon.
3. Preview your resume live using the "Preview" button.
4. Export it to PDF using the floating action button in the Preview screen.

## Notes

* The app focuses on simplicity, clean UI, and good user experience.
* Code is modular and easy to maintain.


Made with enthusiasm , Trilok Paliwal


