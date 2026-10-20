//
//  Book.swift
//  Shelf
//
//  Created by Lin Thit Khant on 20/10/2569 BE.
//

import Foundation

struct Book: Identifiable {
    let id: UUID
    var title: String
    var author: String
    var status: ReadingStatus
    let added: Date
    var genre: BookGenre?
}

enum ReadingStatus {
    case want
    case reading
    case finished
}

enum BookGenre {
    case romance
    case thriller
    case mystery
}

extension Book {
    static let samples: [Book] = [
        Book(
            id: UUID(),
            title: "The Salt Market",
            author: "Lena Cho",
            status: .reading,
            added: Date(),
            genre: .romance
        ),
        Book(
            id: UUID(),
            title: "Platform 19",
            author: "Idris Hale",
            status: .want,
            added: Date(),
            genre: .mystery
        ),
        Book(
            id: UUID(),
            title: "Field Notes from June",
            author: "Mara Voss",
            status: .finished,
            added: Date(),
            genre: nil
        )
    ]
}
