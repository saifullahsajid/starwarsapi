//
//  FilmsDetailVC.swift
//  StarWarsMovies
//
//  Created by Saif Ullah Sajid on 2019-09-05.
//  Copyright © 2019 Coding Homies. All rights reserved.
//

import UIKit

class FilmsDetailVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var filmTitleLabel: UILabel!
    @IBOutlet weak var filmDirectorLabel: UILabel!
    @IBOutlet weak var filmsProducerLabel: UILabel!
    @IBOutlet weak var filmReleaseDateLabel: UILabel!
    @IBOutlet weak var filmDescriptionLabel: UILabel!
    @IBOutlet weak var charactersTableView: UITableView!
    
    var globalCharacters = [Character]()
    var selectedFilm: Film?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.charactersTableView.delegate = self
        self.charactersTableView.dataSource = self
        Task {
            await fetchCharacters()
        }
    }
    
    // MARK: - Functions
    
    func fetchCharacters() async {
        if let film = self.selectedFilm {
            self.filmTitleLabel.text = film.title
            self.filmReleaseDateLabel.text = film.release_date
            self.filmDirectorLabel.text = film.director
            self.filmsProducerLabel.text = film.producer
            self.filmDescriptionLabel.text = film.opening_crawl
            for characters in film.characters {
                do {
                    let (data, _) = try await URLSession.shared.data(from: URL(string: characters)!)
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    if let charactersData = json?["name"] as? String {
                        let character = Character(character_name: charactersData)
                        globalCharacters.append(character)
                        charactersTableView.reloadData()
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func closeDetailViewController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableView

extension FilmsDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalCharacters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharactersCell", for: indexPath) as! CharactersTVC
        cell.selectionStyle = .none
        cell.characterName.text = globalCharacters[indexPath.row].name
        return cell
    }
}
