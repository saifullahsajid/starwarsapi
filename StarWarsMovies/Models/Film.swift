//
//  Film.swift
//  StarWarsMovies
//
//  Created by Saif Ullah Sajid on 2019-09-04.
//  Copyright © 2019 Coding Homies. All rights reserved.
//

import UIKit

class Film: NSObject {
    
    var title: String?
    var characters: [String] = []
    var director: String?
    var opening_crawl: String?
    var producer: String?
    var release_date: String?
    
    init(film_title: String?, film_characters: [String] = [], film_director: String?, film_opening_crawl: String?, film_producer: String?, film_releaseDate: String?){
        self.title = film_title
        self.characters = film_characters
        self.director = film_director
        self.opening_crawl = film_opening_crawl
        self.producer = film_producer
        self.release_date = film_releaseDate
    }
}
