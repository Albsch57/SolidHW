//
//  ViewController.swift
//  SOLID
//
//  Created by Влад Третьяк on 06.09.2023.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private lazy var viewModel = MoviesListViewModel(tableView: tableView)
    
    // Нарушение принципа единственной ответственности (Single Responsibility Principle, SRP)
    private var currentGenre: Movie.Genre = .all {
        didSet {
            chooseGenreButton.title = currentGenre.title.capitalized
            viewModel.loadMovies(by: currentGenre)
        }
    }
    
    
    private var chooseGenreButton: UIBarButtonItem! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        configureUIBarButtonItems()
        viewModel.loadMovies(by: currentGenre)
    }
    
    private func configureUIBarButtonItems() {
        let actions = Movie.Genre.allCases.map { genre in
            UIAction(title: genre.rawValue.capitalized) { [weak self] action in
                self?.currentGenre = genre
            }
        }
        
        let menu = UIMenu(children: actions)
        chooseGenreButton = UIBarButtonItem(title: currentGenre.title, image: nil, menu: menu)
        
        navigationItem.rightBarButtonItem = chooseGenreButton
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfMovies(for: currentGenre)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let movie = viewModel.movie(of: indexPath)
        
        var configuration = cell.defaultContentConfiguration()
        configuration.text = movie?.name
        configuration.secondaryText = movie?.genre.map({ $0.rawValue.capitalized }).joined(separator: ",")
        configuration.secondaryTextProperties.color = .secondaryLabel
        cell.contentConfiguration = configuration
        
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
}
