//
//  SearchViewController.swift
//  Netflix Watchlist
//
//  Created by Vasco Meerman on 07/12/2016.
//  Copyright © 2016 Vasco Meerman. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Movie class to temporarely store movie results to display
    var movieTitles = Array<String>()
    var moviePosters = Array<String>()
    
    // First searches omdb api for the titles and then checks the titles against netflix's database API
    // Because netflix's API has no search function, only title lookup
//    var lookUpNetflix = OmdbSearch()
    
    
    // indicatie if a search is active
    var searchActive : Bool = false
    
    // movietitle in current cell which is clicked on will be stored here so it can send the title with the seque performed
    var movieTitlePass: [String: String]!

    var moviecount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
//        self.tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    // called when cancel button is clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchActive = false
        self.tableView.reloadData()
    }
    
    // called whenever text is changed.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        self.movieTitles = Array<String>()
//        self.moviePosters = Array<String>()
//        searchDataBases(searchkeyword: searchText)

    }

    @IBAction func searchForMovies(_ sender: Any) {
        self.movieTitles = Array<String>()
        self.moviePosters = Array<String>()
        self.moviecount = 0
        searchOMDB(searchkeyword: self.searchBar.text!)
    }

    func searchOMDB(searchkeyword: String) {
        
        var searchkeywords = searchkeyword
        searchkeywords = searchkeywords.replacingOccurrences(of: " ", with: "+")
        let link = URL(string: "https://www.omdbapi.com/?s=\(searchkeywords)&r=json")
        
        URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) -> Void in
            
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode == 200) {
                    
                    if data != nil {
                        do {
                            let dictionary = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary

                            if let jsonMovies = dictionary["Search"] as? [AnyObject]{
                                for jsonMovie in jsonMovies {
                                    let title = jsonMovie["Title"] as! String
                                    let poster = jsonMovie["Poster"] as! String
                                    print("!!!\(title)!!!!!")
                                    self.searchMovieCount(movieTitle: title)
                                    self.movieTitles.append(title)
                                    self.moviePosters.append(poster)
                                }
                            }
                            self.tableView.reloadData()

                        } catch {
                            print("Failed to convert to JSON")
                        }
                    }
                }
            }
        }).resume()
    }
    
    func searchMovieCount(movieTitle: String) {
        var pickedTitle = movieTitle
        pickedTitle = pickedTitle.replacingOccurrences(of: " ", with: "%20")
        let link = URL(string: "https://netflixroulette.net/api/api.php?title=\(pickedTitle)")
        if link != nil {
            URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) -> Void in
                if let httpResponse = response as? HTTPURLResponse {
                    if (httpResponse.statusCode == 200) {
                        if data != nil {
                            self.moviecount += 1
                            self.tableView.reloadData()
                        }
                    }
                }
            }).resume()
        }
    }
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    // returns the number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         print("There are \(self.moviecount) movies found at the netflix database")

        return self.moviecount
    }
    
    //TODO: CREATE SEQUE TO THE DETAIL VC
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("You selected cell #\(indexPath.row)!")
        
        let indexPath = tableView.indexPathForSelectedRow!
        
        let currentcell = tableView.cellForRow(at: indexPath) as! SearchViewCell

        // Get Cell Label
        movieTitlePass = ["title": currentcell.titleLabel.text!,
                          "nfRate": currentcell.netflixRate.text!,
                          "hideWLButton": "no"
        ]
        
        print("++++++ \(movieTitlePass)+++++")
        
        self.performSegue(withIdentifier: "toDetails", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "toDetails") {
            // initialize new view controller and cast it as your view controller
            let MovieDetailVC = segue.destination as! MovieDetailsViewController
            // your new view controller should have property that will store passed value
            MovieDetailVC.titleAndRate = movieTitlePass
            
        }else { print("no segue is performed")}
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchViewCell

        if self.movieTitles.isEmpty == false {
            cell.searchNetflix(movieTitle: self.movieTitles[indexPath.row], moviePoster: self.moviePosters[indexPath.row])
            cell.setNeedsLayout() //invalidate current layout
            cell.layoutIfNeeded() //update immediately
        
        }else{print("No more movies to print")}
        
        return cell
    }


}

