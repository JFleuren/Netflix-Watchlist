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
    
    // First searches omdb api for the titles and then checks the titles against netflix's database API
    // Because netflix's API has no search function, only title lookup
    var lookUpNetflix = OmdbSearch()
    
    // Movie class to temporarely store movie results to display
    var movies = [MovieSearchNetflix]()
    
    // indicatie if a search is active
    var searchActive : Bool = false
    
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
        self.tableView.reloadData()
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
        self.movies.removeAll()
//        self.movies = [MovieSearchNetflix]()
        self.movies = lookUpNetflix.searchDataBases(searchkeyword: searchText)
        self.tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    // returns the number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         print("There are \(self.movies.count) movies found at the netflix database")
        return self.movies.count
    }
    
    //TODO: CREATE SEQUE TO THE DETAIL VC
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("You selected cell #\(indexPath.row)!")
        
        let indexPath = tableView.indexPathForSelectedRow!
        
        _ = tableView.cellForRow(at: indexPath) as! SearchViewCell

//        // Get Cell Label
//        movieTitlePass = currentcell.titelLabel.text
//        print("++++++ SEQUE PERFORMED+++++")
        
        self.performSegue(withIdentifier: "reuseID", sender: self)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchViewCell
        
        if self.movies.isEmpty == false{
            cell.titleLabel?.text = self.movies[indexPath.row].title
            cell.yearLabel?.text = self.movies[indexPath.row].year
            cell.categoryLabel?.text = self.movies[indexPath.row].category
            cell.netflixRate?.text = "Netflix Score: \(self.movies[indexPath.row].netflixRate)"
            
            if let checkedUrl = URL(string: "\(self.movies[indexPath.row].poster)") {
                 cell.downloadImage(url: checkedUrl)
                }
        }
        else{print("No more movies to print")}
        
        return cell
        
    }

}

