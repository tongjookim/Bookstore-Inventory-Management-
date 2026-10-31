import Foundation
import AppKit

class QRCodeGenerator {
    
    static func generateQRCode(for text: String) -> NSImage? {
        // Create a QR Code filter
        guard let data = text.data(using: .isoLatin1, allowLossyConversion: false) else {
            return nil
        }
        
        // Generate QR code using CIFilter
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter?.setValue(data, forKey: "inputMessage")
        qrFilter?.setValue("M", forKey: "inputCorrectionLevel") // Medium correction level
        
        guard let qrCodeImage = qrFilter?.outputImage else {
            return nil
        }
        
        // Create a high-resolution QR code image
        let context = CIContext()
        guard let cgImage = context.createCGImage(qrCodeImage, from: qrCodeImage.extent) else {
            return nil
        }
        
        // Convert to NSImage
        let nsImage = NSImage(cgImage: cgImage, size: NSSize(width: 200, height: 200))
        return nsImage
    }
    
    static func generateBookQRCode(for book: Book) -> NSImage? {
        let qrText = "Book ID: \(book.bookID)\nTitle: \(book.title)"
        return generateQRCode(for: qrText)
    }
}