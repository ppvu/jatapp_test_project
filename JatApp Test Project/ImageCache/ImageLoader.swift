//
//  ImageLoader.swift
//  JatApp Test Project
//
//  Created by Yevhen Kononenko on 25.04.2023.
//

import UIKit

/// Class that download image or take it from Cache.
final class ImageLoader {
    func image(with resource: Resource, complition: @escaping (UIImage?) -> Void) {
        if let image = ImageCache.shared.image(for: resource.path) {
            complition(image)
        } else {
            NetworkService().executeRequest(resource: resource) { result in
                switch result {
                case .success(let data):
                    if let resultImage = UIImage(data: data) {
                        complition(resultImage)
                        ImageCache.shared.save(image: resultImage, for: resource.path)
                    } else {
                        complition(nil)
                    }
                case .failure:
                    complition(nil)
                }
            }
        }
    }
}
