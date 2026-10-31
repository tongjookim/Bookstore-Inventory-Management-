# BookStoreApp Developer Guide

## Overview
BookStoreApp is a macOS desktop application developed in Swift using SwiftUI for the user interface and GRDB.swift for database operations. This document provides technical documentation for developers who want to understand, maintain, or extend this application.

## Architecture Overview
The application follows a clean architecture pattern with separation of concerns:

- **Models**: Define data structures for books and authentication
- **Views**: SwiftUI views that display information to the user
- **ViewModels**: Manage application state and business logic
- **Database Manager**: Handle database operations using GRDB.swift
- **AuthManager**: Manage authentication functionality

## Project Structure
```
BookStoreApp/
├── Sources/
│   └── BookStoreApp/
│       ├── Models/
│       │   ├── Book.swift
│       │   └── AuthManager.swift
│       ├── Views/
│       │   ├── ContentView.swift
│       │   ├── LoginView.swift
│       │   ├── BookListView.swift
│       │   └── BookDetailView.swift
│       ├── ViewModels/
│       │   └── BookStoreViewModel.swift
│       ├── Database/
│       │   └── DatabaseManager.swift
│       ├── QRCode/
│       │   └── QRCodeGenerator.swift
│       └── AppDelegate.swift
├── Package.swift
├── BuildConfiguration.md
├── README.md
└── Documentation/
    ├── UserGuide.md
    └── DeveloperGuide.md
```

## Technical Implementation Details

### Database Integration (GRDB.swift)
The application uses GRDB.swift for database operations with SQLite. The DatabaseManager class handles:
- Database connection and setup
- Book creation, reading, updating, and deletion operations
- Admin login verification
- Database schema initialization

### SwiftUI Views
The UI is built using SwiftUI with the following key components:

#### ContentView
Serves as the main application entry point that manages navigation between the login view and book list view.

#### LoginView
Implements the admin authentication screen with:
- Password input field
- Login button and validation
- Error handling for incorrect passwords
- Integration with AuthManager

#### BookListView
Displays the list of books with:
- Search functionality
- Table view showing book information
- Navigation to detailed views
- Add, edit, delete operations

#### BookDetailView
Shows detailed information about a specific book including:
- QR code generation
- Full book details display

### QR Code Generation
The QRCodeGenerator class uses CoreImage filters to generate QR codes that contain book-specific information including the book ID and title.

## Key Classes and Their Responsibilities

### Book Model (`Models/Book.swift`)
Defines the data structure for a book with properties:
- book_id (UUID)
- title (String)
- author (String)
- publisher (String?)
- genre (String?)
- price (Double?)
- isbn (String?)
- description (String?)
- created_at (Date)
- updated_at (Date)

### AuthManager (`Models/AuthManager.swift`)
Handles authentication with:
- Admin password verification
- Login status management
- Session handling

### DatabaseManager (`Database/DatabaseManager.swift`)
Implements database operations including:
- Database connection setup
- Book CRUD operations
- Admin user creation and verification
- Schema migration support

### BookStoreViewModel (`ViewModels/BookStoreViewModel.swift`)
Manages application state with:
- Book list and search functionality
- Selected book handling
- Authentication state
- Error handling
- Database operations

## Build Process

### Prerequisites
- macOS 12.0 or higher
- Xcode 14.0 or higher
- Swift 5.7 or higher

### Building the Application
To build and run the application:

1. Open Terminal and navigate to the project directory:
   ```bash
   cd /Users/kimtongjoo/Documents/webproj/서점도서관리프로그램/BookStoreApp
   ```

2. Generate Xcode project:
   ```bash
   swift package generate-xcodeproj
   ```

3. Open the generated project in Xcode:
   ```bash
   open BookStoreApp.xcodeproj
   ```

4. Build and run the application (Cmd+R) or build for release (Cmd+B)

### Package Dependencies
The application depends on GRDB.swift for database operations. The Package.swift file defines this dependency.

## Customization and Extension

### Adding New Features
To add new features to the application:
1. Create new models if needed in the Models directory
2. Implement new views in the Views directory
3. Add new functionality to ViewModels as required
4. Update DatabaseManager if database operations are needed
5. Ensure proper integration with existing components

### Modifying UI
The SwiftUI-based UI can be modified by editing the respective view files:
- ContentView.swift for main navigation structure
- LoginView.swift for authentication interface
- BookListView.swift for book listings
- BookDetailView.swift for detailed views

## Security Considerations

### Password Handling
The current implementation stores the admin password as plain text. For production applications:
- Implement proper password hashing using secure algorithms like Argon2 or bcrypt
- Add password strength requirements
- Consider implementing multi-factor authentication

### Database Security
- The database is stored locally in the user's Documents directory
- Ensure appropriate file permissions are set
- Consider encryption for sensitive data

## Testing
The application does not currently include automated tests. When adding new functionality:
1. Implement unit tests for data models and business logic
2. Create UI tests for major interactions
3. Test database operations thoroughly

## Troubleshooting
Common issues and solutions:

### Database Connection Errors
Check that the Documents directory can be written to and that no other instance of the app is running.

### Build Issues
- Ensure Xcode tools are up to date
- Clean build folder (Shift+Cmd+K) and rebuild
- Verify all dependencies are included in Package.swift

### UI Display Problems
- Check that SwiftUI views are correctly configured
- Verify proper data binding between views and ViewModels
- Confirm that all required dependencies are installed

## Deployment
To deploy the application:
1. Archive it in Xcode (Cmd+Shift+A)
2. Distribute through the Mac App Store or as a direct download
3. Include necessary documentation for end users

## Future Enhancements
Potential directions for future development:
- Implement data synchronization with cloud services
- Add support for barcode scanning
- Improve security features including proper password storage
- Add export/import functionality for book data
- Implement backup and restore features
- Add more search filters and sorting options