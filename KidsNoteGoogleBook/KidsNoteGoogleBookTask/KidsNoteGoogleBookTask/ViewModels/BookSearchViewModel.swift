//
//  BookSearchViewModel.swift
//  KidsNoteGoogleBookTask
//
//  Created by 이승기 on 7/15/24.
//

import Foundation
import Combine
import UIKit

public enum State {
    case idle
    case loading
    case loaded([BookItem])
    case error(String)
    case noResults(String)
}

public class BookSearchViewModel: ObservableObject {
    @Published public var state: State = .idle
    private var allBooks: [BookItem] = []
    private var selectedIdx: Int = 0 // 초기화면에서 eBook 컨텐츠 보여주도록 설정
    private var currentPage: Int = 0
    private var isLoadingPage: Bool = false
    private var query: String = ""
    private var hasMorePages: Bool = true
    private let booksPerPage: Int = 10
    
    private var cache: [BookItem] = [] // 캐시를 단순화하여 배열로 저장
    
    public init() {}
    
    public func searchBooks(query: String) {
        print(query)
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
                var totalFilteredBooks: [BookItem] = []
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
                    if let items = books.items, !items.isEmpty {
                        let filteredBooks = items.filter { self.isBookValid(book: $0) }
                        for book in filteredBooks {
                            if !seenBooks.contains(book) {
                                if totalFilteredBooks.count < booksPerPage {
                                    totalFilteredBooks.append(book)
                                    seenBooks.insert(book)
                                } else {
                                    cache.append(book) // 나머지는 캐시에 저장
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
                    self.state = .loaded(self.allBooks)
                }
            } catch {
                self.state = .error(error.localizedDescription)
                self.isLoadingPage = false
            }
        }
    }
    
    func isBookValid(book: BookItem) -> Bool {
        let volumeInfo = book.volumeInfo
        guard let readingModes = volumeInfo.readingModes else { return false }
        guard let accessInfo = book.accessInfo else { return false }
        let isValidBook = readingModes.text || readingModes.image
        let hasImageLinks = volumeInfo.imageLinks != nil
        let isEbookVisible = accessInfo.epub?.isAvailable == true || accessInfo.pdf?.isAvailable == true
        return isValidBook && hasImageLinks && isEbookVisible
    }
    
    private func preloadImages(for books: [BookItem]?) {
        guard let books = books, !books.isEmpty else {
            self.showNoDataMsg()
            return
        }
        
        let imageURLs = books.compactMap { $0.volumeInfo.imageLinks?.thumbnail }.compactMap { URL(string: $0) }
        
        let group = DispatchGroup()
        
        for url in imageURLs {
            group.enter()
            UIImageView.loadImage(from: url) { _ in
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
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
            state = .loaded(allBooks.filter { $0.accessInfo?.textToSpeechPermission == "ALLOWED" })
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
        
        var allItems: [BookItem] = []
        
        for queryItem in queries {
            let books = try await GoogleBooksAPIService.shared.searchBooks(query: queryItem, startIndex: startIndex)
            if let items = books.items {
                allItems.append(contentsOf: items)
            }
            if allItems.count >= 100 {
                break
            }
        }
        
        return BookResponse(kind: "books#volumes", totalItems: allItems.count, items: allItems)
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



