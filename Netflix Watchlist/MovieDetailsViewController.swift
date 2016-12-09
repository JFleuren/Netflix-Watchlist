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
    @IBOutlet weak var castLabel: UILabel!
    
    
    var titleAndRate: [String: String]!
    
    var movieDetails = DownloadDetails()
    
    var movie = MovieDetails()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        print (titleAndRate)
        for (titleC, rate) in titleAndRate {
            let title = titleC
            movie = movieDetails.titleDownload(titleDetail: title, NFRate: rate)
        }
        
        DispatchQueue.main.async() { () -> Void in
            self.titleLabel.text = self.movie.title
            self.yearLabel.text = self.movie.year
            self.typeLabel.text = self.movie.type
        }
        
        if let checkedUrl = URL(string: "\(movie.poster)") {
            self.moviePosterView.contentMode = .scaleAspectFit
            self.downloadImage(url: checkedUrl)}
        print("End of code. The image will continue downloading in the background and it will be loaded when it ends.")
    }
    
//
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
           
//            WatchListVC.titleAndRate = movieTitlePass
            
        }else { print("no segue is performed")}
        
    }
    
    func downloadImage(url: URL) {
        print (url)
        print("Download Started")
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                self.moviePosterView.image = UIImage(data: data)
            }
        }).resume()
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
