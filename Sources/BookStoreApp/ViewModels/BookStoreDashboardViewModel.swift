import Foundation
import Combine

/// 대시보드 전용 View Model
final class BookStoreDashboardViewModel: ObservableObject {
    @Published private(set) var bookCount = 0        // 도서 등록 건수
    @Published private(set) var saleCount = 0        // 판매 건수 (판매된 총 수량)
    @Published private(set) var totalStock = 0       // 총 재고
    @Published private(set) var topSearchedBooks: [BookSearchStat] = []
    @Published private(set) var topSellingBooks: [BookSalesStat] = []
    @Published private(set) var lastUpdated: Date?
    
    private let databaseManager: DatabaseManager
    
    init(databaseManager: DatabaseManager = .shared) {
        self.databaseManager = databaseManager
        reload()
    }
    
    /// DB 에서 최신 통계를 다시 읽어옵니다.
    func reload() {
        let summary = databaseManager.dashboardSummary()
        bookCount = summary.bookCount
        saleCount = summary.saleCount
        totalStock = summary.totalStock
        topSearchedBooks = databaseManager.topSearchedBooks(limit: 5)
        topSellingBooks = databaseManager.topSellingBooks(limit: 5)
        lastUpdated = Date()
    }
    
    // MARK: - 데이터 초기화
    
    func resetSales() {
        databaseManager.resetSales()
        reload()
    }
    
    func resetSearchLogs() {
        databaseManager.resetSearchLogs()
        reload()
    }
    
    func resetStock() {
        databaseManager.resetStock()
        reload()
    }
    
    func resetAllData() {
        databaseManager.resetAllData()
        reload()
    }
}
