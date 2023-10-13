//
//  FilmService.swift
//  StarWarsMovies
//
//  Created by Saif Ullah Sajid on 14/10/2023.
//  Copyright © 2023 Coding Homies. All rights reserved.
//

import Foundation

class FilmService {
    
    let swapiRequestURL = "https://swapi.dev/api/films/"
    
    func fetchFilms() async -> [Film] {
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: swapiRequestURL)!)
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let filmsData = json["results"] as? [[String: Any]] {
                var films: [Film] = []
                for film in filmsData {
                    let title = film["title"] as? String
                    let characters = film["characters"] as? [String] ?? []
                    let director = film["director"] as? String
                    let openingCrawl = film["opening_crawl"] as? String
                    let producer = film["producer"] as? String
                    let releaseDate = film["release_date"] as? String
                    let film = Film(
                        film_title: title,
                        film_characters: characters,
                        film_director: director,
                        film_opening_crawl: openingCrawl,
                        film_producer: producer,
                        film_releaseDate: releaseDate
                    )
                    films.append(film)
                }
                films.reverse()
                return films
            }
            return []
        } catch {
            return []
        }
    }
}
