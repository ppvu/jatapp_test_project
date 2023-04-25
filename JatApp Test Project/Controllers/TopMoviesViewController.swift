//
//  ViewController.swift
//  JatApp Test Project
//
//  Created by Yevhen Kononenko on 20.04.2023.
//

/**
 View controller that displays a list of top 10 movies fetched from the IMDB API.
 
 The view controller has the following properties:
 - `refreshControl`: A UIRefreshControl object that is used to provide pull-to-refresh functionality to the collection view.
 - `collectionView`: A UICollectionView object that is used to display the list of top 10 movies.
 - `moviesData`: An array of `Top250DataDetails` objects that represent the movie information to be displayed in the collection view.
 - `networkService`: A `NetworkService` object that is used to make network requests.
 
 The view controller has the following methods:
 - `configureLayout()`: A private method that is used to add the collection view to the view hierarchy and set its constraints.
 - `fetchMoviesList()`: A method that is used to fetch the list of top 250 movies from the IMDB API using the `NetworkService` object. It updates the `top250Data` property based on the response received from the API.
 - `setupCollectionView()`: A private method that is used to set the data source and delegate of the collection view, and register the collection view cell.
 - `handleRefreshControl()`: A method that is called when the user triggers the refresh control. It calls `fetchMoviesList()` to fetch the updated list of top 250 movies and ends the refresh control animation.
 */

import UIKit

final class TopMoviesViewController: UIViewController {
    /// Model for network requests and other business logic
    private let topMoviesModel = TopMoviesModel()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var isSearching: Bool = false
    private var filteredMovies: [Top250DataDetails] = []
    
    /// The refresh control used to provide pull-to-refresh functionality to the collection view.
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        return refresh
    }()

    /// The collection view used to display the list of top 250 movies.
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemTeal
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.refreshControl = refreshControl
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topMoviesModel.didUpdated = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        setupNavigationController()
        configureLayout()
        setupCollectionView()
        handleRefreshControl()
        configureSearchController()
        
        filteredMovies = Array(topMoviesModel.moviesData[..<10])
    }
    
    private func configureSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = .done
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search Movie by name"
    }
        
    /// Reloads the top 250 films data and stops the refresh control animation.
    @objc private func handleRefreshControl() {
        refreshControl.beginRefreshing()
        topMoviesModel.fetchMoviesList()
        refreshControl.endRefreshing()
    }
}

// MARK: - UI configure methods

private extension TopMoviesViewController {
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieInfoCell.self, forCellWithReuseIdentifier: "MovieInfoCell")
    }
    
    func setupNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Top 10 IMDB"
    }
    
    /// Configures the layout of the collection view and adds it to the view hierarchy.
    func configureLayout() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension TopMoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return filteredMovies.count
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieInfoCell", for: indexPath) as! MovieInfoCell
        let movie = filteredMovies[indexPath.row]
        cell.setup(with: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = filteredMovies[indexPath.row]
        let movieDetailsViewController = MovieDetailsViewController(movie: movie)
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .moveIn
        transition.subtype = .fromRight

        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(movieDetailsViewController, animated: false)
    }
}

extension TopMoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize.init(width: collectionView.frame.size.width, height: 200)
    }
}

extension TopMoviesViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }

        if !searchText.isEmpty {
            isSearching = true
            filteredMovies.removeAll()

            for movie in topMoviesModel.moviesData {
                if movie.title.lowercased().contains(searchText.lowercased()) {
                    filteredMovies.append(movie)
                }
            }
        } else {
            isSearching = false
            filteredMovies.removeAll()
            filteredMovies = topMoviesModel.moviesData
        }

        collectionView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        filteredMovies.removeAll()
        collectionView.reloadData()
    }
}
