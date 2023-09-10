//
//  View+ViewModel.swift
//  SOLID
//
//  Created by Влад Третьяк on 06.09.2023.
//

import UIKit

final class MoviesListViewModel {
    
    // Нарушены сразу 2 принципа:
    // - Открытости/Закрытости
    // - Принцип инверсии зависимостей (Dependency Inversion Principle, DIP) (Тк ViewModel зависит от конкретных реализаций)
    //    private lazy var coreDataRepository = MoviesCoreDataRepository()
    //    private lazy var networkRepository = MoviesNetworkRepository()
    //
    
    private let repository: MoviesRepository
    
    private let tableView: UITableView
    private let source: DataSource
    private var movies = [Movie]()
    
    var didUpdateMovies: (() -> Void)?
    
    init(tableView: UITableView, repository: MoviesRepository, source: DataSource) {
        self.tableView = tableView
        self.repository = repository
        self.source = source
    }
    
    
    //    // Нарушен принцип открытости/закрытости (Open-Closed Principle, OCP)
    //    func loadMovies(by genre: Movie.Genre, source: DataSource = .coreData) {
    //        if source == .coreData {
    //            movies = coreDataRepository.fetchMovies(for: genre)
    //        }
    //
    //        else if source == .network {
    //            movies = networkRepository.fetchMovies(for: genre)
    //        }
    //
    //        // Нарушение принцип единственной ответственности (Single Responsibility Principle, SRP)
    //        updateUI()
    //    }
    
    func loadMovies(by genre: Movie.Genre, sources: DataSource) {
        movies = repository.fetchMovies(for: genre, source: sources)
        tableView.reloadData()
        didUpdateMovies
    }
    
    func movie(of indexPath: IndexPath) -> Movie? {
        guard movies.indices.contains(indexPath.row) else { return nil }
        return movies[indexPath.row]
    }
    
    func numberOfMovies(for genre: Movie.Genre) -> Int {
        guard genre != .all else { return movies.count }
        return movies.filter({ $0.genre.contains(genre) }).count
    }
    
    //    // Принцип единственной ответственности (Single Responsibility Principle, SRP)
    //    private func updateUI() {
    //        tableView.reloadData()
    //    }
}
