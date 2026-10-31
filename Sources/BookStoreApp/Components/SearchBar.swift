import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    let onSearch: (String) -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search books...", text: $text) { isEditing in
                if !isEditing {
                    onSearch(text)
                }
            } onCommit: {
                onSearch(text)
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if !text.isEmpty {
                Button("Clear") {
                    text = ""
                    onSearch("")
                }
                .foregroundColor(.secondary)
            }
        }
        .padding(8)
    }
}