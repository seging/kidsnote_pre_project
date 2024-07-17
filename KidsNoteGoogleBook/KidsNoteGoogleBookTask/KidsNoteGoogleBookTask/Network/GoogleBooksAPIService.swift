//
//  GoogleBooksAPIService.swift
//  KidsNoteGoogleBookTask
//
//  Created by 이승기 on 7/15/24.
//

import Foundation


class GoogleBooksAPIService {
    private let networkService: NetworkServiceProtocol = NetworkService.shared
    
    static let shared = GoogleBooksAPIService()
        
    private init() {}
    
    func searchBooks(query: String, startIndex:Int) async throws -> BookResponse {
        let queryItems:String = [
            query,
            "startIndex=\(startIndex)",
            "maxResults=20",
            "filter=ebooks",
            "key=\(Config.apiKey)"
        ].joined(separator: "&")
        let encodedQuery = queryItems.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=\(encodedQuery)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let response: BookResponse = try await networkService.request(url: url)
        return response
    }
    
}
