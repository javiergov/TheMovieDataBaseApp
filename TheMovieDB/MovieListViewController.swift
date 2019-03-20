//
//  MovieListViewController.swift
//  TheMovieDB
//
//  Created by Javier Cristóbal González Ovalle on 3/14/19.
//  Copyright © 2019 Cencosud. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {
    var dataManager = MoviesManager()
    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "The Movies DB"
        
        
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        dataManager.getRemoteJSONData {
            print(" json finalized")
            self.listTableView.backgroundColor = UIColor.yellow
        }
    }
}
