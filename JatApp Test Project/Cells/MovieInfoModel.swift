//
//  MovieInfoModel.swift
//  JatApp Test Project
//
//  Created by Yevhen Kononenko on 25.04.2023.
//

import UIKit
import Foundation

final class MovieInfoModel {
    var title: String = ""
    var year: String = ""
    var crew: String = ""
    var rating: String = ""
    var posterImage: UIImage?
    
    private let movie: Top250DataDetails
    
    init(movie: Top250DataDetails) {
        self.movie = movie
    }
    
    func configureCell() {
        title = "#\(movie.rank).\(movie.title)"
        year = "Year: \(movie.year)"
        crew = "Crew: \(movie.crew)"
        rating = "IMDB Rating: \(movie.imdbRating)"
        
        ImageLoader().image(with: Resourse(path: movie.image)) { image in
            DispatchQueue.main.async { [weak self] in
                self?.posterImage = image
            }
        }
    }
}
