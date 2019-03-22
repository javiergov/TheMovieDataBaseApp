//
//  MovieListViewController.swift
//  TheMovieDB
//
//  Created by Javier Cristóbal González Ovalle on 3/14/19.
//  Copyright © 2019 Cencosud. All rights reserved.
//

import UIKit

class MovieListCell: UITableViewCell {
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var moviePopularity: UILabel!
    @IBOutlet weak var movieScore: UILabel!
    static let reuseIdentifier = "movieListCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

class MovieListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var dataManager = MoviesManager()
    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "The Movies DB"
        
        listTableView.delegate = self
        listTableView.dataSource = self
        self.view.backgroundColor = UIColor.groupTableViewBackground
        getUpdatedData()
    }
    
    @IBAction func segementSelected(_ sender: UISegmentedControl) {
        
        print("selected: \(sender.selectedSegmentIndex)")
        
        let dataUpdateClosure = { DispatchQueue.main.async {
            self.listTableView.backgroundColor = UIColor.blue
            self.listTableView.reloadData()
            }
        }
        
        switch sender.selectedSegmentIndex {
        case 0:
            dataManager.getJSONData(forListType: .PopularityList, callingClosure: dataUpdateClosure)
        case 1:
            dataManager.getJSONData(forListType: .TopRatedList, callingClosure: dataUpdateClosure)
        default:
            print(" Unassociated segment")
        }
    }

    func getUpdatedData() {
        dataManager.getRemoteJSONData {
            print(" json finalized")
            DispatchQueue.main.async {
                self.listTableView.backgroundColor = UIColor.yellow
                self.listTableView.reloadData()
            }
        }
    }
    
    // MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.totalElements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier:MovieListCell.reuseIdentifier) as? MovieListCell else {
            fatalError("The dequeued cell is not an instance of GLListCell.")
        }
        
        let movieElement = dataManager.getElementForList(atIndex: indexPath.row)
        
        print(" title: \(movieElement.title)")
        cell.movieTitleLabel.text = movieElement.title
        cell.moviePopularity.text = String(format: "%.2f", movieElement.popularity)
        cell.movieScore.text = String(format: "%.1f", movieElement.voteAverage)
        return cell
    }
}
