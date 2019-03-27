//
//  ModelStructures.swift
//  TheMovieDB
//
//  Created by Javier Cristóbal González Ovalle on 3/26/19.
//  Copyright © 2019 Cencosud. All rights reserved.
//

import Foundation

enum TMDBListCategorization {
    case PopularityList
    case TopRatedList
}

struct APIStrings {
    let apiKey = "34738023d27013e6d1b995443764da44"
    let popularURL = "https://api.themoviedb.org/3/movie/popular?api_key=34738023d27013e6d1b995443764da44"
    let topRatedURL = "https://api.themoviedb.org/3/movie/top_rated?api_key=34738023d27013e6d1b995443764da44"
}

struct MovieResultElement : Decodable {
    static private let basePosterURLString = "https://image.tmdb.org/t/p/w500"
    
    var voteCount : Int
    var identification : Int
    var video : Bool
    var voteAverage : Float
    var title : String
    var popularity : Float
    var posterPath : String
    var originalLanguage : String
    var originalTitle : String
    var genreIds : [Int]
    var backdropPath : String
    var adult : Bool
    var overview : String
    var releaseDate : String
    //CodingKeys
    private enum CodingKeys: String, CodingKey {
        case video, title, popularity, adult, overview
        case voteCount = "vote_count"
        case identification = "id"
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIds = "genre_ids"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
    }
    
    func getPosterImageURL() -> URL? {
        let posterURLString = MovieResultElement.basePosterURLString + posterPath
        return URL(string: posterURLString)
    }
}

struct MovieList : Decodable {
    var totalResult : Int
    var totalPages : Int
    var results : [MovieResultElement]
    var page : Int
    
    //CodingKeys
    private enum CodingKeys: String, CodingKey {
        case totalResult = "total_results"
        case totalPages = "total_pages"
        case results
        case page
    }
}
