//
//  Movie.swift
//  JatApp Test Project
//
//  Created by Yevhen Kononenko on 21.04.2023.
//

import Foundation

struct Top250Data: Decodable {
    let items: [Top250DataDetails]
    let errorMessage: String
}

struct Top250DataDetails: Decodable {
    let id: String
    let rank: String
    let title: String
    let fullTitle: String
    let year: String
    let image: String
    let crew: String
    let imdbRating: String
    let imdbRatingCount: String

    enum CodingKeys: String, CodingKey {
        case id, rank, title, fullTitle, year, image, crew
        case imdbRating = "imDbRating"
        case imdbRatingCount = "imDbRatingCount"
    }
}
