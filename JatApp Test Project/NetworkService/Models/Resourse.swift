//
//  Resourse.swift
//  JatApp Test Project
//
//  Created by Yevhen Kononenko on 21.04.2023.
//

import Foundation

struct Resourse {
    let method: HTTPMethod
    let url: URL?
    let body: Data?
    let headers: [String: String]?
    
    init(method: HTTPMethod = .get, url: URL?, body: Data? = nil, headers: [String : String]? = nil) {
        self.method = method
        self.url = url
        self.body = body
        self.headers = headers
    }
}
