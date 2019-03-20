//
//  MoviesManager.swift
//  TheMovieDB
//
//  Created by Javier Cristóbal González Ovalle on 3/14/19.
//  Copyright © 2019 Cencosud. All rights reserved.
//

import UIKit

struct MovieResultElement : Decodable {
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

class MoviesManager: NSObject {
    
    let dataURLString = "https://api.themoviedb.org/3/movie/popular?api_key=34738023d27013e6d1b995443764da44"
    
    var totalElements : [MovieResultElement] = Array.init() {
        didSet {
            print(" new elements: \(totalElements.count) \(totalElements)")
        }}
    
    func dummyData() {
        self.totalElements = Array()
    }
    
    // MARK: - Table View data source.
    
    func numberOfListSections() -> Int {
        var sections = 0
        if totalElements.count > 0 {
            sections = 1
        }
        return sections
    }
    
    func amountOfElementsInList() -> Int {
        print("•• totalElements.count \(totalElements.count)")
        return totalElements.count
    }
    
    func getElementForList(atIndex index : Int) -> MovieResultElement {
        
        return totalElements[index]
    }
    
    // MARK: - JSON Data.
    
    func getRemoteJSONData(thenCall closure : @escaping () -> Void) {
        if let url = URL(string: dataURLString) {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
                if error != nil {
                    print("Error obtaining JSON data.")
                } else {
                    if let jsonData = data {
                        print("json data: \(jsonData)")
                        self.parseJSON(data: jsonData)
                        closure()
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(data: Data) {
        do {
            let decoder = JSONDecoder()
            let decodedList : MovieList = try decoder.decode(MovieList.self, from: data)
            self.totalElements = decodedList.results
        } catch let error {
            print("\(error)")
        }
    }
}

