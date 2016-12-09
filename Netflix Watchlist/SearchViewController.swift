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
    var movies = [MovieDetails]()
    
    // indicatie if a search is active
    var searchActive : Bool = false
    
    // movietitle in current cell which is clicked on will be stored here so it can send the title with the seque performed
    var movieTitlePass: [String: String]!

    
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
  
        DispatchQueue.main.async() { () -> Void in
            self.movies = self.lookUpNetflix.searchDataBases(searchkeyword: searchText)
        }
        
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
        
        let currentcell = tableView.cellForRow(at: indexPath) as! SearchViewCell

        // Get Cell Label
        movieTitlePass = [currentcell.titleLabel.text!: currentcell.netflixRate.text!]
        
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
        
        if self.movies.isEmpty == false{
            cell.titleLabel?.text = self.movies[indexPath.row].title
            cell.yearLabel?.text = self.movies[indexPath.row].year
            cell.categoryLabel?.text = self.movies[indexPath.row].category
            cell.netflixRate?.text = "Netflix Score: \(self.movies[indexPath.row].netflixRate)"
            
            if let url = URL(string: "\(self.movies[indexPath.row].poster)") {
                print("Download Started")
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
                    guard let data = data, error == nil else { return }
                    print(response?.suggestedFilename ?? url.lastPathComponent)
                    print("Download Finished")
                    DispatchQueue.main.async() { () -> Void in
                        cell.imageView?.image = UIImage(data: data)
                    }
                }).resume()
            }
        }
        else{print("No more movies to print")}
        
        return cell
        
    }

}

