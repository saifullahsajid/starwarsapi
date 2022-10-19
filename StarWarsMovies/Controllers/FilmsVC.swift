//
//  FilmsVC.swift
//  StarWarsMovies
//
//  Created by Saif Ullah Sajid on 2019-09-04.
//  Copyright © 2019 Coding Homies. All rights reserved.
//


import UIKit
import Alamofire

class FilmsVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var filmsTableView: UITableView!
    
    let swapiRequestURL = "https://swapi.dev/api/films/"
    var globalFilms = [Film]()
    var characters: [String] = []
    var selectedFilm:Film?
    let images: [UIImage] = [UIImage(named: "sw1")!, UIImage(named: "sw2")!, UIImage(named: "sw3")!, UIImage(named: "sw4")!, UIImage(named: "sw5")!, UIImage(named: "sw6")!]
    
    // MARK: - viewWillAppear
//    override func viewWillAppear(_ animated: Bool) {
////        navigationController?.navigationBar.barStyle = .black
//    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.filmsTableView.separatorStyle = .none
        self.filmsTableView.delegate = self
        self.filmsTableView.dataSource = self
        fetchFilms()
    }
    
    func fetchFilms() {
        Alamofire.request(swapiRequestURL, method: .get, parameters: nil, encoding: URLEncoding(destination: .methodDependent), headers: nil).responseJSON { [weak self] (response) in
            guard let weakSelf = self else { return }
            guard let JSON = response.result.value as? [String:Any],
                  let filmsData = JSON["results"] as? [[String:Any]] else {
                      print("Could not parse film values")
                      return
                  }
            for film in filmsData {
                let title = film["title"] as? String
                weakSelf.characters = film["characters"] as! [String]
                let director = film["director"] as? String
                let opening_crawl = film["opening_crawl"] as? String
                let producer = film["producer"] as? String
                let release_date = film["release_date"] as? String
                let film = Film(film_title: title, film_characters: weakSelf.characters, film_director: director, film_opening_crawl: opening_crawl, film_producer: producer, film_releaseDate: release_date)
                weakSelf.globalFilms.append(film)
            }
            weakSelf.globalFilms.reverse()
            DispatchQueue.main.async {
                weakSelf.filmsTableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailViewController = segue.destination as! FilmsDetailVC
        detailViewController.selectedFilm = self.selectedFilm
    }
}


// MARK: - UITableView

extension FilmsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalFilms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilmsCell", for: indexPath) as! FilmsTVC
        cell.selectionStyle = .none
        cell.filmTitle.text = globalFilms[indexPath.row].title
        cell.filmDirector.text = globalFilms[indexPath.row].director
        cell.releaseDate.text = globalFilms[indexPath.row].release_date
        cell.filmThumbnail.image = images.randomElement()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFilm = globalFilms[indexPath.row]
        performSegue(withIdentifier: "SegueToFilmDetailView", sender: self)
    }
}
