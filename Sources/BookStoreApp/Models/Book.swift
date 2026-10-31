import Foundation

struct Book: Identifiable, Codable {
    let id: String
    var bookID: String
    var title: String
    var author: String
    var publisher: String
    var genre: String
    var price: Int
    var stock: Int
    var isbn: String
    var description: String
    var createdAt: Date
    var updatedAt: Date
    
    init(
        id: String = UUID().uuidString,
        bookID: String,
        title: String,
        author: String,
        publisher: String,
        genre: String,
        price: Int,
        stock: Int = 0,
        isbn: String,
        description: String,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.bookID = bookID
        self.title = title
        self.author = author
        self.publisher = publisher
        self.genre = genre
        self.price = price
        self.stock = stock
        self.isbn = isbn
        self.description = description
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}