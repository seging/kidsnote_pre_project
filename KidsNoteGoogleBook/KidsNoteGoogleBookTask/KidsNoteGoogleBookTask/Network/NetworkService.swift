//
//  NetworkService.swift
//  KidsNoteGoogleBookTask
//
//  Created by 이승기 on 7/15/24.
//

import Foundation

// 네트워크 요청을 위한 프로토콜 정의
protocol NetworkServiceProtocol:AnyObject {
    func request<T: Decodable>(url: URL) async throws -> T
}

// 네트워크 서비스 클래스
final class NetworkService:NetworkServiceProtocol {
    static let shared = NetworkService()
    
    private init() {}
    
    // 제네릭을 사용한 네트워크 요청 메서드
    func request<T:Decodable>(url: URL) async throws -> T {
        do {
            // URLSession을 사용하여 데이터 요청
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // HTTP 응답 코드가 200-299 범위에 있는지 확인
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Server error: \(response)")
                throw URLError(.badServerResponse)
            }
            
            // JSON 데이터를 디코딩하여 원하는 타입으로 변환
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(T.self, from: data)
                return result
            } catch {
                // 디코딩 에러 발생 시, JSON 응답을 출력
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    print("JSON Response: \(json)")
                } else {
                    print("Failed to parse JSON response")
                }
                print("Decoding error: \(error)")
                throw error
            }
        } catch {
            print("Request failed with error: \(error.localizedDescription)")
            throw error
        }
    }
}
