//
//  FilmsDetailVC.swift
//  StarWarsMovies
//
//  Created by Saif Ullah Sajid on 2019-09-05.
//  Copyright © 2019 Coding Homies. All rights reserved.
//

import UIKit
import Alamofire

class FilmsDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet weak var filmTitle: UILabel!
    @IBOutlet weak var filmDirector: UILabel!
    @IBOutlet weak var filmsProducer: UILabel!
    @IBOutlet weak var filmReleaseDate: UILabel!
    @IBOutlet weak var filmDescrption: UILabel!
    
    @IBOutlet weak var charactersTableView: UITableView!
    
    var globalCharacterList = [Character]()
    var selectedFilm:Film?

    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.charactersTableView.delegate = self
        self.charactersTableView.dataSource = self
        
        if let film = self.selectedFilm {
            self.filmTitle.text = film.title
            self.filmReleaseDate.text = film.release_date
            self.filmDirector.text = film.director
            self.filmsProducer.text = film.producer
            self.filmDescrption.text = film.opening_crawl
            
            for characters in film.characters {
                print(characters)
                // Fetch the characters dynamically through the Swapi API
                Alamofire.request(characters, method: .get, parameters: nil, encoding: URLEncoding(destination: .methodDependent), headers: nil).responseJSON { (response) in

                    // Create Character objects off of the JSON response
                    guard let JSON = response.result.value as? [String:Any],
                        let charactersData = JSON["name"] as? String else {
                            print("Could not parse character values")
                            return
                    }
                    let character = Character(character_name: charactersData)
                    
                    //Saving each iteration in the array
                    self.globalCharacterList.append(character)
                    //Reloading the Characters TableView
                    self.charactersTableView.reloadData()
                }
                
            }
            }
    }
    
    // MARK: - Button Actions
    @IBAction func closeDetailViewController(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Characters TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalCharacterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharactersCell", for: indexPath) as! CharactersTVC
        
        let characters: Character
        characters = self.globalCharacterList[indexPath.row]
        
        //Asssiging data from the array to the cells
        cell.selectionStyle = .none
        cell.characterName.text = characters.name
        
        return cell
    }

}
