//
//  ImageCache.swift
//  JatApp Test Project
//
//  Created by Yevhen Kononenko on 24.04.2023.
//

import UIKit

/// Class that used for cache the images recieved from network request
/// 
final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()

    func getImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cache.object(forKey: url as NSString) {
            completion(cachedImage)
        } else {
            guard let url = URL(string: url) else {
                completion(nil)
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data, let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                
                self.cache.setObject(image, forKey: url.absoluteString as NSString)
                completion(image)
            }
            
            task.resume()
        }
    }

}
