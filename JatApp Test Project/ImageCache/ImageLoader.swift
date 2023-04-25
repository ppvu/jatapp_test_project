//
//  ImageLoader.swift
//  JatApp Test Project
//
//  Created by Yevhen Kononenko on 25.04.2023.
//

import UIKit

final class ImageLoader {
    func image(with resource: Resourse, complition: @escaping (UIImage?) -> Void) {
        if let image = ImageCache.shared.image(for: resource.path) {
            complition(image)
        } else {
            NetworkService().executeRequest(resourse: resource) { result in
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
