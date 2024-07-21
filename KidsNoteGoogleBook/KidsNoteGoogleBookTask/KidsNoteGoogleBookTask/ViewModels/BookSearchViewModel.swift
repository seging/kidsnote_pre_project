//
//  BookSearchViewModel.swift
//  KidsNoteGoogleBookTask
//
//  Created by 이승기 on 7/15/24.
//

import Foundation
import Combine
import UIKit

public enum State: Equatable {
    case idle
    case loading
    case loaded([BookItem])
    case error(String)
    case noResults(String)
}

public final class BookSearchViewModel: ObservableObject {
    @Published public var state: State = .idle
    private var allBooks: ContiguousArray<BookItem> = []
    private var selectedIdx: Int = 0
    private var currentPage: Int = 0
    private var isLoadingPage: Bool = false
    private var query: String = ""
    private var hasMorePages: Bool = true
    private let booksPerPage: Int = 10
    
    private var cache: ContiguousArray<BookItem> = []
    
    public init() {}
    
    public func searchBooks(query: String) {
        // 중복 검색 방지
        guard self.query != query || state != .loading else { return }
        
        self.query = query
        self.currentPage = 0
        self.allBooks = []
        self.cache = []
        self.hasMorePages = true
        self.state = .loading
        ImageCacheManager.shared.clearCache()
        loadNextPage()
    }
    
    public func loadNextPage() {
        guard !isLoadingPage, hasMorePages else { return }
        isLoadingPage = true
        
        Task {
            do {
                var totalFilteredBooks: ContiguousArray<BookItem> = []
                var seenBooks = Set<BookItem>()
                
                // 캐시에서 필요한 만큼 가져오기
                while totalFilteredBooks.count < booksPerPage && !cache.isEmpty {
                    let book = cache.removeFirst()
                    if !seenBooks.contains(book) {
                        totalFilteredBooks.append(book)
                        seenBooks.insert(book)
                    }
                }
                
                // API 요청으로 추가 가져오기
                while totalFilteredBooks.count < booksPerPage && hasMorePages {
                    let books = try await searchMultipleQueries(query: query, startIndex: currentPage * booksPerPage)
                    if let items = books.items {
                        let filteredBooks = ContiguousArray(items.filter { self.isBookValid(book: $0) })
                        for book in filteredBooks {
                            if !seenBooks.contains(book) {
                                if totalFilteredBooks.count < booksPerPage {
                                    totalFilteredBooks.append(book)
                                    seenBooks.insert(book)
                                } else {
                                    cache.append(book)
                                }
                            }
                        }
                        self.currentPage += 1
                    } else {
                        hasMorePages = false
                    }
                }
                
                self.allBooks.append(contentsOf: totalFilteredBooks)
                self.preloadImages(for: totalFilteredBooks)
                self.isLoadingPage = false
                
                if totalFilteredBooks.isEmpty && cache.isEmpty {
                    self.showNoDataMsg()
                } else {
                    self.state = .loaded(Array(self.allBooks))
                }
            } catch {
                self.state = .error("Failed to load books: \(error.localizedDescription)")
                self.isLoadingPage = false
            }
        }
    }
    
    private func isBookValid(book: BookItem) -> Bool {
        let volumeInfo = book.volumeInfo
        guard let readingModes = volumeInfo.readingModes else { return false }
        guard let accessInfo = book.accessInfo else { return false }
        let isValidBook = readingModes.text || readingModes.image
        let hasImageLinks = volumeInfo.imageLinks != nil
        let isEbookVisible = accessInfo.epub?.isAvailable == true || accessInfo.pdf?.isAvailable == true
        return isValidBook && hasImageLinks && isEbookVisible
    }
    
    private func preloadImages(for books: ContiguousArray<BookItem>?) {
        guard let books = books, !books.isEmpty else {
            self.showNoDataMsg()
            return
        }
        
        let imageURLs = books.compactMap { $0.volumeInfo.imageLinks?.thumbnail }.compactMap { URL(string: $0) }
        ImageCacheManager.shared.preloadImages(from: imageURLs) {
            self.filterContent(by: self.selectedIdx)
        }
    }
    
    public func filterContent(by index: Int) {
        selectedIdx = index
        guard !allBooks.isEmpty else {
            self.showNoDataMsg()
            return
        }
        if index == 0 {
            // eBook 필터
            state = .loaded(allBooks.filter { $0.saleInfo?.isEbook == true })
        } else if index == 1 {
            // audioBook 필터
            state = .loaded(allBooks.filter { $0.accessInfo?.textToSpeechPermission == "ALLOWED" && $0.accessInfo?.viewability == "PARTIAL" })
        }
    }
    
    private func showNoDataMsg() {
        state = .noResults("\(selectedIdx == 0 ? "eBook" : "오디오북") 검색결과 없음")
    }
    
    private func searchMultipleQueries(query: String, startIndex: Int) async throws -> BookResponse {
        let queries = [
            "inauthor:\(query)",
            "inpublisher:\(query)",
            "intitle:\(query)",
            "subject:\(query)",
            query
        ]
        
        var allItems: ContiguousArray<BookItem> = []
        
        for queryItem in queries {
            let books = try await GoogleBooksAPIService.shared.searchBooks(query: queryItem, startIndex: startIndex)
            if let items = books.items {
                allItems.append(contentsOf: items)
            }
            if allItems.count >= 100 {
                break
            }
        }
        
        return BookResponse(kind: "books#volumes", totalItems: allItems.count, items: Array(allItems))
    }
    
    public func resetStateIfNeeded() {
        state = .idle
        allBooks.removeAll()
        cache.removeAll()
    }
}

extension BookItem: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: BookItem, rhs: BookItem) -> Bool {
        return lhs.id == rhs.id
    }
}


