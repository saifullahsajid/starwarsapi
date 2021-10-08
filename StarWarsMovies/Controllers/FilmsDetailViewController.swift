//
//  FilmsDetailViewController.swift
//  StarWarsMovies
//
//  Created by Saif Ullah Sajid on 2019-09-05.
//  Copyright © 2019 Coding Homies. All rights reserved.
//

import UIKit
import Alamofire

class FilmsDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    
    @IBOutlet weak var filmTitle: UILabel!
    @IBOutlet weak var filmDirector: UILabel!
    @IBOutlet weak var filmsProducer: UILabel!
    @IBOutlet weak var filmReleaseDate: UILabel!
    @IBOutlet weak var filmDescrption: UILabel!
    @IBOutlet weak var charactersTableView: UITableView!
    
    var globalCharacterList = [CharactersModel]()
    var selectedFilm:FilmsModel?
    
    
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
                Alamofire.request(characters, method: .get, parameters: nil, encoding: URLEncoding(destination: .methodDependent), headers: nil).responseJSON { (response) in
                    guard let JSON = response.result.value as? [String:Any],
                          let charactersData = JSON["name"] as? String else {
                              print("Could not parse character values")
                              return
                          }
                    let character = CharactersModel(character_name: charactersData)
                    self.globalCharacterList.append(character)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharactersCell", for: indexPath) as! CharactersTableViewCell
        let characters: CharactersModel
        characters = self.globalCharacterList[indexPath.row]
        cell.selectionStyle = .none
        cell.characterName.text = characters.name
        return cell
    }
    
}
