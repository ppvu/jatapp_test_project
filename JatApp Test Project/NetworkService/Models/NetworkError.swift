//
//  NetworkError.swift
//  JatApp Test Project
//
//  Created by Yevhen Kononenko on 21.04.2023.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case badStatusCode
    case badData
    case networkError(Error)
    case decodingError(Error)
}
