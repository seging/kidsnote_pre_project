//
//  BookManager.swift
//  KidsNoteGoogleBookTask
//
//  Created by 이승기 on 7/15/24.
//

import Foundation

class BookManager {
    private let apiService: GoogleBooksAPIService
    
    init(apiService: GoogleBooksAPIService = GoogleBooksAPIService()) {
        self.apiService = apiService
    }
    
    func searchBooks(query: String) async throws -> [BookItem]? {
        let response = try await apiService.searchBooks(query: query)
        return response.items
    }
}
