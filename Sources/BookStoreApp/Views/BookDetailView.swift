import SwiftUI

struct BookDetailView: View {
    let book: Book
    var onSale: (() -> Void)? = nil
    
    @State private var saleFailed = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Book information
                VStack(alignment: .leading, spacing: 10) {
                    Text(book.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    HStack {
                        Text("by \(book.author)")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(book.price) KRW")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    HStack(spacing: 12) {
                        Text(book.genre)
                            .font(.subheadline)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(5)
                        
                        Text("재고 \(book.stock)권")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(book.stock > 0 ? .green : .red)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background((book.stock > 0 ? Color.green : Color.red).opacity(0.1))
                            .cornerRadius(5)
                        
                        Spacer()
                        
                        if let onSale = onSale {
                            Button {
                                onSale()
                                saleFailed = book.stock <= 0
                            } label: {
                                Label("판매 등록 (1권)", systemImage: "cart.badge.plus")
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(book.stock <= 0)
                        }
                    }
                    
                    if saleFailed {
                        Text("재고가 부족하여 판매를 등록할 수 없습니다.")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                Divider()
                
                // Book details
                VStack(alignment: .leading, spacing: 15) {
                    Text("Details")
                        .font(.headline)
                    
                    Grid {
                        GridRow {
                            Text("Book ID:")
                                .fontWeight(.semibold)
                            Text(book.bookID)
                        }
                        
                        GridRow {
                            Text("Publisher:")
                                .fontWeight(.semibold)
                            Text(book.publisher)
                        }
                        
                        GridRow {
                            Text("ISBN:")
                                .fontWeight(.semibold)
                            Text(book.isbn)
                        }
                        
                        GridRow {
                            Text("Created:")
                                .fontWeight(.semibold)
                            Text(formatDate(book.createdAt))
                        }
                    }
                }
                
                Divider()
                
                // Description
                VStack(alignment: .leading, spacing: 10) {
                    Text("Description")
                        .font(.headline)
                    Text(book.description)
                        .foregroundColor(.primary)
                }
                
                Divider()
                
                // QR Code
                VStack(alignment: .leading, spacing: 10) {
                    Text("QR Code")
                        .font(.headline)
                    
                    if let qrImage = QRCodeGenerator.generateBookQRCode(for: book) {
                        Image(nsImage: qrImage)
                            .resizable()
                            .frame(width: 200, height: 200)
                            .padding()
                    } else {
                        Text("Failed to generate QR code")
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}