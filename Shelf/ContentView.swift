//
//  ContentView.swift
//  Shelf
//
//  Created by Lin Thit Khant on 20/10/2569 BE.
//

import SwiftUI

struct ContentView: View {
    
    @State private var books = Book.samples
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($books) { $book in
                    NavigationLink {
                        BookEditor(book: $book)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(book.title)
                            Text(book.author)
                            Text(statusTitle(book.status))
                            if let genre = book.genre {
                                Text(genreTitle(genre))
                            }
                        }
                    }
                }
            }
            .navigationTitle("Shelf")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        books.append(
                            Book(
                                id: UUID(),
                                title: "",
                                author: "",
                                status: .want,
                                added: Date(),
                                genre: nil
                            )
                        )
                    }
                }
            }
        }
        
    }
    
    func statusTitle(_ status: ReadingStatus) -> String {
        switch status {
        case .want: return "Want"
        case .reading: return "Reading"
        case .finished: return "Finished"
        }
    }
    
    func genreTitle(_ genre: BookGenre) -> String {
        switch genre {
        case .romance: return "Romance"
        case .mystery: return "Mystery"
        case .thriller: return "Thriller"
        }
    }
}

#Preview {
    ContentView()
}
