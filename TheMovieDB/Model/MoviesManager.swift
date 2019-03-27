//
//  MoviesManager.swift
//  TheMovieDB
//
//  Created by Javier Cristóbal González Ovalle on 3/14/19.
//  Copyright © 2019 Cencosud. All rights reserved.
//

import UIKit

class MoviesManager: NSObject {
    
    var dataURLString : String = ""
    let apiStrings = APIStrings()
    var totalElements : [MovieResultElement] = Array() {
        didSet {
            print(" new elements: \(totalElements.count) \(totalElements)")
        }}
    
    // MARK: - Table View data source.
    
    func numberOfListSections() -> Int {
        var sections = 0
        if totalElements.count > 0 {
            sections = 1
        }
        return sections
    }
    
    func amountOfElementsInList() -> Int {
        print(" totalElements.count \(totalElements.count)")
        return totalElements.count
    }
    
    func getElementForList(atIndex index : Int) -> MovieResultElement {
        
        return totalElements[index]
    }
    
    // MARK: - Image Utility
    
    func downloadImage(at url: URL, from elementIndex: Int, withCompletion closure: @escaping (UIImage?, Int) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(" Error downloading image.")
                closure(nil, elementIndex)
            } else {
                if let imgData = data {
                    closure(UIImage(data: imgData), elementIndex)
                }
            }
        }
        task.resume()
    }
    
    // MARK: - JSON Data.
    
    func getJSONData(forListType type: TMDBListCategorization, callingClosure closure: @escaping () -> Void) {
    
        switch type {
        case .PopularityList:
            dataURLString = apiStrings.popularURL
        case .TopRatedList:
            dataURLString = apiStrings.topRatedURL
        }
        getRemoteJSONData(thenCall: closure)
    }
    
    private func getRemoteJSONData(thenCall closure : @escaping () -> Void) {
        if let url = URL(string: dataURLString) {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
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

