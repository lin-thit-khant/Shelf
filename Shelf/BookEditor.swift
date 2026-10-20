//
//  BookEditor.swift
//  Shelf
//
//  Created by Lin Thit Khant on 20/10/2569 BE.
//
import SwiftUI

struct BookEditor: View {
    @Binding var book: Book
    
    var body: some View {
        Form {
            TextField("Title", text: $book.title)
            TextField("Author", text: $book.author)
            Picker("Status", selection: $book.status) {
                Text("Want").tag(ReadingStatus.want)
                Text("Reading").tag(ReadingStatus.reading)
                Text("Finished").tag(ReadingStatus.finished)
            }
            Picker("Genre", selection: $book.genre) {
                Text("None").tag(Optional<BookGenre>.none)
                Text("Mystery").tag(Optional<BookGenre>.some(.mystery))
                Text("Romance").tag(Optional<BookGenre>.some(.romance))
                Text("Thriller").tag(Optional<BookGenre>.some(.thriller))
            }
        }
        .navigationTitle(book.title)
    }
}



