//
//  ViewController.swift
//  JatApp Test Project
//
//  Created by Yevhen Kononenko on 20.04.2023.
//

import UIKit

class Top250FilmsViewController: UIViewController {
    lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var top250Data: Top250Data?
    
    let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        moviesList()
    }
    
    func moviesList() {
        guard let infoDict = Bundle.main.infoDictionary, let apiKey = infoDict["IMDBApiKey"] as? String else { fatalError("IMDBApiKey not found in Info.plist") }
        
        let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/\(apiKey)")
        
        networkService.requestDecoding(resourse: Resourse(url: url), decodingType: Top250Data.self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.top250Data = data
            case .failure:
                self?.top250Data = nil
            }
        }
    }
}
