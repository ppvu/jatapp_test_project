//
//  MovieInfoCell.swift
//  JatApp Test Project
//
//  Created by Yevhen Kononenko on 21.04.2023.
//

import Foundation
import UIKit

final class MovieInfoCell: UICollectionViewCell {
    private lazy var gradientLayer = CAGradientLayer()
    
    private lazy var titleLabel: UILabel = makeLabel(withTextSize: Constants.titleTextSize)
    private lazy var yearLabel: UILabel = makeLabel()
    private lazy var crewLabel: UILabel = makeLabel()
    private lazy var ratingLabel: UILabel = makeLabel()
    
    private lazy var moreInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [yearLabel, crewLabel, ratingLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = Constants.stackViewSpacing
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        yearLabel.text = nil
        crewLabel.text = nil
        ratingLabel.text = nil
        posterImageView.image = nil
    }
    
    private func configure() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(moreInfoStackView)
        contentView.addSubview(posterImageView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.indent),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.indent),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.indent),
            
            moreInfoStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.indent),
            moreInfoStackView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: Constants.indent),
            moreInfoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.indent),

            posterImageView.topAnchor.constraint(equalTo: moreInfoStackView.topAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.indent),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.indent),
            posterImageView.widthAnchor.constraint(equalToConstant: Constants.imageWidth)
        ])
        
        configureCollectionView()
    }
}

// MARK: - Cell configuration

extension MovieInfoCell {
    func configureCell(with movie: Top250DataDetails) {
        titleLabel.text = "#\(movie.rank).\(movie.title)"
        yearLabel.text = "Year: \(movie.year)"
        crewLabel.text = "Crew: \(movie.crew)"
        ratingLabel.text = "IMDB Rating: \(movie.imdbRating)"
        
        ImageLoader().image(with: Resourse(path: movie.image)) { image in
            DispatchQueue.main.async { [weak self] in
                self?.posterImageView.image = image
            }
        }
    }
}

// MARK: - UI components

private extension MovieInfoCell {
    func setupGradientLayer() {
        gradientLayer.colors = [
            UIColor.magenta.cgColor,
            UIColor.orange.cgColor,
            UIColor.yellow.cgColor,
            UIColor.systemMint.cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0.0, 1.0]
        contentView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func configureCollectionView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = Constants.indent
        
        NSLayoutConstraint.activate([
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - Function for labels

private extension MovieInfoCell {
    func makeLabel(withTextSize size: CGFloat = Constants.additionalTextSize) -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = .monospacedSystemFont(ofSize: size, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }
}

// MARK: - Some Magic Nums in Constants

fileprivate extension MovieInfoCell {
    enum Constants {
        static let imageWidth: CGFloat = 120
        static let indent: CGFloat = 8
        static let additionalTextSize: CGFloat = 12
        static let titleTextSize: CGFloat = 14
        static let stackViewSpacing: CGFloat = 4
    }
}
