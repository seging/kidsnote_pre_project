//
//  UIImage+Cache.swift
//  KidsNoteGoogleBookTask
//
//  Created by 이승기 on 7/16/24.
//

import UIKit

private var imageLoadTaskKey: UInt8 = 0
private var imageURLKey: UInt8 = 1

extension UIImageView {
    // 이미지 로드 작업을 저장하기 위한 연관 키
    private var imageLoadTask: URLSessionDataTask? {
        get { objc_getAssociatedObject(self, &imageLoadTaskKey) as? URLSessionDataTask }
        set { objc_setAssociatedObject(self, &imageLoadTaskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    // 이미지 URL을 저장하기 위한 연관 키
    private var imageURL: URL? {
        get { objc_getAssociatedObject(self, &imageURLKey) as? URL }
        set { objc_setAssociatedObject(self, &imageURLKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    // URL을 통해 이미지를 로드하고, 캐시를 사용하여 성능을 향상시킵니다.
    public func loadImage(from url: URL) {
        // 기존 로드 작업 취소합니다.
        imageLoadTask?.cancel()
        
        let key = url.absoluteString
        self.imageURL = url
        
        // 캐시에서 이미지를 찾습니다.
        if let cachedImage = ImageCacheManager.shared.image(forKey: key) {
            self.image = cachedImage
            return
        }

        // 캐시에 이미지가 없으면 다운로드합니다.
        imageLoadTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, let image = UIImage(data: data) else {
                print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // 다운로드한 이미지를 캐시에 저장합니다.
            ImageCacheManager.shared.setImage(image, forKey: key)

            // 메인 스레드에서 UIImageView에 이미지를 설정합니다.
            DispatchQueue.main.async {
                if self.imageURL == url {
                    self.image = image
                }
            }
        }
        imageLoadTask?.resume()
    }
    
    // 이미지 로드 작업을 취소하는 함수
    public func cancelImageLoad() {
        imageLoadTask?.cancel()
        imageLoadTask = nil
        imageURL = nil
    }
}

