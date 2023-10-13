//
//  FilmsVC.swift
//  StarWarsMovies
//
//  Created by Saif Ullah Sajid on 2019-09-04.
//  Copyright © 2019 Coding Homies. All rights reserved.
//


import UIKit

class FilmsVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var filmsTableView: UITableView!
    
    var globalFilms = [Film]()
    var characters: [String] = []
    var selectedFilm: Film?
    let filmService = FilmService()
    let images: [UIImage] = [UIImage(named: "sw1")!, UIImage(named: "sw2")!, UIImage(named: "sw3")!, UIImage(named: "sw4")!, UIImage(named: "sw5")!, UIImage(named: "sw6")!]
    
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
        Task {
            globalFilms = await filmService.fetchFilms()
            filmsTableView.reloadData()
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
