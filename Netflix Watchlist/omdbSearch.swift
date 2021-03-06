//
//  OmdbSearch.swift
//  Netflix Watchlist
//
//  Created by Vasco Meerman on 08/12/2016.
//  Copyright © 2016 Vasco Meerman. All rights reserved.
//

import Foundation


class OmdbSearch {
    
    var movies = [MovieDetails]()
    
    var titles = [String]()
    var posters = [String]()
    
    var netflix = NetflixCheck()
    
    func searchDataBases(searchkeyword: String) -> Array<MovieDetails> {
        
        var searchkeywords = searchkeyword
        searchkeywords = searchkeywords.replacingOccurrences(of: " ", with: "+")
        let link = URL(string: "https://www.omdbapi.com/?s=\(searchkeywords)&r=json")
        
        URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) -> Void in
            
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode == 200) {
                    
                    if data != nil {
                        do {
                            let dictionary = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                            
                            if self.titles.isEmpty == false{
                                self.titles.removeAll()
                                }
                            if self.posters.isEmpty == false{
                                self.posters.removeAll()
                            }

                            if let jsonMovies = dictionary["Search"] as? [AnyObject]{
                                for jsonMovie in jsonMovies {
                                    let title = jsonMovie["Title"] as! String
                                    let poster = jsonMovie["Poster"] as! String
                                    self.titles.append(title)
                                    self.posters.append(poster)
                                }
                            }
                            
                        } catch {
                            print("Failed to convert to JSON")
                        }
                    }
                    
                }
            }
        }).resume()

        print ("**********FOUND BY OMDB \(titles) *************")
        print ("**********FOUND BY OMDB \(posters) *************")
        
        
//        DispatchQueue.main.async() { () -> Void in
//            self.movies = self.netflix.searchNetflix(titles: self.titles)
//        }
//        DispatchQueue.main.asynchronously() {
//            // go to something on the main thread with the image like setting to UIImageView
//             movies = netflix.searchNetflix(titles: titles)
//        }

        self.movies = self.netflix.searchNetflix(titles: self.titles, posters: posters)
        
        print ("++++++++++FOUND BY NETFLIX \(movies) +++++++++++++")
        return movies
    }
    
    
}
