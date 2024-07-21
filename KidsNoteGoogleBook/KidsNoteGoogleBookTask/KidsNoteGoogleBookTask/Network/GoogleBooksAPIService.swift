//
//  GoogleBooksAPIService.swift
//  KidsNoteGoogleBookTask
//
//  Created by 이승기 on 7/15/24.
//

import Foundation

// Google Books API와 통신하는 서비스 클래스
final class GoogleBooksAPIService {
    // 네트워크 서비스 프로토콜을 따르는 인스턴스
    private let networkService: NetworkServiceProtocol = NetworkService.shared
    static let shared = GoogleBooksAPIService()
    
    private init() {}
    // 책을 검색하는 메서드
    final func searchBooks(query: String, startIndex:Int) async throws -> BookResponse {
        // 쿼리 파라미터 구성
        let queryItems = [
            "q=\(query)",
            "startIndex=\(startIndex)",
            "maxResults=10",
            "filter=ebooks",
            "langRestrict=ko",
            "key=\(Config.apiKey)"
        ].joined(separator: "&")
        
        // 쿼리 파라미터 인코딩
        let encodedQuery = queryItems.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://www.googleapis.com/books/v1/volumes?\(encodedQuery)"
        
        // URL 생성
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        // 네트워크 서비스의 request 메서드를 호출하여 데이터 요청
        let response: BookResponse = try await networkService.request(url: url)
        return response
    }
}
