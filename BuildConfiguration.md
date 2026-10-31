# BookStoreApp Build Configuration

## Project Structure
```
BookStoreApp/
├── Package.swift
├── Sources/
│   └── BookStoreApp/
│       ├── main.swift
│       ├── AppDelegate.swift
│       ├── ViewController.swift
│       ├── Views/
│       │   ├── ContentView.swift
│       │   ├── LoginView.swift
│       │   ├── BookListView.swift
│       │   └── BookDetailView.swift
│       ├── Models/
│       │   ├── Book.swift
│       │   └── AuthManager.swift
│       ├── ViewModels/
│       │   └── BookStoreViewModel.swift
│       ├── Database/
│       │   └── DatabaseManager.swift
│       └── QRCode/
│           └── QRCodeGenerator.swift
└── Resources/
    └── Assets.xcassets
```

## Package.swift Configuration

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BookStoreApp",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(
            name: "BookStoreApp",
            targets: ["BookStoreApp"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/groue/GRDB.swift.git", from: "6.0.0")
    ],
    targets: [
        .target(
            name: "BookStoreApp",
            dependencies: [
                .product(name: "GRDB", package: "GRDB.swift")
            ],
            path: "Sources/BookStoreApp"
        )
    ]
)
```

## Build Instructions

1. Open Terminal
2. Navigate to the project directory:
   ```bash
   cd /Users/kimtongjoo/Documents/webproj/서점도서관리프로그램/BookStoreApp
   ```

3. Generate Xcode project:
   ```bash
   swift package generate-xcodeproj
   ```

4. Open generated project in Xcode:
   ```bash
   open BookStoreApp.xcodeproj
   ```

## Required Xcode Settings

1. In Xcode project settings:
   - Set Deployment Target to macOS 12.0 or higher
   - Enable "App Sandbox" for security
   - Configure entitlements for database access if needed

2. For QR code functionality:
   - No additional framework requirements (uses Core Image)

3. Database setup:
   - The app will automatically create a SQLite database in the application's documents directory

## Running the Application

1. Open Xcode project
2. Select target "BookStoreApp"
3. Build and run (Cmd+R)

The application will:
- Create a database file on first launch
- Require admin login with password "admin123"
- Display book listings with search functionality
- Generate QR codes for books when viewing details