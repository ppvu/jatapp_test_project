//
//  ViewController.swift
//  JatApp Test Project
//
//  Created by Yevhen Kononenko on 20.04.2023.
//

import UIKit

/*
 TODO:
 1. Make cell selection to redirect to next screen
 2. Count the occurrence of each character in the title
  that you have received before and display
  results using any UI component.
 3. Refactor
 4. UI imporvements
 5. Local data cache
 6. Mb tests
 7. Custom transition between screens
 8. Local/remote search
*/

final class TopMoviesViewController: UIViewController {
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(reloadAction), for: .valueChanged)
        return refresh
    }()
    
    lazy var layout = UICollectionViewFlowLayout()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.refreshControl = refreshControl
        return collectionView
    }()
    
    var top250Data: [Top250DataDetail] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Top 10"
        
        configureLayout()
        setupTableView()
        
        refreshControl.beginRefreshing()
        
        reloadAction()
    }
    
    private func configureLayout() {
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func moviesList() {
        guard let infoDict = Bundle.main.infoDictionary, let apiKey = infoDict["IMDBApiKey"] as? String else { fatalError("IMDBApiKey not found in Info.plist") }
        
        let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/\(apiKey)")
        
        networkService.requestDecoding(resourse: Resourse(url: url), decodingType: Top250Data.self) { [weak self] result in
            switch result {
            case .success(let data):
                if data.errorMessage.isEmpty {
                    self?.top250Data = data.items
                    return
                }
                
                fallthrough
            case .failure:
                self?.top250Data = []
            }
        }
    }
    
    private func setupTableView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieInfoCell.self, forCellWithReuseIdentifier: "MovieInfoCell")
    }
    
    @objc func reloadAction() {
        moviesList()
        refreshControl.endRefreshing()
    }
}

extension TopMoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(top250Data.count, 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieInfoCell", for: indexPath) as! MovieInfoCell
        let movie = top250Data[indexPath.row]
        cell.setup(with: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = top250Data[indexPath.row]
        let movieDetailsViewController = MovieDetailsViewController(movie: movie)
        navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
}

extension TopMoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize.init(width: collectionView.frame.size.width, height: 200)
    }
}
