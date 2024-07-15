//
//  BookSearchViewModel.swift
//  KidsNoteGoogleBookTask
//
//  Created by 이승기 on 7/15/24.
//
import Foundation
import Combine

@MainActor
public class BookSearchViewModel: ObservableObject {
    @Published public private(set) var state: State = .idle

    private let bookManager: BookManager
    private var cancellables = Set<AnyCancellable>()

    public init() {
        self.bookManager = BookManager()
    }

    public enum State {
        case idle
        case loading
        case loaded([BookItem])
        case error(String)
    }

    public func searchBooks(query: String) {
        state = .loading
        Task {
            do {
                guard let books = try await bookManager.searchBooks(query: query) else { return }
                self.state = .loaded(books)
            } catch {
                self.state = .error(error.localizedDescription)
            }
        }
    }
}

