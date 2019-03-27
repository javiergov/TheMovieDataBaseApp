//
//  MovieDetailView.swift
//  TheMovieDB
//
//  Created by Javier Cristóbal González Ovalle on 3/26/19.
//  Copyright © 2019 Cencosud. All rights reserved.
//

import UIKit

class MovieDetailView : UIView {
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var posterActivityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionTextView.text = nil
        titleLabel.text = nil
        poster.image = nil
    }
}
