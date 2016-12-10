//
//  NetflixCheck.swift
//  Netflix Watchlist
//
//  Created by Vasco Meerman on 08/12/2016.
//  Copyright © 2016 Vasco Meerman. All rights reserved.
//

import Foundation

class NetflixCheck {
    
    var movies = [MovieDetails]()

    func searchNetflix(titles: [String], posters: [String]) -> Array<MovieDetails> {

        
      for (index, title) in titles.enumerated() {
            var pickedTitle = title
            pickedTitle = pickedTitle.replacingOccurrences(of: " ", with: "%20")
            let link = URL(string: "https://netflixroulette.net/api/api.php?title=\(pickedTitle)")
            URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) -> Void in
                if let httpResponse = response as? HTTPURLResponse {
                    if (httpResponse.statusCode == 200) {
                        
                        if data != nil {
                            
                            do {
                                let dictionary = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                                let movie = MovieDetails()
                                
                                movie.title = dictionary["show_title"] as! String
                                movie.year = dictionary["release_year"] as! String
                                movie.category = dictionary["category"] as! String
                                movie.netflixRate = dictionary["rating"] as! String
                                movie.poster = posters[index]
                                
                                print (movie.poster)
                                self.movies.append(movie)
                                
                            } catch {
                                print("Failed to convert to JSON")
                            }
                        }
                    }
                }
            }).resume()
        }
        return movies
        
    }
    
}
