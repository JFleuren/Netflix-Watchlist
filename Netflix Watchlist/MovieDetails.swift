//
//  MovieSearch.swift
//  Netflix Watchlist
//
//  Created by Vasco Meerman on 08/12/2016.
//  Copyright © 2016 Vasco Meerman. All rights reserved.
//
//  This class is created for the temporary assignment of movie information while searching
//  Nothing needs to be saved.

import Foundation

class MovieDetails {
    
    var poster = ""
    
    var title = ""
    var year = ""
    var category = ""
    var netflixRate = ""
    
    var type = ""
    var released = ""
    var genre = ""
    var plot = ""
    var cast = ""
    var runtime = ""
    var director = ""
    var writer = ""
    var imdbRate = ""
    
    
    var posterUrl: URL?
 
    func createPosterUrl(url: String) -> URL{
        let posterLink =  URL(string: "\(url)")
        return posterLink!
    }
    

}
