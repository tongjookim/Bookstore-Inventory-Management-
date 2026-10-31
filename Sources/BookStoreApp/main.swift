import SwiftUI
import AppKit

// Main application entry point
@main
struct BookStoreApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Setup database and initial data if needed
                    // The DatabaseManager initializes itself on creation, so we just need to access it once
                    _ = DatabaseManager.shared
                }
        }
        .windowToolbarStyle(.unified)
    }
}

// Application delegate for handling application lifecycle events
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Application did finish launching
        print("BookStoreApp launched successfully")
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Application will terminate
        print("BookStoreApp terminating")
    }
}