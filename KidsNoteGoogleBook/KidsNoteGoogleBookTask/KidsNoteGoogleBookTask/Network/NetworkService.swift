//
//  NetworkService.swift
//  KidsNoteGoogleBookTask
//
//  Created by 이승기 on 7/15/24.
//

import Foundation

protocol NetworkServiceProtocol:AnyObject {
    func request<T: Decodable>(url: URL) async throws -> T
}

class NetworkService:NetworkServiceProtocol {
    static let shared = NetworkService()
    
    private init() {}
    
    func request<T:Decodable>(url: URL) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Server error: \(response)")
                throw URLError(.badServerResponse)
            }
            
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(T.self, from: data)
                return result
            } catch {
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
