//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Hunter Boleman on 3/9/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLable: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    // Global Variavbles
    var favorited:Bool = false;
    var tweetId:Int = -1;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func favoriteTweet(_ sender: Any) {
        let tobeFavorited = !favorited;
        if (tobeFavorited) {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(true);
            }, failure: { (error) in
                print("ERROR: Favorite did fail: \(error)");
            })
        }
        else {
            // When not to be favorited
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(false);
            }, failure: { (error) in
                print("ERROR: Unfavorite did fail: \(error)");
            })
        }
        
    }
    
    @IBAction func retweet(_ sender: Any) {
        
    }
    
    func setFavorite(_ isFavorited:Bool){
        favorited = isFavorited
        if (favorited) {
            favButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal )
        }
        else {
            favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal )
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
