//
//  ShelfApp.swift
//  Shelf
//
//  Created by Lin Thit Khant on 20/10/2569 BE.
//

import SwiftUI
import SwiftData

@main
struct ShelfApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
