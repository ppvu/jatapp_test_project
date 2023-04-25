//
//  TopMoviesModel.swift
//  JatApp Test Project
//
//  Created by Yevhen Kononenko on 25.04.2023.
//

import Foundation

final class TopMoviesModel {
    var moviesData: [Top250DataDetails] = []
    var didUpdated: (() -> Void)?
    
    var searchText: String = "" {
        didSet {
            didUpdated?()
        }
    }
    
    var movies: [Top250DataDetails] {
        if searchText.isEmpty, moviesData.count > 10 {
            return Array(moviesData[..<10])
        } else {
            return moviesData.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
}

extension TopMoviesModel {
    func fetchMoviesList() {
        guard
            let infoDict = Bundle.main.infoDictionary,
            let apiKey = infoDict["IMDBApiKey"] as? String
        else {
            fatalError("IMDBApiKey not found in Info.plist")
        }
        
        NetworkService().requestDecoding(
            resourse: Resourse(path: "https://imdb-api.com/en/API/Top250Movies/\(apiKey)"),
            decodingType: Top250Data.self
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                if data.errorMessage.isEmpty {
                    self.moviesData = data.items
                    self.didUpdated?()
                }
            case .failure:
                self.moviesData = []
            }
        }
    }
}
