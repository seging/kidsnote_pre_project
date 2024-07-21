//
//  Wi.swift
//  KidsNoteGoogleBookTask
//
//  Created by 이승기 on 7/21/24.
//

import Foundation

// 위시리스트를 관리하는 클래스
final class WishlistManager {
    // 위시리스트를 UserDefaults에 저장하는 키
    private let wishlistKey = "wishlist"
    static let shared = WishlistManager()
    
    private init() {}
    
    // 책을 위시리스트에 추가하는 메서드
    func addToWishlist(book: BookItem) {
        var wishlist = getWishlist()
        wishlist.append(book.id)
        saveWishlist(wishlist)
    }
    
    // 책을 위시리스트에서 제거하는 메서드
    func removeFromWishlist(book: BookItem) {
        var wishlist = getWishlist()
        wishlist.removeAll { $0 == book.id }
        saveWishlist(wishlist)
    }
    
    // 책이 위시리스트에 있는지 확인하는 메서드
    func isBookInWishlist(book: BookItem) -> Bool {
        let wishlist = getWishlist()
        return wishlist.contains(book.id)
    }
    
    // UserDefaults에서 위시리스트를 가져오는 메서드
    private func getWishlist() -> [String] {
        return UserDefaults.standard.stringArray(forKey: wishlistKey) ?? []
    }
    
    // 위시리스트를 UserDefaults에 저장하는 메서드
    private func saveWishlist(_ wishlist: [String]) {
        UserDefaults.standard.set(wishlist, forKey: wishlistKey)
    }
}
