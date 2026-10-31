import Foundation
import Combine

class BookStoreViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var selectedBook: Book? = nil
    @Published var isShowingAddForm = false
    @Published var searchText = ""
    
    private let databaseManager = DatabaseManager.shared
    
    init() {
        loadBooks()
    }
    
    func loadBooks() {
        books = databaseManager.getAllBooks()
        
        // 선택된 도서가 삭제되었다면 선택 상태를 해제
        if let selected = selectedBook,
           !books.contains(where: { $0.bookID == selected.bookID }) {
            selectedBook = nil
        }
    }
    
    func searchBooks(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.isEmpty {
            loadBooks()
        } else {
            books = databaseManager.searchBooks(query: trimmed)
            // 검색 결과로 노출된 도서의 검색 횟수 기록
            databaseManager.recordSearches(for: books, query: trimmed)
        }
    }
    
    func addBook(_ book: Book) {
        if databaseManager.insertBook(book) {
            loadBooks()
        }
    }
    
    func updateBook(_ book: Book) {
        if databaseManager.updateBook(book) {
            loadBooks()
            if let selected = selectedBook, selected.bookID == book.bookID {
                selectedBook = books.first { $0.bookID == book.bookID }
            }
        }
    }
    
    func deleteBook(bookID: String) {
        if databaseManager.deleteBook(bookID: bookID) {
            if selectedBook?.bookID == bookID {
                selectedBook = nil
            }
            loadBooks()
        }
    }
    
    /// 판매를 등록하고 재고/선택 상태를 갱신합니다.
    @discardableResult
    func sellBook(bookID: String, quantity: Int = 1) -> Bool {
        guard databaseManager.recordSale(bookID: bookID, quantity: quantity) else {
            return false
        }
        loadBooks()
        selectedBook = books.first { $0.bookID == bookID }
        return true
    }
    
    func selectBook(_ book: Book) {
        selectedBook = book
    }
}
