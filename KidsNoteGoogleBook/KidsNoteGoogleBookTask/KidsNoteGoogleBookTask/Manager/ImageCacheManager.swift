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
}

