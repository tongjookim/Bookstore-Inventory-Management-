import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = BookStoreDashboardViewModel()
    @State private var pendingReset: ResetAction?
    
    /// 초기화 종류
    private enum ResetAction: String, Identifiable {
        case sales
        case searchLogs
        case stock
        case all
        
        var id: String { rawValue }
        
        var title: String {
            switch self {
            case .sales:
                return "판매 기록을 초기화할까요?"
            case .searchLogs:
                return "검색 기록을 초기화할까요?"
            case .stock:
                return "재고를 초기화할까요?"
            case .all:
                return "전체 데이터를 초기화할까요?"
            }
        }
        
        var message: String {
            switch self {
            case .sales:
                return "판매 건수와 판매 순위가 모두 초기화됩니다. 도서 정보는 유지됩니다."
            case .searchLogs:
                return "많이 검색된 도서 목록이 초기화됩니다. 도서와 판매 정보는 유지됩니다."
            case .stock:
                return "모든 도서의 재고가 0권으로 변경됩니다. 도서 정보는 유지됩니다."
            case .all:
                return "등록된 도서, 판매 기록, 검색 기록이 모두 삭제됩니다. 이 작업은 되돌릴 수 없습니다."
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // 헤더
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("대시보드")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("서점 운영 현황을 한눈에 확인하세요.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if let lastUpdated = viewModel.lastUpdated {
                        Text("업데이트: \(lastUpdated.formatted(date: .omitted, time: .standard))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Button {
                        viewModel.reload()
                    } label: {
                        Label("새로고침", systemImage: "arrow.clockwise")
                    }
                    .buttonStyle(.bordered)
                    
                    Menu {
                        Button {
                            pendingReset = .sales
                        } label: {
                            Label("판매 기록 초기화", systemImage: "cart")
                        }
                        
                        Button {
                            pendingReset = .searchLogs
                        } label: {
                            Label("검색 기록 초기화", systemImage: "magnifyingglass")
                        }
                        
                        Button {
                            pendingReset = .stock
                        } label: {
                            Label("재고 초기화", systemImage: "shippingbox")
                        }
                        
                        Divider()
                        
                        Button(role: .destructive) {
                            pendingReset = .all
                        } label: {
                            Label("전체 데이터 초기화", systemImage: "trash")
                        }
                    } label: {
                        Label("데이터 관리", systemImage: "slider.horizontal.3")
                    }
                    .menuStyle(.borderlessButton)
                    .fixedSize()
                    .help("데이터 초기화")
                }
                
                // 요약 카드
                HStack(spacing: 16) {
                    DashboardStatCard(
                        title: "도서 등록 건수",
                        value: "\(viewModel.bookCount)",
                        unit: "권",
                        icon: "books.vertical.fill",
                        color: .blue
                    )
                    
                    DashboardStatCard(
                        title: "판매 건수",
                        value: "\(viewModel.saleCount)",
                        unit: "권",
                        icon: "cart.fill",
                        color: .green
                    )
                    
                    DashboardStatCard(
                        title: "총 재고",
                        value: "\(viewModel.totalStock)",
                        unit: "권",
                        icon: "shippingbox.fill",
                        color: .orange
                    )
                }
                
                // 목록 섹션
                HStack(alignment: .top, spacing: 16) {
                    DashboardPanel(
                        title: "최근 고객이 많이 검색한 도서",
                        icon: "magnifyingglass",
                        isEmpty: viewModel.topSearchedBooks.isEmpty,
                        emptyMessage: "검색 기록이 없습니다."
                    ) {
                        ForEach(Array(viewModel.topSearchedBooks.enumerated()), id: \.element.id) { index, item in
                            DashboardSearchRow(rank: index + 1, item: item)
                            if index < viewModel.topSearchedBooks.count - 1 {
                                Divider()
                            }
                        }
                    }
                    
                    DashboardPanel(
                        title: "판매가 많은 도서",
                        icon: "chart.line.uptrend.xyaxis",
                        isEmpty: viewModel.topSellingBooks.isEmpty,
                        emptyMessage: "판매 기록이 없습니다."
                    ) {
                        ForEach(Array(viewModel.topSellingBooks.enumerated()), id: \.element.id) { index, item in
                            DashboardSalesRow(rank: index + 1, item: item)
                            if index < viewModel.topSellingBooks.count - 1 {
                                Divider()
                            }
                        }
                    }
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onAppear {
            viewModel.reload()
        }
        .alert(item: $pendingReset) { action in
            Alert(
                title: Text(action.title),
                message: Text(action.message),
                primaryButton: .destructive(Text("초기화")) {
                    switch action {
                    case .sales:
                        viewModel.resetSales()
                    case .searchLogs:
                        viewModel.resetSearchLogs()
                    case .stock:
                        viewModel.resetStock()
                    case .all:
                        viewModel.resetAllData()
                    }
                },
                secondaryButton: .cancel(Text("취소"))
            )
        }
    }
}

// MARK: - 요약 카드

struct DashboardStatCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                Spacer()
            }
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                Text(unit)
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(nsColor: .controlBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(color.opacity(0.25), lineWidth: 1)
        )
    }
}

// MARK: - 목록 패널

struct DashboardPanel<Content: View>: View {
    let title: String
    let icon: String
    let isEmpty: Bool
    let emptyMessage: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.accentColor)
                Text(title)
                    .font(.headline)
            }
            
            if isEmpty {
                Text(emptyMessage)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 32)
            } else {
                VStack(spacing: 10) {
                    content()
                }
            }
            
            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(nsColor: .controlBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.primary.opacity(0.08), lineWidth: 1)
        )
    }
}

// MARK: - 행

struct DashboardSearchRow: View {
    let rank: Int
    let item: BookSearchStat
    
    var body: some View {
        HStack(spacing: 12) {
            RankBadge(rank: rank)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                Text(item.author)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text("\(item.searchCount)회 검색")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(
                    Capsule().fill(Color.blue.opacity(0.1))
                )
        }
        .padding(.vertical, 2)
    }
}

struct DashboardSalesRow: View {
    let rank: Int
    let item: BookSalesStat
    
    var body: some View {
        HStack(spacing: 12) {
            RankBadge(rank: rank)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                Text(item.author)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(item.soldQuantity)권 판매")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.green)
                Text("\(item.revenue.formatted())원")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

struct RankBadge: View {
    let rank: Int
    
    private var color: Color {
        switch rank {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        default: return .secondary
        }
    }
    
    var body: some View {
        Text("\(rank)")
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(width: 22, height: 22)
            .background(Circle().fill(color))
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .frame(width: 900, height: 620)
    }
}
