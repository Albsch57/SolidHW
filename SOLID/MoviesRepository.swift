//
//  MoviesRepository.swift
//  SOLID
//
//  Created by Влад Третьяк on 06.09.2023.
//

import Foundation

fileprivate var movies = [
    Movie(name: "Бойцовский клуб", genre: [.action, .triller, .drama]),
    Movie(name: "Зеленая миля", genre: [.drama, .fantasy, .crime]),
    Movie(name: "1+1", genre: [.comedy, .drama]),
    Movie(name: "Побег из Шоушенка", genre: [.drama]),
    Movie(name: "Матрица", genre: [.action, .sciFi])
]

protocol MoviesRepository {
    func fetchMovies(for genre: Movie.Genre) -> [Movie]
    func deleteMovie(_ movie: Movie)
    
    func saveMovie(_ movie: Movie) // Нарушение принципа разделения интерфейса (Interface Segregation Principle, ISP)
    func pingToNetwork() -> Bool // Тоже нарушение
}

class BaseRepository {
    func deleteMovie(_ movie: Movie) {
        fatalError("This functionality must be implemented by the descendant class")
    }
}

final class MoviesCoreDataRepository: BaseRepository {
    func fetchMovies(for genre: Movie.Genre) -> [Movie] {
        guard genre != .all else { return movies }
        return movies.filter({ $0.genre.contains(genre) })
    }
    
    override func deleteMovie(_ movie: Movie) {
        if let index = movies.firstIndex(where: { $0 == movie }) {
            movies.remove(at: index)
        }
    }
}

final class MoviesNetworkRepository: BaseRepository {
    func fetchMovies(for genre: Movie.Genre) -> [Movie] {
        guard genre != .all else { return movies }
        return movies.filter({ $0.genre.contains(genre)})
    }
    
    override func deleteMovie(_ movie: Movie) {
        // Empty
        // Нарушение принципа подстановки Барбары Лисков (Liskov Substitution Principle, LSP)
        // Тк оставляем пустую реализацию, и в случае использования этого метода у данного класса
        // Мы сломаем программу.
    }
}
