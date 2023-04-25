//
//  MovieDetailsViewController.swift
//  JatApp Test Project
//
//  Created by Yevhen Kononenko on 24.04.2023.
//

import Foundation
import UIKit

final class MovieDetailsViewController: UIViewController {
    private var movie: Top250DataDetails
    private var sortedCounts: [(Character, Int)] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    init(movie: Top250DataDetails) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
        sortedCounts = countCharactersSorted(with: movie.title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CharCountCell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        title = "Characters"
    }
    
    private func countCharactersSorted(with string: String) -> [(Character, Int)] {
        let counts = string
            .lowercased()
            .filter { !$0.isWhitespace }
            .reduce(into: [Character: Int]()) { result, current in
                result[current] = result[current, default: 0] + 1
            }
        
        return Array(counts).sorted(by: { lhs, rhs in
            if lhs.value == rhs.value {
                return lhs.key < rhs.key
            }
            
            return lhs.value > rhs.value
        })
    }
}

extension MovieDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortedCounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharCountCell", for: indexPath)
        let pair = sortedCounts[indexPath.row]
        cell.textLabel?.text = "\(pair.0): \(pair.1)"
        return cell
    }
}
