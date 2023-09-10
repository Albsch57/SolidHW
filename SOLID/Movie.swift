//
//  Movie.swift
//  SOLID
//
//  Created by Влад Третьяк on 06.09.2023.
//

import Foundation

struct Movie: Equatable {
    let name: String
    let genre: [Genre]

    enum Genre: String, CaseIterable {
        case all, action, comedy, drama, horror, romance, triller, fantasy, crime, sciFi

        var title: String {
            self == .all ? "Выберите жанр" : rawValue
        }
    }
}
