//
//  WatchListViewController.swift
//  Netflix Watchlist
//
//  Created by Vasco Meerman on 07/12/2016.
//  Copyright © 2016 Vasco Meerman. All rights reserved.
//

import UIKit
import Firebase

class WatchListViewController: UIViewController {
    
    var movieItems: [FirebaseMovie] = []
    
    var movieAdd: [String: String] = [:]
    
    // movietitle in current cell which is clicked on will be stored here so it can send the title with the seque performed
    var movieTitlePass: [String: String]!
    
    let ref = FIRDatabase.database().reference(withPath: "movie-list")
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    
    // Properties
    
    // This is a Firebase reference that points to an online location that stores a list of online users.
    // So in the database tab on firebase a child is added with the name "online"
    let usersRef = FIRDatabase.database().reference(withPath: "online")
    
    // The user struct being used to keep the user identification
    var user: User!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Retrieve all the movies from the database every time there is a change
        // Is a Listener meaning that everytime something updates like delte, this is called again
        ref.observe(.value, with: { snapshot in
            // 2
            var newMovies: [FirebaseMovie] = []
            
            // 3
            for movie in snapshot.children {
                // 4
                let MovieItem = FirebaseMovie(snapshot: movie as! FIRDataSnapshot)
                print("^^^^^^^^^^^\(MovieItem)^^^^^^^^^^^^^")
                newMovies.append(MovieItem)
            }
            
            // 5
            self.movieItems = newMovies
            self.tableView.reloadData()
        })
        
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            
            print (self.user.email)

            // Checks if user is online, so when the app closes en disconnects with firebase; The user reference is also removed
            // 1
            let currentUserRef = self.usersRef.child(self.user.uid)
            // 2
            currentUserRef.setValue(self.user.email)
            // 3
//            currentUserRef.setValue(nil, forKey: "uid")
            currentUserRef.onDisconnectRemoveValue()
        }
        
        // This is the observer for how many users are online
        usersRef.observe(.value, with: { snapshot in
            if snapshot.exists() {
                print(snapshot.childrenCount.description)
            } else {
                print("Online users: 0")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "searchSegue", sender: self)
    }
    
}

extension WatchListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // returns the number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("There are \(self.movieItems.count) movies found at the netflix WatchList")
        return movieItems.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") {
            (action, index) in
            let movieItem = self.movieItems[indexPath.row]
            movieItem.ref?.removeValue()
            }
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WatchListCellTableViewCell
        
        if self.movieItems.isEmpty == false{
            DispatchQueue.main.async() { () -> Void in
                
                let movie = self.movieItems[indexPath.row]
                
                cell.titleLabel?.text = movie.title
                print("@@@@@@@@@@@@\(movie.title)@@@@@@@@@@")
                cell.yearLabel?.text = movie.year
                cell.typeLabel?.text = movie.type
                cell.runtimeLabel?.text = movie.runtime
                cell.netflixRateLabel?.text = movie.netflixRate
                
                if let url = URL(string: "\(movie.poster)") {
                    cell.imageView!.contentMode = .scaleAspectFit
                    print(url)
                    URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
                        guard let data = data, error == nil else { return }
                        print(response?.suggestedFilename ?? url.lastPathComponent)
                        print("Download Finished")
                        DispatchQueue.main.async() { () -> Void in
                            cell.imageView!.image = UIImage(data: data)
                            cell.setNeedsLayout() //invalidate current layout
                        }
                    }).resume()
                }
            }

        }
        else{print("No more movies to print")}
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        let indexPath = tableView.indexPathForSelectedRow!
        
        let currentcell = tableView.cellForRow(at: indexPath) as! WatchListCellTableViewCell
        
        // Get Cell Label
        movieTitlePass = ["title": currentcell.titleLabel.text!,
                          "nfRate": currentcell.netflixRateLabel.text!,
                          "hideWLButton": "yes"
        ]
        print("++++++ \(movieTitlePass)+++++")
        self.performSegue(withIdentifier: "toMovieDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toMovieDetails"){
            let MovieDetailVC = segue.destination as! MovieDetailsViewController
            MovieDetailVC.titleAndRate = movieTitlePass
        }
        else { print("no segue is performed")}
    }

}
