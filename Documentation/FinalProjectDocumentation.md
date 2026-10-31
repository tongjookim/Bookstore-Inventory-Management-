# BookStoreApp - Final Project Documentation

## Project Overview
This is a macOS desktop application for managing a bookstore's inventory system, migrated from a Flask web application to Swift. The application provides admin authentication, book management, search functionality, and QR code generation using native macOS capabilities.

## Features Implemented
- **Admin Authentication**: Login with password "admin123"
- **Book Management**: Add, view, edit, and delete books
- **Search Functionality**: Search by title, author, book ID, or ISBN
- **QR Code Generation**: Generate QR codes for books
- **Database Storage**: SQLite database using GRDB.swift

## Requirements
- macOS 12.0 or higher
- Xcode 14.0 or higher (for building)
- Swift 5.9 or higher

## Installation Instructions

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
3. Use the main interface to browse, search, and manage books
4. View book details including QR codes for each book

## Application Architecture

### Core Components:
- **DatabaseManager**: Handles all database operations using GRDB.swift
- **AuthManager**: Manages admin authentication
- **Book**: Data model representing a book record
- **QRCodeGenerator**: Generates QR codes for books
- **ViewModels and Views**: SwiftUI-based user interface components

### File Structure:
```
Sources/
├── BookStoreApp/
│   ├── Models/
│   │   └── Book.swift
│   ├── Database/
│   │   └── DatabaseManager.swift
│   ├── QRCode/
│   │   └── QRCodeGenerator.swift
│   ├── ViewModels/
│   │   └── BookStoreViewModel.swift
│   ├── Views/
│   │   ├── ContentView.swift
│   │   ├── LoginView.swift
│   │   ├── BookListView.swift
│   │   └── BookDetailView.swift
│   └── AuthManager.swift
```

## Database Schema
The application uses SQLite database with tables for storing book information:
- book_id (Primary Key)
- title
- author
- publisher
- genre
- price
- isbn
- description
- created_at
- updated_at

## Authentication Flow
1. Application starts and displays login screen
2. Admin enters password "admin123"
3. Upon successful authentication, main book list view is displayed
4. Logout button available in the main interface for admin to log out

## QR Code Functionality
Each book has a QR code generated based on its unique identifier. The QR codes use a medium error correction level and are displayed in the book detail view.

## Building and Running
To build and run the application:
1. Ensure Xcode 14+ is installed
2. Open the generated BookStoreApp.xcodeproj file in Xcode
3. Select the appropriate target (macOS)
4. Build and run with Command + R

## Known Limitations
- Password is hardcoded as "admin123" (should be improved in production environment)
- QR code generation uses medium correction level which can be adjusted if needed
- No data export functionality implemented

## Future Improvements
- Implement password change functionality for admin users
- Add user role management (additional users beyond admin)
- Implement data backup and restore features
- Add more advanced search filters
- Include data export options (CSV, PDF)

## Support
For issues or questions regarding this application, please contact the development team.

## License
This project is licensed under a proprietary license for the bookstore management system.