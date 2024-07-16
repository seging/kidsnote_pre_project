//
//  UIImage+Cache.swift
//  KidsNoteGoogleBookTask
//
//  Created by 이승기 on 7/16/24.
//

import UIKit

extension UIImageView {
    public static func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let cacheManager = ImageCacheManager.shared
        let key = url.absoluteString
        
        // 캐시에서 이미지를 찾습니다.
        if let cachedImage = cacheManager.image(forKey: key) {
            completion(cachedImage)
            return
        }

        // 캐시에 이미지가 없으면 다운로드합니다.
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            // 다운로드한 이미지를 캐시에 저장합니다.
            cacheManager.setImage(image, forKey: key)

            // 메인 스레드에서 UIImageView에 이미지를 설정합니다.
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
