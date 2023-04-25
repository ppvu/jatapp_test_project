//
//  MovieDetailsModel.swift
//  JatApp Test Project
//
//  Created by Yevhen Kononenko on 25.04.2023.
//

import Foundation

final class MovieDetailsModel {
    var sortedCounts: [(Character, Int)] = []
    private let movie: Top250DataDetails
    
    init(movie: Top250DataDetails) {
        self.movie = movie
        sortedCounts = countCharactersSorted(with: movie.title)
    }
    
    private func countCharactersSorted(with string: String) -> [(Character, Int)] {
        let keyedCharacters = string
            .lowercased()
            .filter { !$0.isWhitespace }
            .reduce(into: [Character: Int]()) { result, current in
                result[current] = result[current, default: 0] + 1
            }
        
        return Array(keyedCharacters).sorted(by: { lhs, rhs in
            if lhs.value == rhs.value {
                return lhs.key < rhs.key
            }
            
            return lhs.value > rhs.value
        })
    }
}
