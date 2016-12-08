//
//  OmdbSearch.swift
//  Netflix Watchlist
//
//  Created by Vasco Meerman on 08/12/2016.
//  Copyright © 2016 Vasco Meerman. All rights reserved.
//

import Foundation


class OmdbSearch {
    
    var movies = [MovieSearchNetflix]()
    var titles = [String]()
    
    var netflix = NetflixCheck()
    
    func searchDataBases(searchkeyword: String) -> Array<MovieSearchNetflix> {
        
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
                                self.titles = [String]()
                                }
                            if let jsonMovies = dictionary["Search"] as? [AnyObject]{
                                for jsonMovie in jsonMovies {
                                    let title = jsonMovie["Title"] as! String
                                    print(title)
                                    self.titles.append(title)
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
        
        for title in titles {
            var movieNetflix = MovieSearchNetflix()
            movieNetflix = netflix.searchNetflix(title: title)
            movies.append(movieNetflix)
        }
//        movies = netflix.searchNetflix(titles: titles)
        
        print ("++++++++++FOUND BY NETFLIX \(movies) +++++++++++++")
        return movies
    }
    
    
}