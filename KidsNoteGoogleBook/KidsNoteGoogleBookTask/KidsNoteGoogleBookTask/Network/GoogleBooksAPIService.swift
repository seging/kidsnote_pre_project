//
//  GoogleBooksAPIService.swift
//  KidsNoteGoogleBookTask
//
//  Created by 이승기 on 7/15/24.
//

import Foundation


class GoogleBooksAPIService {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func searchBooks(query: String) async throws -> BookResponse {
        let queryItems:String = [
            "intitle:\(query)"
        ].joined(separator: "+")
        let encodedQuery = queryItems.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=\(encodedQuery)&key=\(Config.apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let response: BookResponse = try await networkService.request(url: url)
        return response
    }
    
}
