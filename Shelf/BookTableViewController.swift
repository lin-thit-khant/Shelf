//
//  BookTableViewController.swift
//  Shelf
//
//  Created by Lin Thit Khant on 26/10/2569 BE.
//

import Foundation
import UIKit
import SwiftData
import SwiftUI

final class BookTableViewController: UIViewController {
    private let tableView = UITableView()
    private let container: ModelContainer
    
    private var books: [Book] = []
    
    init(container: ModelContainer) {
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBooks()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.register(BookCell.self, forCellReuseIdentifier: BookCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 64
        tableView.dataSource = self
    }
    
    private func loadBooks() {
        let descriptor = FetchDescriptor<Book>(
            sortBy: [SortDescriptor(\Book.added, order: .reverse)]
        )
        do {
            books = try container.mainContext.fetch(descriptor)
        } catch {
            books = []
        }
        tableView.reloadData()
    }
}

extension BookTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let book = books[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: BookCell.reuseIdentifier,
            for: indexPath
        ) as? BookCell else {
            return UITableViewCell()
        }
        cell.configure(
            title: book.displayTitle,
            author: book.author,
            spoken: book.spokenDescription
        )
        
        return cell
    }
}

final class BookCell: UITableViewCell {
    static let reuseIdentifier = "Book"

    private let titleLabel = UILabel()
    private let authorLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.numberOfLines = 0

        authorLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        authorLabel.adjustsFontForContentSizeCategory = true
        authorLabel.textColor = .secondaryLabel
        authorLabel.numberOfLines = 0

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)

        let margins = contentView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: margins.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),

            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            authorLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            authorLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
        ])
        isAccessibilityElement = true
        titleLabel.isAccessibilityElement = false
        authorLabel.isAccessibilityElement = false
    }

    required init?(coder: NSCoder) {
        return nil
    }

    func configure(title: String, author: String, spoken: String) {
        titleLabel.text = title
        authorLabel.text = author
        accessibilityLabel = spoken
    }
}

struct BookTableRepresentable: UIViewControllerRepresentable {
    let container: ModelContainer
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = BookTableViewController(container: container)
        controller.title = "UIKit"
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

#Preview("Samples") {
    previewController(insertSamples: true)
}

#Preview("Empty") {
    previewController(insertSamples: false)
}

#Preview("Large text") {
    let controller = previewController(insertSamples: true)
    controller.traitOverrides.preferredContentSizeCategory = .accessibilityLarge
    return controller
}

private func previewController(insertSamples: Bool) -> BookTableViewController {
    do {
        let container = try ModelContainer(
            for: Book.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        if insertSamples {
            for sample in Book.samples {
                container.mainContext.insert(
                    Book(
                        title: sample.title,
                        author: sample.author,
                        status: sample.status,
                        added: sample.added,
                        genre: sample.genre
                    )
                )
            }
        }
        return BookTableViewController(container: container)
    } catch {
        fatalError("The preview store could not be created.")
    }
}
