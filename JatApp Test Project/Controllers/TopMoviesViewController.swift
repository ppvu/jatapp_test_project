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
    private let topMoviesModel: TopMoviesModel
    private let searchController = UISearchController(searchResultsController: nil)
    
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
    
    init(topMoviesModel: TopMoviesModel) {
        self.topMoviesModel = topMoviesModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topMoviesModel.didUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        setupNavigationController()
        configureLayout()
        setupCollectionView()
        handleRefreshControl()
        configureSearchController()
    }
    
    private func configureSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = .done
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search Movie by name"
    }
}

// MARK: - UI configure methods

private extension TopMoviesViewController {
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieInfoCell.self, forCellWithReuseIdentifier: Constants.cellIdentifier)
    }
    
    func setupNavigationController() {
        navigationController?.navigationBar.barTintColor = .systemTeal
        navigationController?.navigationBar.prefersLargeTitles = true
        title = Constants.title
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
    
    /// Reloads the top 250 films data and stops the refresh control animation.
    @objc func handleRefreshControl() {
        refreshControl.beginRefreshing()
        topMoviesModel.fetchMoviesList()
        refreshControl.endRefreshing()
    }
}

extension TopMoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        topMoviesModel.movies.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.cellIdentifier, for: indexPath
        ) as? MovieInfoCell else {
            assertionFailure("Cell type not exist!")
            return UICollectionViewCell()
        }
        
        cell.configureCell(with: topMoviesModel.movies[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = topMoviesModel.movies[indexPath.row]
        let movieDetailsModel = MovieDetailsModel(movie: movie)
        let movieDetailsViewController = MovieDetailsViewController(model: movieDetailsModel)
        
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
        CGSize(width: collectionView.frame.size.width - Constants.horizontalPadding * 2, height: Constants.cellHeight)
    }
}

extension TopMoviesViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        topMoviesModel.searchText = searchController.searchBar.text ?? ""
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        topMoviesModel.searchText = ""
    }
}

fileprivate extension TopMoviesViewController {
    enum Constants {
        static let cellHeight: CGFloat = 200.0
        static let horizontalPadding: CGFloat = 8.0
        static let cellIdentifier: String = "MovieInfoCell"
        static let title = "Top 10 IMDB"
        static let initialCellsCount: Int = 10
    }
}
