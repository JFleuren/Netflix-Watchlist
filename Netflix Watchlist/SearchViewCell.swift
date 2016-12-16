//
//  SearchViewCell.swift
//  Netflix Watchlist
//
//  Created by Vasco Meerman on 07/12/2016.
//  Copyright © 2016 Vasco Meerman. All rights reserved.
//

import UIKit

class SearchViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var netflixRate: UILabel!
    
    var titles = [String]()
    var posters = [String]()
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func searchNetflix(movieTitle: String, moviePoster: String) {

        var pickedTitle = movieTitle
        pickedTitle = pickedTitle.replacingOccurrences(of: " ", with: "%20")
        
        let link = URL(string: "https://netflixroulette.net/api/api.php?title=\(pickedTitle)")
        
        URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) -> Void in
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode == 200) {
                    
                    if data != nil {
                        
                        do {
                            let dictionary = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]

                            print(dictionary)
                            
                             DispatchQueue.main.async() { () -> Void in
                                self.titleLabel.text = dictionary["show_title"] as? String
                                print("!!!\(self.titleLabel.text)!!!!!********")
                                self.yearLabel.text = dictionary["release_year"] as? String
                                self.categoryLabel.text = dictionary["category"] as? String
                                self.netflixRate.text = "Netflix Score: \(dictionary["rating"] as! String)"
                                self.getPoster(url: moviePoster)
                                self.setNeedsLayout() //invalidate current layout
                                self.layoutIfNeeded() //update immediately
                            }
                        } catch {
                            print("Failed to convert to JSON")
                        }
                    }
                }
                
            }
        }).resume()
    }
    
    func getPoster(url: String) {
        
        print(url)
        
        URLSession.shared.dataTask(with: NSURL(string: url) as! URL, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async {
                self.posterImageView.image = UIImage(data: data)
            }
            
        }).resume()
        
    }
    
}
