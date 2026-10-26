//
//  Book.swift
//  Shelf
//
//  Created by Lin Thit Khant on 20/10/2569 BE.
//

import Foundation
import SwiftData

@Model
final class Book {
    var title: String
    var author: String
    var status: ReadingStatus
    var added: Date
    var genre: BookGenre?
    var displayTitle: String {
        title.isEmpty ? "Untitled" : title
    }
    var spokenDescription: String {
        var parts = [displayTitle]
        if !author.isEmpty {
            parts.append("by \(author)")
        }
        parts.append(status.title)
        if let genre {
            parts.append(genre.title)
        }
        return parts.joined(separator: ", ")
    }
    
    init(title: String, author: String, status: ReadingStatus, added: Date, genre: BookGenre?) {
        self.title = title
        self.author = author
        self.status = status
        self.added = added
        self.genre = genre
    }
}

enum ReadingStatus: String, Codable, CaseIterable {
    case want
    case reading
    case finished
    
    var title: String {
        switch self {
        case .want: return "Want"
        case .reading: return "Reading"
        case .finished: return "Finished"
        }
    }
}

enum BookGenre: String, Codable, CaseIterable {
    case romance
    case thriller
    case mystery
    
    var title: String {
        switch self {
        case .romance: return "Romance"
        case .thriller: return "Thriller"
        case .mystery: return "Mystery"
        }
    }
}

extension Book {
    static let samples: [Book] = [
        Book(
            title: "The Salt Market",
            author: "Lena Cho",
            status: .reading,
            added: Date(),
            genre: .romance
        ),
        Book(
            title: "Platform 19",
            author: "Idris Hale",
            status: .want,
            added: Date(),
            genre: .mystery
        ),
        Book(
            title: "Field Notes from June",
            author: "Mara Voss",
            status: .finished,
            added: Date(),
            genre: nil
        )
    ]
}
