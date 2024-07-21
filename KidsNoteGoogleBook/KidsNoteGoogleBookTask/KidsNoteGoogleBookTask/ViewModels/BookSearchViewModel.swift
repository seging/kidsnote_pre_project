//
//  BookSearchViewModel.swift
//  KidsNoteGoogleBookTask
//
//  Created by 이승기 on 7/15/24.
//

import Foundation
import Combine
import UIKit

// 상태를 나타내는 열거형
public enum State: Equatable {
    case idle
    case loading
    case loaded([BookItem])
    case error(String)
    case noResults(String)
}

// BookSearchViewModel은 검색 작업을 관리하고 상태를 업데이트하는 역할을 합니다.
public final class BookSearchViewModel: ObservableObject {
    // UI에 바인딩되는 Published 프로퍼티
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
    
    // 새로운 검색 작업을 시작하는 함수
    public func searchBooks(query: String) {
        // 중복 검색 방지
        guard self.query != query || state != .loading else { return }
        
        // 검색어와 관련된 상태 초기화
        self.query = query
        self.currentPage = 0
        self.allBooks = []
        self.cache = []
        self.hasMorePages = true
        self.state = .loading
        ImageCacheManager.shared.clearCache()
        loadNextPage() // 첫 번째 페이지 로드
    }
    
    // 다음 페이지를 로드하는 함수
    public func loadNextPage() {
        // 이미 페이지를 로딩 중이거나 더 이상 로드할 페이지가 없는 경우 리턴
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
                    // 여러 쿼리를 통해 책을 검색합니다.
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
                        hasMorePages = false // 더 이상 로드할 페이지가 없는 경우
                    }
                }
                
                // 로드한 책들을 전체 목록에 추가
                self.allBooks.append(contentsOf: totalFilteredBooks)
                self.preloadImages(for: totalFilteredBooks)
                self.isLoadingPage = false
                
                // 검색 결과가 없는 경우
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
    
    // 책의 유효성을 검증하는 함수
    private func isBookValid(book: BookItem) -> Bool {
        let volumeInfo = book.volumeInfo
        guard let readingModes = volumeInfo.readingModes else { return false }
        guard let accessInfo = book.accessInfo else { return false }
        let isValidBook = readingModes.text || readingModes.image
        let hasImageLinks = volumeInfo.imageLinks != nil
        let isEbookVisible = accessInfo.epub?.isAvailable == true || accessInfo.pdf?.isAvailable == true
        return isValidBook && hasImageLinks && isEbookVisible
    }
    
    // 이미지를 미리 로드하는 함수
    private func preloadImages(for books: ContiguousArray<BookItem>?) {
        guard let books = books, !books.isEmpty else {
            self.showNoDataMsg()
            return
        }
        
        // 책의 이미지 URL을 수집하여 캐시에 미리 로드
        let imageURLs = books.compactMap { $0.volumeInfo.imageLinks?.thumbnail }.compactMap { URL(string: $0) }
        ImageCacheManager.shared.preloadImages(from: imageURLs) {
            self.filterContent(by: self.selectedIdx)
        }
    }
    
    // 컨텐츠를 필터링하는 함수
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
    
    // 데이터가 없는 경우 메시지를 표시하는 함수
    private func showNoDataMsg() {
        state = .noResults("\(selectedIdx == 0 ? "eBook" : "오디오북") 검색결과 없음")
    }
    
    // 여러 쿼리를 통해 검색을 수행하는 함수
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
    
    // 상태를 초기화하는 함수
    public func resetStateIfNeeded() {
        state = .idle
        allBooks.removeAll()
        cache.removeAll()
    }
}



