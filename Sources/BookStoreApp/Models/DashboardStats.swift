import Foundation

// 검색 횟수 기준 인기 도서
struct BookSearchStat: Identifiable {
    let id: String        // book_id
    let title: String
    let author: String
    let searchCount: Int
    let lastSearchedAt: Date?
}

// 판매량 기준 인기 도서
struct BookSalesStat: Identifiable {
    let id: String        // book_id
    let title: String
    let author: String
    let soldQuantity: Int
    let revenue: Int
    let lastSoldAt: Date?
}

// 대시보드 상단 요약 카드 값
struct DashboardSummary {
    var bookCount: Int = 0      // 도서 등록 건수
    var saleCount: Int = 0      // 판매 건수 (판매된 총 수량)
    var totalStock: Int = 0     // 총 재고
}
