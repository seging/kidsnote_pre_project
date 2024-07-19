//
//  ImageCacheManager.swift
//  KidsNoteGoogleBookTask
//
//  Created by 이승기 on 7/16/24.
//

import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let cache = NSCache<NSString, UIImage>()
    private let queue = DispatchQueue(label: "ImageCacheManagerQueue")
    
    private init() {}
    
    func image(forKey key: String) -> UIImage? {
        var result: UIImage?
        queue.sync {
            result = cache.object(forKey: NSString(string: key))
        }
        return result
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        queue.async(flags: .barrier) {
            self.cache.setObject(image, forKey: NSString(string: key))
        }
    }
    
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


