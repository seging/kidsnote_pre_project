//
//  ImageCacheManager.swift
//  KidsNoteGoogleBookTask
//
//  Created by 이승기 on 7/16/24.
//

import UIKit

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let cache = NSCache<NSString, UIImage>()
    private let queue = DispatchQueue(label: "ImageCacheManagerQueue")
    
    private init() {}
    
    // 캐시에서 이미지를 가져오는 함수
    func image(forKey key: String) -> UIImage? {
        var result: UIImage?
        queue.sync {
            result = cache.object(forKey: NSString(string: key))
        }
        return result
    }
    
    // 캐시에 이미지를 저장하는 함수
    func setImage(_ image: UIImage, forKey key: String) {
        queue.async(flags: .barrier) {
            self.cache.setObject(image, forKey: NSString(string: key))
        }
    }
    
    // 캐시를 비우는 함수
    func clearCache() {
        queue.async(flags: .barrier) {
            self.cache.removeAllObjects()
        }
    }

    // 이미지를 미리 로드하는 함수
    func preloadImages(from urls: [URL], completion: @escaping () -> Void) {
        let group = DispatchGroup()
        
        for url in urls {
            group.enter()
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    self.setImage(image, forKey: url.absoluteString)
                }
                group.leave()
            }.resume()
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
}


