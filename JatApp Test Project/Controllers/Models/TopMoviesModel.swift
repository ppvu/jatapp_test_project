//
//  TopMoviesModel.swift
//  JatApp Test Project
//
//  Created by Yevhen Kononenko on 25.04.2023.
//

import Foundation

final class TopMoviesModel {
    var moviesData: [Top250DataDetails] = []
    var didUpdated: (() -> ())?
    
    private let networkService = NetworkService()
}

extension TopMoviesModel {
    func fetchMoviesList() {
        guard
            let infoDict = Bundle.main.infoDictionary,
            let apiKey = infoDict["IMDBApiKey"] as? String
        else {
            fatalError("IMDBApiKey not found in Info.plist")
        }
        
        let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/\(apiKey)")
        
        networkService.requestDecoding(resourse: Resourse(url: url), decodingType: Top250Data.self) { [weak self] result in
            switch result {
            case .success(let data):
                if data.errorMessage.isEmpty {
                    self?.moviesData = data.items
                    self?.didUpdated?()
                    return
                }
                
                fallthrough
            case .failure:
                self?.moviesData = []
            }
        }
    }
}
