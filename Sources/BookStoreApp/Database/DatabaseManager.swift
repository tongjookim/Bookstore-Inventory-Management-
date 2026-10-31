import Foundation
import GRDB

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private var dbQueue: DatabaseQueue?
    private let dbPath: String
    
    private init() {
        // Set up the database path
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        dbPath = "\(documentsPath)/bookstore.db"
        
        setupDatabase()
    }
    
    private func setupDatabase() {
        do {
            dbQueue = try DatabaseQueue(path: dbPath)
            createTables()
        } catch {
            print("Failed to initialize database: \(error)")
        }
    }
    
    private func createTables() {
        guard let dbQueue = dbQueue else { return }
        
        do {
            try dbQueue.write { db in
                // Create books table if it doesn't exist
                try db.execute(sql: """
                    CREATE TABLE IF NOT EXISTS books (
                        book_id TEXT PRIMARY KEY,
                        title TEXT NOT NULL,
                        author TEXT NOT NULL,
                        publisher TEXT,
                        genre TEXT,
                        price INTEGER,
                        stock INTEGER NOT NULL DEFAULT 0,
                        isbn TEXT,
                        description TEXT,
                        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
                    )
                """)
                
                // 기존 데이터베이스에 stock 컬럼이 없으면 추가 (마이그레이션)
                let bookColumns = try db.columns(in: "books").map(\.name)
                if !bookColumns.contains("stock") {
                    try db.alter(table: "books") { table in
                        table.add(column: "stock", .integer).notNull().defaults(to: 0)
                    }
                }
                
                // 판매 기록 테이블
                try db.execute(sql: """
                    CREATE TABLE IF NOT EXISTS sales (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        book_id TEXT NOT NULL,
                        quantity INTEGER NOT NULL DEFAULT 1,
                        unit_price INTEGER NOT NULL DEFAULT 0,
                        sold_at DATETIME NOT NULL
                    )
                """)
                
                // 검색 기록 테이블
                try db.execute(sql: """
                    CREATE TABLE IF NOT EXISTS search_logs (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        book_id TEXT NOT NULL,
                        query TEXT NOT NULL,
                        searched_at DATETIME NOT NULL
                    )
                """)
            }
        } catch {
            print("Error creating tables: \(error)")
        }
    }
    
    // MARK: - Book CRUD
    
    func insertBook(_ book: Book) -> Bool {
        guard let dbQueue = dbQueue else { return false }
        
        do {
            try dbQueue.write { db in
                try db.execute(sql: """
                    INSERT INTO books (
                        book_id, title, author, publisher, genre, price, stock, isbn, description, created_at, updated_at
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """, arguments: [
                    book.bookID,
                    book.title,
                    book.author,
                    book.publisher,
                    book.genre,
                    book.price,
                    book.stock,
                    book.isbn,
                    book.description,
                    book.createdAt,
                    book.updatedAt
                ])
            }
            return true
        } catch {
            print("Error inserting book: \(error)")
            return false
        }
    }
    
    func updateBook(_ book: Book) -> Bool {
        guard let dbQueue = dbQueue else { return false }
        
        do {
            try dbQueue.write { db in
                try db.execute(sql: """
                    UPDATE books SET 
                        title = ?, author = ?, publisher = ?, genre = ?, price = ?, stock = ?,
                        isbn = ?, description = ?, updated_at = ?
                    WHERE book_id = ?
                """, arguments: [
                    book.title,
                    book.author,
                    book.publisher,
                    book.genre,
                    book.price,
                    book.stock,
                    book.isbn,
                    book.description,
                    book.updatedAt,
                    book.bookID
                ])
            }
            return true
        } catch {
            print("Error updating book: \(error)")
            return false
        }
    }
    
    func deleteBook(bookID: String) -> Bool {
        guard let dbQueue = dbQueue else { return false }
        
        do {
            try dbQueue.write { db in
                try db.execute(sql: "DELETE FROM books WHERE book_id = ?", arguments: [bookID])
            }
            return true
        } catch {
            print("Error deleting book: \(error)")
            return false
        }
    }
    
    func getAllBooks() -> [Book] {
        guard let dbQueue = dbQueue else { return [] }
        
        do {
            return try dbQueue.read { db in
                let rows = try Row.fetchAll(db, sql: "SELECT * FROM books ORDER BY created_at DESC")
                return rows.map(Self.makeBook(from:))
            }
        } catch {
            print("Error retrieving books: \(error)")
            return []
        }
    }
    
    func searchBooks(query: String) -> [Book] {
        guard let dbQueue = dbQueue else { return [] }
        
        do {
            return try dbQueue.read { db in
                // Search in title, author, book_id, and isbn
                let rows = try Row.fetchAll(db, sql: """
                    SELECT * FROM books 
                    WHERE title LIKE ? OR author LIKE ? OR book_id LIKE ? OR isbn LIKE ?
                    ORDER BY created_at DESC
                """, arguments: [
                    "%\(query)%",
                    "%\(query)%",
                    "%\(query)%",
                    "%\(query)%"
                ])
                
                return rows.map(Self.makeBook(from:))
            }
        } catch {
            print("Error searching books: \(error)")
            return []
        }
    }
    
    func getBook(byID bookID: String) -> Book? {
        guard let dbQueue = dbQueue else { return nil }
        
        do {
            return try dbQueue.read { db in
                guard let row = try Row.fetchOne(db, sql: "SELECT * FROM books WHERE book_id = ?", arguments: [bookID]) else {
                    return nil
                }
                return Self.makeBook(from: row)
            }
        } catch {
            print("Error retrieving book: \(error)")
            return nil
        }
    }
    
    private static func makeBook(from row: Row) -> Book {
        Book(
            bookID: row["book_id"],
            title: row["title"],
            author: row["author"],
            publisher: row["publisher"] ?? "",
            genre: row["genre"] ?? "",
            price: row["price"] ?? 0,
            stock: row["stock"] ?? 0,
            isbn: row["isbn"] ?? "",
            description: row["description"] ?? "",
            createdAt: row["created_at"] ?? Date(),
            updatedAt: row["updated_at"] ?? Date()
        )
    }
    
    // MARK: - Sales
    
    /// 판매를 기록하고 재고를 차감합니다. 재고가 부족하면 false 를 반환합니다.
    @discardableResult
    func recordSale(bookID: String, quantity: Int = 1) -> Bool {
        guard quantity > 0, let dbQueue = dbQueue else { return false }
        
        do {
            return try dbQueue.write { db -> Bool in
                guard let row = try Row.fetchOne(
                    db,
                    sql: "SELECT price, stock FROM books WHERE book_id = ?",
                    arguments: [bookID]
                ) else {
                    return false
                }
                
                let price: Int = row["price"] ?? 0
                let stock: Int = row["stock"] ?? 0
                let sold = min(quantity, stock)
                guard sold > 0 else { return false }
                
                try db.execute(sql: """
                    INSERT INTO sales (book_id, quantity, unit_price, sold_at)
                    VALUES (?, ?, ?, ?)
                """, arguments: [bookID, sold, price, Date()])
                
                try db.execute(sql: """
                    UPDATE books SET stock = stock - ?, updated_at = ? WHERE book_id = ?
                """, arguments: [sold, Date(), bookID])
                
                return true
            }
        } catch {
            print("Error recording sale: \(error)")
            return false
        }
    }
    
    // MARK: - Search Logs
    
    /// 검색 결과로 노출된 도서들의 검색 횟수를 기록합니다.
    func recordSearches(for books: [Book], query: String) {
        guard !books.isEmpty, let dbQueue = dbQueue else { return }
        
        do {
            try dbQueue.write { db in
                for book in books {
                    try db.execute(sql: """
                        INSERT INTO search_logs (book_id, query, searched_at)
                        VALUES (?, ?, ?)
                    """, arguments: [book.bookID, query, Date()])
                }
            }
        } catch {
            print("Error recording search: \(error)")
        }
    }
    
    // MARK: - Dashboard Statistics
    
    /// 대시보드 상단 요약 값 (도서 등록 건수 / 총 판매 수량 / 총 재고)
    func dashboardSummary() -> DashboardSummary {
        guard let dbQueue = dbQueue else { return DashboardSummary() }
        
        do {
            return try dbQueue.read { db in
                var summary = DashboardSummary()
                summary.bookCount = try Int.fetchOne(db, sql: "SELECT COUNT(*) FROM books") ?? 0
                summary.saleCount = try Int.fetchOne(db, sql: "SELECT COALESCE(SUM(quantity), 0) FROM sales") ?? 0
                summary.totalStock = try Int.fetchOne(db, sql: "SELECT COALESCE(SUM(stock), 0) FROM books") ?? 0
                return summary
            }
        } catch {
            print("Error loading dashboard summary: \(error)")
            return DashboardSummary()
        }
    }
    
    /// 최근 고객이 많이 검색한 도서 목록
    func topSearchedBooks(limit: Int = 5) -> [BookSearchStat] {
        guard let dbQueue = dbQueue else { return [] }
        
        do {
            return try dbQueue.read { db in
                let rows = try Row.fetchAll(db, sql: """
                    SELECT b.book_id AS book_id,
                           b.title AS title,
                           b.author AS author,
                           COUNT(s.id) AS search_count,
                           MAX(s.searched_at) AS last_searched_at
                    FROM search_logs s
                    JOIN books b ON b.book_id = s.book_id
                    GROUP BY s.book_id
                    ORDER BY search_count DESC, last_searched_at DESC
                    LIMIT ?
                """, arguments: [limit])
                
                return rows.map { row in
                    BookSearchStat(
                        id: row["book_id"],
                        title: row["title"],
                        author: row["author"] ?? "",
                        searchCount: row["search_count"] ?? 0,
                        lastSearchedAt: row["last_searched_at"]
                    )
                }
            }
        } catch {
            print("Error loading search stats: \(error)")
            return []
        }
    }
    
    /// 판매가 많은 도서 목록
    func topSellingBooks(limit: Int = 5) -> [BookSalesStat] {
        guard let dbQueue = dbQueue else { return [] }
        
        do {
            return try dbQueue.read { db in
                let rows = try Row.fetchAll(db, sql: """
                    SELECT b.book_id AS book_id,
                           b.title AS title,
                           b.author AS author,
                           SUM(s.quantity) AS sold_quantity,
                           SUM(s.quantity * s.unit_price) AS revenue,
                           MAX(s.sold_at) AS last_sold_at
                    FROM sales s
                    JOIN books b ON b.book_id = s.book_id
                    GROUP BY s.book_id
                    ORDER BY sold_quantity DESC, revenue DESC
                    LIMIT ?
                """, arguments: [limit])
                
                return rows.map { row in
                    BookSalesStat(
                        id: row["book_id"],
                        title: row["title"],
                        author: row["author"] ?? "",
                        soldQuantity: row["sold_quantity"] ?? 0,
                        revenue: row["revenue"] ?? 0,
                        lastSoldAt: row["last_sold_at"]
                    )
                }
            }
        } catch {
            print("Error loading sales stats: \(error)")
            return []
        }
    }
    
    // MARK: - Data Reset
    
    /// 판매 기록을 모두 삭제합니다. (판매 건수/판매 순위 초기화)
    @discardableResult
    func resetSales() -> Bool {
        guard let dbQueue = dbQueue else { return false }
        
        do {
            try dbQueue.write { db in
                try db.execute(sql: "DELETE FROM sales")
            }
            return true
        } catch {
            print("Error resetting sales: \(error)")
            return false
        }
    }
    
    /// 검색 기록을 모두 삭제합니다. (인기 검색 도서 초기화)
    @discardableResult
    func resetSearchLogs() -> Bool {
        guard let dbQueue = dbQueue else { return false }
        
        do {
            try dbQueue.write { db in
                try db.execute(sql: "DELETE FROM search_logs")
            }
            return true
        } catch {
            print("Error resetting search logs: \(error)")
            return false
        }
    }
    
    /// 모든 도서의 재고를 0 으로 초기화합니다.
    @discardableResult
    func resetStock() -> Bool {
        guard let dbQueue = dbQueue else { return false }
        
        do {
            try dbQueue.write { db in
                try db.execute(sql: "UPDATE books SET stock = 0, updated_at = ?", arguments: [Date()])
            }
            return true
        } catch {
            print("Error resetting stock: \(error)")
            return false
        }
    }
    
    /// 도서, 판매 기록, 검색 기록을 모두 삭제합니다.
    @discardableResult
    func resetAllData() -> Bool {
        guard let dbQueue = dbQueue else { return false }
        
        do {
            try dbQueue.write { db in
                try db.execute(sql: "DELETE FROM sales")
                try db.execute(sql: "DELETE FROM search_logs")
                try db.execute(sql: "DELETE FROM books")
                // AUTOINCREMENT 카운터도 초기화
                try db.execute(sql: "DELETE FROM sqlite_sequence WHERE name IN ('sales', 'search_logs')")
            }
            return true
        } catch {
            print("Error resetting all data: \(error)")
            return false
        }
    }
}
