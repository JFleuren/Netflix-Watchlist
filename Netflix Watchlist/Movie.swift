//
//  Movie.swift
//  Netflix Watchlist
//
//  Created by Vasco Meerman on 07/12/2016.
//  Copyright © 2016 Vasco Meerman. All rights reserved.
//

import Foundation
import Firebase

struct Movie {
   
    let addedByUser: String
    let key: String
    
    // For filling in cells
    let title: String
    let type: String
    let year: String
    let runtime: String
    let netflixRate: String
    
    let poster: String
    
    // Extra info voor DetailVC
    let plot: String
    let genre: String
    let imdbRate: String
    let cast: String
    let director: String
    
    
    let ref: FIRDatabaseReference?
    //var completed: Bool
    
    init(addedByUser: String, key: String = ""
        , title: String = "", type: String = "", year: String = "", runtime: String = "", netflixRate: String = ""
        , poster: String = ""
        , plot: String = "", genre: String = "", imdbRate: String = "", cast: String = "", director: String = "") {
        
        self.addedByUser = addedByUser
        self.key = key
        
        self.title = title
        self.type = type
        self.year = year
        self.runtime = runtime
        self.netflixRate = netflixRate
        
        self.poster = poster
        
        self.plot = plot
        self.genre = genre
        self.imdbRate = imdbRate
        self.cast = cast
        self.director = director
        
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        addedByUser = snapshotValue["addedByUser"] as! String
        title = snapshotValue["title"] as! String
        type = snapshotValue["type"] as! String
        year = snapshotValue["year"] as! String
        runtime = snapshotValue["runtime"] as! String
        netflixRate = snapshotValue["netflixRate"] as! String
        
        poster = snapshotValue["poster"] as! String
        
        plot = snapshotValue["plot"] as! String
        genre = snapshotValue["genre"] as! String
        imdbRate = snapshotValue["imdbRate"] as! String
        cast = snapshotValue["cast"] as! String
        director = snapshotValue["director"] as! String
        
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "addedByUser": addedByUser,
            "title": title,
            "type": type,
            "year": year,
            "runtime": runtime,
            "netflixRate": netflixRate,
            "poster": poster,
            "plot": plot,
            "genre": genre,
            "imdbRate": imdbRate,
            "cast": cast,
            "director": director
        ]
    }
}
