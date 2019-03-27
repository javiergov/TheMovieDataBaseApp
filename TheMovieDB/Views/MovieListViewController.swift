//
//  MovieListViewController.swift
//  TheMovieDB
//
//  Created by Javier Cristóbal González Ovalle on 3/14/19.
//  Copyright © 2019 Cencosud. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MovieCellButtonDelegate {

    var dataManager = MoviesManager()
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var detailView: MovieDetailView!
    @IBOutlet weak var listTypeSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "The Movie Db"
        
        listTableView.delegate = self
        listTableView.dataSource = self        
        self.view.backgroundColor = UIColor.groupTableViewBackground
        detailView.posterActivityIndicator.hidesWhenStopped = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // after the view controller appears load the list with the initial value of the segmented control.
        segementSelected(listTypeSegmentedControl)
    }
    
    @IBAction func segementSelected(_ sender: UISegmentedControl) {
        
        print("selected: \(sender.selectedSegmentIndex)")
        
        let dataUpdateClosure = { DispatchQueue.main.async {
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
    
    // MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.totalElements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier:MovieListCell.reuseIdentifier) as? MovieListCell else {
            fatalError("The dequeued cell is not an instance of MovieListCell.")
        }
        
        let movieElement = dataManager.getElementForList(atIndex: indexPath.row)
        
        print(" title: \(movieElement.title)")
        cell.movieTitleLabel.text = movieElement.title
        cell.moviePopularity.text = String(format: "%.2f", movieElement.popularity)
        cell.movieScore.text = String(format: "%.1f", movieElement.voteAverage)
        cell.informationButton.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func informationButtonDidGetSelected(at row: Int) {
        let selectedMovieElement = dataManager.getElementForList(atIndex: row)
        if let imageURL = selectedMovieElement.getPosterImageURL() {
            print(" imageURL: \(imageURL.absoluteString)")
            detailView.posterActivityIndicator.startAnimating()
            dataManager.downloadImage(at: imageURL, from: row) { (downloadedImage : UIImage?, relatedIndex : Int) in
                if relatedIndex == row {
                    DispatchQueue.main.async {
                        self.detailView.posterActivityIndicator.stopAnimating()
                        self.detailView.poster.image = downloadedImage
                    }
                }
            }
        }
        else {
            detailView.posterActivityIndicator.stopAnimating()
        }
        detailView.titleLabel.text = selectedMovieElement.title
        detailView.descriptionTextView.text = selectedMovieElement.overview
        detailView.descriptionTextView.setContentOffset(CGPoint.zero, animated: true)        
    }
}
