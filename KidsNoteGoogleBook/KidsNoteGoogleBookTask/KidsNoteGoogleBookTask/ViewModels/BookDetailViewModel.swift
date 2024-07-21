//
//  BookDetailViewModel.swift
//  KidsNoteGoogleBookTask
//
//  Created by 이승기 on 7/15/24.
//

import Foundation
import Combine

// 책 상세 정보를 관리하는 ViewModel 클래스
public final class BookDetailViewModel: ObservableObject {
    // UI에 바인딩되는 Published 프로퍼티
    @Published public var rating: Double
    @Published public var ratingCount: Int
    @Published public var averageRating: Double?
    @Published public var title: String
    @Published public var description: String
    @Published public var publishDate: String
    @Published public var isInWishlist: Bool = false
    @Published public var previewLink: String?
    public let book: BookItem
    
    // 책에 평점이 있는지 여부를 나타내는 계산 프로퍼티
    public var hasRating: Bool {
        return ratingCount > 0
    }
    
    // 위시리스트 매니저 인스턴스
    private var wishlistManager = WishlistManager.shared
    
    public init(book: BookItem) {
        self.book = book
        self.rating = book.volumeInfo.averageRating ?? 0.0
        self.ratingCount = book.volumeInfo.ratingsCount ?? 0
        self.averageRating = book.volumeInfo.averageRating
        self.title = book.volumeInfo.title
        self.description = book.volumeInfo.description ?? ""
        self.publishDate = book.volumeInfo.publishedDate ?? ""
        self.isInWishlist = wishlistManager.isBookInWishlist(book: book)
        self.previewLink = book.volumeInfo.previewLink
    }
    
    // 위시리스트 상태를 토글하는 함수
    public func toggleWishlistStatus() {
        if isInWishlist {
            wishlistManager.removeFromWishlist(book: book)
        } else {
            wishlistManager.addToWishlist(book: book)
        }
        isInWishlist.toggle()
    }
}



