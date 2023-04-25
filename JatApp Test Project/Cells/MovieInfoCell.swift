//
//  MovieInfoCell.swift
//  JatApp Test Project
//
//  Created by Yevhen Kononenko on 21.04.2023.
//

import Foundation
import UIKit

final class MovieInfoCell: UICollectionViewCell {
    private static let indent: CGFloat = 8.0
    private var gradientLayer = CAGradientLayer()
    
    private lazy var titleLabel: UILabel = Self.makeLabel(with: 14.0)
    private lazy var rankLabel: UILabel = Self.makeLabel(with: 14.0)
    private lazy var yearLabel: UILabel = Self.makeLabel(with: 12.0)
    private lazy var crewLabel: UILabel = Self.makeLabel(with: 12.0)
    private lazy var ratingLabel: UILabel = Self.makeLabel(with: 12.0)
    
    private lazy var moreInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [yearLabel, crewLabel, ratingLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setupGradientLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    func setupGradientLayer() {
        gradientLayer.colors = [UIColor.magenta.cgColor, UIColor.orange.cgColor, UIColor.yellow.cgColor, UIColor.systemMint.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0.0, 1.0]
        contentView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func configure() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(rankLabel)
        contentView.addSubview(moreInfoStackView)
        contentView.addSubview(posterImageView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = Self.indent
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = contentView.bounds
        gradientLayer.colors = [UIColor.purple, UIColor.blue, UIColor.green, UIColor.systemPink]
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        
        NSLayoutConstraint.activate([
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Self.indent),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Self.indent),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            rankLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Self.indent),
            rankLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Self.indent),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Self.indent),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Self.indent),
            titleLabel.trailingAnchor.constraint(equalTo: rankLabel.leadingAnchor),
            
            moreInfoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Self.indent),
            moreInfoStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Self.indent),
            moreInfoStackView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: Self.indent),

            posterImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Self.indent),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Self.indent),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Self.indent)
        ])
    }
}

extension MovieInfoCell {
    func setup(with movie: Top250DataDetails) {
        titleLabel.text = movie.title
        rankLabel.text = "Rank #\(movie.rank)"
        yearLabel.text = "Year: \(movie.year)"
        crewLabel.text = "Crew: \(movie.crew)"
        ratingLabel.text = "IMDB Rating: \(movie.imdbRating)"
        
        ImageCache.shared.getImage(from: movie.image) { [weak self] image in
            DispatchQueue.main.async {
                self?.posterImageView.image = image
            }
        }
    }
}

private extension MovieInfoCell {
    static func makeLabel(with size: CGFloat) -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = .monospacedSystemFont(ofSize: size, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
