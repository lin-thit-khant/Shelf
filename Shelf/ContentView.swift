//
//  ContentView.swift
//  Shelf
//
//  Created by Lin Thit Khant on 20/10/2569 BE.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @State private var searchText = ""
    @State private var statusFilter = "all"
    
    var body: some View {
        NavigationStack {
            BookList(term: searchText, statusRaw: statusFilter)
                .searchable(text: $searchText, prompt: "Title or author")
            .navigationTitle("Shelf")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        modelContext.insert(
                            Book(
                                title: "",
                                author: "",
                                status: .want,
                                added: Date(),
                                genre: nil
                            )
                        )
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Picker("Status", selection: $statusFilter) {
                        Text("All").tag("all")
                        Text("Want").tag("want")
                        Text("Reading").tag("reading")
                        Text("Finished").tag("finished")
                    }
                }
            }
        }
        .task {
            do {
                let count = try modelContext.fetchCount(FetchDescriptor<Book>())
                guard count == 0 else { return }
            } catch {
                return
            }
            
            modelContext.insert(
                Book(title: "The Salt Market", author: "Lena Cho", status: .reading, added: Date(), genre: .romance)
            )
            modelContext.insert(
                Book(title: "Platform 19", author: "Idris Hale", status: .want, added: Date(), genre: .mystery)
            )
            modelContext.insert(
                Book(title: "Field Notes from June", author: "Mara Voss", status: .finished, added: Date(), genre: nil)
            )
        }
        
    }
    
   
}

struct BookList: View {
    @Query private var books: [Book]

    init(term: String, statusRaw: String) {
        let search = term
        let includeEveryStatus = statusRaw == "all"
        let selectedStatus = ReadingStatus(rawValue: statusRaw) ?? .want
        
        _books = Query(
            filter: #Predicate<Book> { book in
                (includeEveryStatus || book.status == selectedStatus)
                    && (search.isEmpty
                        || book.title.localizedStandardContains(search)
                        || book.author.localizedStandardContains(search))
            },
            sort: [SortDescriptor(\Book.added, order: .reverse)]
        )
    }

    var body: some View {
        List {
            ForEach(books) { book in
                NavigationLink  {
                    BookEditor(book: book)
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(book.displayTitle)
                            .font(.headline)
                        Text(book.author)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(statusTitle(book.status))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        if let genre = book.genre {
                            Text(genreTitle(genre))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(spokenDescription(for: book))
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
    
    private func spokenDescription(for book: Book) -> String {
        let title = book.title.isEmpty ? "Untitled" : book.title
        var parts = [title]
        if !book.author.isEmpty {
            parts.append("by \(book.author)")
        }
        parts.append(statusTitle(book.status))
        if let genre = book.genre {
            parts.append(genreTitle(genre))
        }
        return parts.joined(separator: ", ")
    }
    
}

#Preview {
    ContentView()
        .modelContainer(for: Book.self, inMemory: true)
}

#Preview("Large Text") {
    ContentView()
        .modelContainer(for: Book.self, inMemory: true)
        .environment(\.dynamicTypeSize, .accessibility3)
}
