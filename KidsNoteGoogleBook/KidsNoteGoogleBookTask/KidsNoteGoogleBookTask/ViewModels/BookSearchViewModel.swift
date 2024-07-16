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
    private var allBooks: [BookItem]?
    private var selectedIdx: Int = 0 // 초기화면에서 eBook컨텐츠 보여주도록 설정
    public init() {
        
    }
    
    public func searchBooks(query: String) {
        state = .loading
        ImageCacheManager.shared.clearCache()
        Task {
            do {
                let books = try await GoogleBooksAPIService.shared.searchBooks(query: query)
                self.allBooks = books.items
                preloadImages(for: books.items)
            } catch {
                self.state = .error(error.localizedDescription)
            }
        }
    }
    
    private func preloadImages(for books: [BookItem]?) {
        guard let books = books else {
            self.state = .noResults("\(selectedIdx == 0 ? "eBook" : "오디오북") 검색결과 없음")
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
        guard let books = self.allBooks else {
            state = .noResults("\(index == 0 ? "eBook" : "오디오북") 검색결과 없음")
            return
        }
        if index == 0 {
            // eBook 필터
            state = .loaded(books.filter { $0.saleInfo != nil && $0.saleInfo!.isEbook == true})
        } else if index == 1 {
            // audioBook 필터
            state = .loaded(books.filter { $0.accessInfo?.textToSpeechPermission == "ALLOWED"})
        }
    }
}
