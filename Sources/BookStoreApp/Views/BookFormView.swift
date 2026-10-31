import SwiftUI

struct BookFormView: View {
    let book: Book?
    let viewModel: BookStoreViewModel
    
    @Environment(\.dismiss) var dismiss
    
    // Form fields
    @State private var bookID = ""
    @State private var title = ""
    @State private var author = ""
    @State private var publisher = ""
    @State private var genre = ""
    @State private var price = 0
    @State private var stock = 0
    @State private var isbn = ""
    @State private var description = ""
    
    init(book: Book?, viewModel: BookStoreViewModel) {
        self.book = book
        self.viewModel = viewModel
        
        // If editing an existing book, populate the form
        if let book = book {
            _bookID = State(initialValue: book.bookID)
            _title = State(initialValue: book.title)
            _author = State(initialValue: book.author)
            _publisher = State(initialValue: book.publisher)
            _genre = State(initialValue: book.genre)
            _price = State(initialValue: book.price)
            _stock = State(initialValue: book.stock)
            _isbn = State(initialValue: book.isbn)
            _description = State(initialValue: book.description)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(book == nil ? "Add New Book" : "Edit Book")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Form {
                    Section(header: Text("Book Information")) {
                        TextField("Book ID", text: $bookID)
                            .disabled(book != nil)
                        TextField("Title", text: $title)
                        TextField("Author", text: $author)
                        TextField("Publisher", text: $publisher)
                        TextField("Genre", text: $genre)
                        TextField("Price", value: $price, format: .number)
                        TextField("Stock", value: $stock, format: .number)
                        TextField("ISBN", text: $isbn)
                    }
                    
                    Section(header: Text("Description")) {
                        TextEditor(text: $description)
                            .frame(height: 100)
                    }
                }
                
                HStack {
                    Spacer()
                    Button("Cancel") {
                        dismiss()
                    }
                    .keyboardShortcut(.escape)
                    
                    Button(book == nil ? "Add Book" : "Update Book") {
                        submitForm()
                    }
                    .disabled(isFormInvalid())
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
    }
    
    private func isFormInvalid() -> Bool {
        return bookID.isEmpty || title.isEmpty || author.isEmpty || price <= 0 || stock < 0
    }
    
    private func submitForm() {
        let newBook = Book(
            id: book?.id ?? UUID().uuidString,
            bookID: bookID,
            title: title,
            author: author,
            publisher: publisher,
            genre: genre,
            price: price,
            stock: stock,
            isbn: isbn,
            description: description,
            createdAt: book?.createdAt ?? Date()
        )
        
        if book == nil {
            viewModel.addBook(newBook)
        } else {
            viewModel.updateBook(newBook)
        }
        
        dismiss()
    }
}