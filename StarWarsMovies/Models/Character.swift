//
//  Character.swift
//  StarWarsMovies
//
//  Created by Saif Ullah Sajid on 2019-09-05.
//  Copyright © 2019 Coding Homies. All rights reserved.
//

import UIKit

class Character: NSObject {
    
    var name: String?
    
    init(character_name: String?){
        self.name = character_name
    }
}
