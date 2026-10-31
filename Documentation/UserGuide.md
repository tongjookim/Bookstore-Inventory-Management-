# BookStoreApp User Guide

## Overview
BookStoreApp is a macOS desktop application for managing a bookstore's inventory system. It provides functionality for adding, viewing, editing, and deleting books, with admin authentication, search capabilities, and QR code generation features.

## Features
- Admin Authentication: Secure login with the initial password "admin123"
- Book Management: Add, view, edit, and delete book records
- Search Functionality: Search by title, author, book ID, or ISBN
- QR Code Generation: Generate QR codes for each book
- Database Storage: SQLite database using GRDB.swift

## Getting Started

### Prerequisites
- macOS 12.0 or higher
- Xcode 14.0 or higher (for building)

### Installation
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

## Using the Application

### Logging In
1. Run the application from Xcode (Cmd+R) or build and run it
2. You will be presented with a login screen
3. Enter the password "admin123" to gain access to the admin features
4. If you have forgotten the password, you can reset it through the database manager code

### Managing Books
Once logged in, you'll see the main book list view:

#### Viewing Books
- The application displays all books in a table format
- Scrollable list showing book information including title, author, publisher, genre, price, and ISBN

#### Adding Books
1. Click the "+" button or select "Add New Book" from the menu
2. Fill in the book details:
   - Title (required)
   - Author (required)
   - Publisher
   - Genre
   - Price
   - ISBN
   - Description
3. Click "Save" to add the book to the database

#### Editing Books
1. Select a book from the list
2. Click "Edit" or double-click on the book entry
3. Modify the details as needed
4. Click "Update" to save changes

#### Deleting Books
1. Select a book from the list
2. Click "Delete" or use the delete key
3. Confirm deletion when prompted

### Searching Books
Use the search bar at the top of the main window:
- Search by title, author, book ID, or ISBN
- Results update in real-time as you type
- Clear the search field to view all books again

### QR Code Generation
1. Select a book from the list
2. Click on the "QR Code" button (represented by a QR code icon)
3. A new window will display the generated QR code for that book
4. The QR code contains information about the book including ID and title

## Security Considerations

### Admin Authentication
- The app uses a simple password-based authentication system
- Initial password is "admin123"
- Password is stored as plain text in this implementation (not recommended for production)
- For production use, consider implementing more robust authentication methods

### Data Storage
- All data is stored locally using SQLite database
- Database file is located in the application's Documents directory
- No network connectivity required for operation

## Troubleshooting

### Application Won't Start
If the application fails to start:
1. Ensure you have macOS 12.0 or higher
2. Verify Xcode 14.0 or newer is installed
3. Clean and rebuild the project in Xcode

### Database Connection Issues
If database related errors occur:
1. Check that the Documents directory has write permissions
2. Verify no other instance of the app is running
3. Consider resetting the database by deleting the bookstore.db file in Documents

### Login Failure
If you cannot log in with the default password "admin123":
1. Ensure the password hasn't been changed
2. Check if the admin user exists in the database
3. Refer to the developer documentation for changing credentials programmatically

## Support

For issues or questions about BookStoreApp, please contact your system administrator or check our GitHub repository.