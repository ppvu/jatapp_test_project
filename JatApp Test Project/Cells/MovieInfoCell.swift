//
//  MovieInfoCell.swift
//  JatApp Test Project
//
//  Created by Yevhen Kononenko on 21.04.2023.
//

import Foundation
import UIKit

final class MovieInfoCell: UICollectionViewCell {
    lazy var infoLabel: UILabel = {
        let title = UILabel()
        title.textColor = .label
        title.numberOfLines = 2
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
//        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .lightGray
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(infoLabel)
        contentView.addSubview(posterImageView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            infoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
            infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
            
            posterImageView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 8.0),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0)
        ])
    }
}

extension MovieInfoCell {
    func setup(with movie: Top250DataDetail) {
        infoLabel.text = "\(movie.rank). \(movie.title)"
        
        ImageCache.shared.getImage(from: movie.image) { [weak self] image in
            DispatchQueue.main.async {
                self?.posterImageView.image = image
            }
        }
    }
}
