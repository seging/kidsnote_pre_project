//
//  BookDetailViewModel.swift
//  KidsNoteGoogleBookTask
//
//  Created by 이승기 on 7/15/24.
//

import Foundation
import Combine

public final class BookDetailViewModel: ObservableObject {
    @Published public var rating: Double
    @Published public var ratingCount: Int
    @Published public var averageRating: Double?
    @Published public var title: String
    @Published public var description: String
    @Published public var publishDate: String
    @Published public var isInWishlist: Bool = false
    @Published public var previewLink: String?
    public let book: BookItem
    
    public var hasRating: Bool {
        return ratingCount > 0
    }
    
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
    
    public func toggleWishlistStatus() {
        if isInWishlist {
            wishlistManager.removeFromWishlist(book: book)
        } else {
            wishlistManager.addToWishlist(book: book)
        }
        isInWishlist.toggle()
    }
}



