//
//  MovieDetailsViewController.swift
//  JatApp Test Project
//
//  Created by Yevhen Kononenko on 24.04.2023.
//

import Foundation
import UIKit

// TODO: - sortedcounts -> Typealias, make MODEL

final class MovieDetailsViewController: UIViewController {
    private let model: MovieDetailsModel
    private lazy var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    init(model: MovieDetailsModel) {
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.countCellIdentifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        title = Constants.title
    }
}

extension MovieDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.sortedCounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.countCellIdentifier, for: indexPath)
        let pair = model.sortedCounts[indexPath.row]
        cell.textLabel?.text = "\(pair.0): \(pair.1)"
        return cell
    }
}

fileprivate extension MovieDetailsViewController {
    enum Constants {
        static let countCellIdentifier: String = "CharCountCell"
        static let title: String = "Characters"
    }
}
