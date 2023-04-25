//
//  ImageCache.swift
//  JatApp Test Project
//
//  Created by Yevhen Kononenko on 24.04.2023.
//

import UIKit

/// Class that used for cache the images recieved from network request
final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    func save(image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func image(for key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
}
