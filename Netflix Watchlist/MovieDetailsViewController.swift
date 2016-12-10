//
//  MovieDetailsViewController.swift
//  Netflix Watchlist
//
//  Created by Vasco Meerman on 07/12/2016.
//  Copyright © 2016 Vasco Meerman. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var addToWLButton: UIButton!
    
    @IBOutlet weak var moviePosterView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var releasedLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    
    @IBOutlet weak var netflixRateLabel: UILabel!
    @IBOutlet weak var imdbRateLabel: UILabel!
    
    
    var titleAndRate: [String: String]!
    
    var movieToWL: [String: String]!
    
    var movieDetails = DownloadDetails()
    
    var movie = MovieDetails()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = titleAndRate["title"]!
        let rate = titleAndRate["nfRate"]!
    
        if (titleAndRate["hideWLButton"] == "yes" ){
            addToWLButton.isHidden = true
        }
        else {
            addToWLButton.isHidden = false
        }
        
        movie = movieDetails.titleDownload(titleDetail: title, NFRate: rate)
        
        DispatchQueue.main.async() { () -> Void in
            self.titleLabel.text = self.movie.title
            self.yearLabel.text = self.movie.year
            self.typeLabel.text = "Type: \(self.movie.type)"
            self.releasedLabel.text = self.movie.released
            self.genreLabel.text = self.movie.genre
            self.runtimeLabel.text = self.movie.runtime
            self.actorsLabel.text = self.movie.actors
            self.netflixRateLabel.text = self.movie.netflixRate
            self.imdbRateLabel.text = "IMDB Rating: \(self.movie.imdbRate)"
           
            if let url = URL(string: "\(self.movie.poster)"){
                self.moviePosterView.contentMode = .scaleAspectFit
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
                    guard let data = data, error == nil else { return }
                    print(response?.suggestedFilename ?? url.lastPathComponent)
                    DispatchQueue.main.async() { () -> Void in
                        self.moviePosterView.image = UIImage(data: data)
                    }
                }).resume()

            }
        }
        
        
        print("End of code. The image will continue downloading in the background and it will be loaded when it ends.")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addToWLTapped(_ sender: Any) {
        // Get Cell Label
//        movieTitlePass = [currentcell.titleLabel.text!: currentcell.netflixRate.text!]
        self.performSegue(withIdentifier: "addTap", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "addTap") {
            // initialize new view controller and cast it as your view controller
            let WatchListVC = segue.destination as! WatchListViewController
            // your new view controller should have property that will store passed value
           
            movieToWL = [ "title":self.movie.title,
                              "type":self.movie.type,
                              "year":self.movie.year,
                              "runtime":self.movie.runtime,
                              "netflixRate":self.movie.netflixRate,
                              "poster":self.movie.poster
            ]
            
            WatchListVC.movieAdd = movieToWL
            
        }else { print("no segue is performed")}
        
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
