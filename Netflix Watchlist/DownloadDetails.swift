//
//  downloadDetails.swift
//  Netflix Watchlist
//
//  Created by Vasco Meerman on 09/12/2016.
//  Copyright © 2016 Vasco Meerman. All rights reserved.
//

import Foundation


class DownloadDetails {
    
    func titleDownload(titleDetail: String, NFRate: String) -> MovieDetails {
        
        let movie = MovieDetails()
        var title = titleDetail
        
        title = title.replacingOccurrences(of: " ", with: "+")
        
        let link = URL(string: "https://www.omdbapi.com/?t=\(title)&r=json")
        
        URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) -> Void in
            
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode == 200) {
                    
                    if data != nil {
                        do {
                            let dictionary = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                            movie.title = dictionary["Title"] as! String
                            print(movie.title)
                            movie.year = dictionary["Released"] as! String
                            movie.type = dictionary["Type"] as! String
                            movie.imdbRate = dictionary["imdbRating"] as! String
                            movie.genre = dictionary["Genre"] as! String
                            movie.plot = dictionary["Plot"] as! String
                            movie.actors = dictionary["Actors"] as! String
                            movie.runtime = dictionary["Runtime"] as! String
                            movie.director = dictionary["Director"] as! String
                            movie.writer = dictionary["Writer"] as! String
                            
                            movie.netflixRate = NFRate
                            movie.poster = dictionary["Poster"] as! String
                            
                        } catch {
                            print("Failed to convert to JSON")
                        }
                    }
                }
            }
        }).resume()
        return movie
    }
}
