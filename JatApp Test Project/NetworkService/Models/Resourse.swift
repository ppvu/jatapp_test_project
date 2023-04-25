//
//  Resource.swift
//  JatApp Test Project
//
//  Created by Yevhen Kononenko on 21.04.2023.
//

import Foundation

/// Struct that have all data for network request that supported by NetworkService class.
struct Resource {
    let method: HTTPMethod
    let path: String
    let body: Data?
    
    var url: URL? {
        URL(string: path)
    }
    
    init(method: HTTPMethod = .get, path: String, body: Data? = nil) {
        self.method = method
        self.path = path
        self.body = body
    }
}
