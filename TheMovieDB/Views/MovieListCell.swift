//
//  MovieListCell.swift
//  TheMovieDB
//
//  Created by Javier Cristóbal González Ovalle on 3/26/19.
//  Copyright © 2019 Cencosud. All rights reserved.
//

import UIKit

protocol MovieCellButtonDelegate {
    func informationButtonDidGetSelected(at row : Int)
}

class MovieListCell: UITableViewCell {
    
    var delegate : MovieCellButtonDelegate? = nil
    @IBOutlet weak var informationButton: UIButton!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var moviePopularity: UILabel!
    @IBOutlet weak var movieScore: UILabel!
    static let reuseIdentifier = "movieListCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func informationButtonAction(_ sender: UIButton) {
        self.delegate?.informationButtonDidGetSelected(at: sender.tag)
    }
}
