//
//  ContentView.swift
//  Shelf
//
//  Created by Lin Thit Khant on 20/10/2569 BE.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            List(Book.samples) { book in
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
