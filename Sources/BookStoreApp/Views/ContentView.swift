import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BookStoreViewModel()
    
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("대시보드", systemImage: "square.grid.2x2")
                }
            
            BookManagementView(viewModel: viewModel)
                .tabItem {
                    Label("도서 관리", systemImage: "books.vertical")
                }
        }
        .frame(minWidth: 900, minHeight: 620)
    }
}

/// 도서 목록 + 상세 화면
struct BookManagementView: View {
    @ObservedObject var viewModel: BookStoreViewModel
    
    @State private var activeSheet: BookSheet?
    
    /// 추가/수정 폼을 하나의 시트로 관리
    private enum BookSheet: Identifiable {
        case add
        case edit(Book)
        
        var id: String {
            switch self {
            case .add:
                return "add"
            case .edit(let book):
                return "edit-\(book.bookID)"
            }
        }
    }
    
    var body: some View {
        NavigationSplitView {
            BookListView(viewModel: viewModel) { book in
                activeSheet = .edit(book)
            }
            .navigationTitle("도서 관리")
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        activeSheet = .add
                    } label: {
                        Label("도서 추가", systemImage: "plus")
                    }
                    
                    Button {
                        if let book = viewModel.selectedBook {
                            activeSheet = .edit(book)
                        }
                    } label: {
                        Label("수정", systemImage: "pencil")
                    }
                    .disabled(viewModel.selectedBook == nil)
                    
                    Button(role: .destructive) {
                        if let book = viewModel.selectedBook {
                            viewModel.deleteBook(bookID: book.bookID)
                        }
                    } label: {
                        Label("삭제", systemImage: "trash")
                    }
                    .disabled(viewModel.selectedBook == nil)
                }
            }
        } detail: {
            if let book = viewModel.selectedBook {
                BookDetailView(book: book) {
                    viewModel.sellBook(bookID: book.bookID)
                }
                .navigationTitle(book.title)
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "book")
                        .font(.system(size: 80))
                        .foregroundColor(.gray)
                    Text("도서를 선택하면 상세 정보가 표시됩니다.")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear {
            viewModel.loadBooks()
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .add:
                BookFormView(book: nil, viewModel: viewModel)
            case .edit(let book):
                BookFormView(book: book, viewModel: viewModel)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
