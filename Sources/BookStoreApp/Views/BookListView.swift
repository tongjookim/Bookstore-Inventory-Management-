import SwiftUI

struct BookListView: View {
    @ObservedObject var viewModel: BookStoreViewModel
    var onEdit: ((Book) -> Void)? = nil
    
    var body: some View {
        VStack {
            SearchBar(text: $viewModel.searchText) { text in
                viewModel.searchBooks(text)
            }
            
            if viewModel.books.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    Text("도서가 없습니다.")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(viewModel.books, id: \.id) { book in
                    HStack(spacing: 8) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(book.title)
                                .font(.headline)
                            Text("by \(book.author)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            HStack(spacing: 8) {
                                Text("\(book.price) KRW")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                Text("재고 \(book.stock)권")
                                    .font(.caption)
                                    .foregroundColor(book.stock > 0 ? .green : .red)
                            }
                        }
                        
                        Spacer(minLength: 8)
                        
                        if let qrImage = QRCodeGenerator.generateBookQRCode(for: book) {
                            Image(nsImage: qrImage)
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        
                        // 수정 / 삭제 버튼
                        HStack(spacing: 4) {
                            Button {
                                onEdit?(book)
                            } label: {
                                Image(systemName: "pencil")
                            }
                            .buttonStyle(.borderless)
                            .help("도서 수정")
                            .disabled(onEdit == nil)
                            
                            Button(role: .destructive) {
                                viewModel.deleteBook(bookID: book.bookID)
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(.borderless)
                            .help("도서 삭제")
                        }
                    }
                    .padding(.vertical, 2)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.selectBook(book)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            viewModel.deleteBook(bookID: book.bookID)
                        } label: {
                            Label("삭제", systemImage: "trash")
                        }
                    }
                    .contextMenu {
                        Button {
                            onEdit?(book)
                        } label: {
                            Label("수정", systemImage: "pencil")
                        }
                        
                        Button(role: .destructive) {
                            viewModel.deleteBook(bookID: book.bookID)
                        } label: {
                            Label("삭제", systemImage: "trash")
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct BookListView_Previews: PreviewProvider {
    static var previews: some View {
        BookListView(viewModel: BookStoreViewModel())
    }
}
