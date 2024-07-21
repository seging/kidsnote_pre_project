//
//  GoogleBooksAPIService.swift
//  KidsNoteGoogleBookTask
//
//  Created by 이승기 on 7/15/24.
//

import Foundation


final class GoogleBooksAPIService {
    private let networkService: NetworkServiceProtocol = NetworkService.shared
    static let shared = GoogleBooksAPIService()
    
    private init() {}
    
    final func searchBooks(query: String, startIndex:Int) async throws -> BookResponse {
        let queryItems = [
            "q=\(query)",
            "startIndex=\(startIndex)",
            "maxResults=10",
            "filter=ebooks",
            "langRestrict=ko",
            "key=\(Config.apiKey)"
        ].joined(separator: "&")
        let encodedQuery = queryItems.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://www.googleapis.com/books/v1/volumes?\(encodedQuery)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let response: BookResponse = try await networkService.request(url: url)
        return response
    }
}
