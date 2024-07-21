//
//  Wi.swift
//  KidsNoteGoogleBookTask
//
//  Created by 이승기 on 7/21/24.
//

import Foundation

final class WishlistManager {
    private let wishlistKey = "wishlist"
    
    static let shared = WishlistManager()
    
    private init() {}
    
    func addToWishlist(book: BookItem) {
        var wishlist = getWishlist()
        wishlist.append(book.id)
        saveWishlist(wishlist)
    }
    
    func removeFromWishlist(book: BookItem) {
        var wishlist = getWishlist()
        wishlist.removeAll { $0 == book.id }
        saveWishlist(wishlist)
    }
    
    func isBookInWishlist(book: BookItem) -> Bool {
        let wishlist = getWishlist()
        return wishlist.contains(book.id)
    }
    
    private func getWishlist() -> [String] {
        return UserDefaults.standard.stringArray(forKey: wishlistKey) ?? []
    }
    
    private func saveWishlist(_ wishlist: [String]) {
        UserDefaults.standard.set(wishlist, forKey: wishlistKey)
    }
}
