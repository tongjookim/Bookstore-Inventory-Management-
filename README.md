# BookStoreApp

A macOS desktop application for managing a bookstore's inventory system, migrated from a Flask web application to Swift.

## Features

- **Admin Authentication**: Login with password "admin123"
- **Book Management**: Add, view, edit, and delete books
- **Search Functionality**: Search by title, author, book ID, or ISBN
- **QR Code Generation**: Generate QR codes for books
- **Database Storage**: SQLite database using GRDB.swift

## Requirements

- macOS 12.0 or higher
- Xcode 14.0 or higher (for building)
- Swift 5.9 or higher

## Installation

1. Clone or download this repository
2. Open Terminal and navigate to the project directory:
   ```bash
   cd /Users/kimtongjoo/Documents/webproj/서점도서관리프로그램/BookStoreApp
   ```
3. Generate Xcode project:
   ```bash
   swift package generate-xcodeproj
   ```
4. Open the generated project in Xcode:
   ```bash
   open BookStoreApp.xcodeproj
   ```

## Usage

1. Build and run the application in Xcode (Cmd+R)
2. Login with admin credentials (password: "admin123")
3. Browse books, search for specific titles, or add new books
4. Click on any book to view its details and generate a QR code

## Project Structure

```
Sources/
├── BookStoreApp/
│   ├── main.swift                 # Application entry point
│   ├── AppDelegate.swift          # Application delegate
│   ├── Views/
│   │   ├── ContentView.swift      # Main application view
│   │   ├── LoginView.swift        # Admin login screen
│   │   ├── BookListView.swift     # Book listing and search
│   │   └── BookDetailView.swift   # Individual book details with QR code
│   ├── Models/
│   │   ├── Book.swift             # Book data model
│   │   └── AuthManager.swift      # Authentication manager
│   ├── ViewModels/
│   │   └── BookStoreViewModel.swift # Application state management
│   ├── Database/
│   │   └── DatabaseManager.swift  # Database operations with GRDB.swift
│   └── QRCode/
│       └── QRCodeGenerator.swift  # QR code generation
```

## Database

The application uses SQLite database through GRDB.swift. The database file is automatically created in the application's documents directory on first launch.

## QR Code Generation

QR codes are generated using Core Image framework (CIFilter) with medium correction level for reliable scanning.

## Building and Running

After generating the Xcode project, simply build and run the application:
1. Select the BookStoreApp target
2. Press Cmd+R to build and run

The application will automatically initialize the database schema on first launch.