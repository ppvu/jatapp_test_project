//
//  NetworkService.swift
//  JatApp Test Project
//
//  Created by Yevhen Kononenko on 21.04.2023.
//

import Foundation

final class NetworkService {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
}

extension NetworkService {
    func executeRequest(resource: Resource, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = resource.url else { return completion(.failure(.badUrl)) }
        
        var request = URLRequest(url: url)
        request.httpMethod = resource.method.rawValue
        request.httpBody = resource.body
        
        session.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(.networkError(error)))
            } else if let data {
                completion(.success(data))
            } else {
                completion(.failure(.badData))
            }
        }
        .resume()
    }
    
    func requestDecoding<T: Decodable>(
        resource: Resource,
        decodingType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        executeRequest(resource: resource) { result in
            switch result {
            case .success(let data):
                do {
                    let object = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(object))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
