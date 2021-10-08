//
//  FilmsVC.swift
//  StarWarsMovies
//
//  Created by Saif Ullah Sajid on 2019-09-04.
//  Copyright © 2019 Coding Homies. All rights reserved.
//

import UIKit
import Alamofire

class FilmsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet weak var filmsTableView: UITableView!
    
    let swapiRequestURL = "https://swapi.dev/api/films/"
    var globalFilmsList = [Film]()
    var charactersList: [String] = []
    var selectedFilm:Film?
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.filmsTableView.separatorStyle = .none
        self.filmsTableView.delegate = self
        self.filmsTableView.dataSource = self
        
        // Fetch the Films dynamically through the Swapi API
        Alamofire.request(swapiRequestURL, method: .get, parameters: nil, encoding: URLEncoding(destination: .methodDependent), headers: nil).responseJSON { (response) in
            print(response)
            guard let JSON = response.result.value as? [String:Any],
                  let filmsData = JSON["results"] as? [[String:Any]] else {
                      print("Could not parse film values")
                      return
                  }
            for film in filmsData {
                
                // Create film objects off of the JSON response
                let title = film["title"] as? String
                self.charactersList = film["characters"] as! [String]
                let director = film["director"] as? String
                let opening_crawl = film["opening_crawl"] as? String
                let producer = film["producer"] as? String
                let release_date = film["release_date"] as? String
                
                let film = Film(film_title: title, film_characters: self.charactersList, film_director: director, film_opening_crawl: opening_crawl, film_producer: producer, film_releaseDate: release_date)
                
                //Saving each iteration in the array
                self.globalFilmsList.append(film)
                
            }
            //Reversing the Array to show the Latest Films fisrt
            self.globalFilmsList.reverse()
            //Reloading the Films TableView
            self.filmsTableView.reloadData()
        }
    }
    
    // MARK: - Films TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalFilmsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilmsCell", for: indexPath) as! FilmsTVC
        
        let film: Film
        film = globalFilmsList[indexPath.row]
        
        cell.selectionStyle = .none
        
        //Assigning data from the array to the cells
        cell.filmTitle.text = film.title
        cell.filmDirector.text = film.director
        cell.releaseDate.text = film.release_date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedFilm = self.globalFilmsList[indexPath.row]
        
        // Calling the segue
        self.performSegue(withIdentifier: "SegueToFilmDetailView", sender: self)
        
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get a reference to the destination Films conrtoller
        let detailViewController = segue.destination as! FilmsDetailVC
        
        // Set the selected film property of the destination Film controller
        detailViewController.selectedFilm = self.selectedFilm
    }
}

