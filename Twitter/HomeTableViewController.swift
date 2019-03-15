//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Hunter Boleman on 3/7/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    // An Array of Dictionaries
    var tweetArray = [NSDictionary]();
    var numberOfTweets: Int!
    let myRefreshControl = UIRefreshControl();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets();
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged);
        tableView.refreshControl = myRefreshControl;
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 150;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets();
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count;
    }
    
    @objc func loadTweets(){
        // sets number of tweets
        numberOfTweets = 20;
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json";
        let myParams = ["count": numberOfTweets];
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            // Empties array
            self.tweetArray.removeAll();
            // For loop, creates variable tweet to refer to one element inside of tweets, refer to api caller above
            for tweet in tweets {
                // This is appending the element of tweet to the tweetArray
                self.tweetArray.append(tweet);
            }
            // Reloads data
            self.tableView.reloadData();
            
            // Stops refresh spinner
            self.myRefreshControl.endRefreshing();
            
        }, failure: { (Error) in
            print("ERROR: Tweet array could not be retrieved!");
        })
    }
    
    func loadMoreTweets(){
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json";
        let myParams = ["count": numberOfTweets];
        numberOfTweets = numberOfTweets + 20;
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            // Empties array
            self.tweetArray.removeAll();
            // For loop, creates variable tweet to refer to one element inside of tweets, refer to api caller above
            for tweet in tweets {
                // This is appending the element of tweet to the tweetArray
                self.tweetArray.append(tweet);
            }
            // Reloads data
            self.tableView.reloadData();
            
        }, failure: { (Error) in
            print("ERROR: Tweet array could not be retrieved!");
        })
        
    }
    
    // Will call loadMoreTweets when the user scrolls to the bottom of the UITableView
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if (indexPath.row + 1 == tweetArray.count){
            loadMoreTweets();
        }
    }
    
    // Nav Bar Logout Button
    @IBAction func onLogOut(_ sender: Any) {
        // Calls the logout twitter api function.
        TwitterAPICaller.client?.logout();
        // Moves back a screen in the navigation controller stack.
        self.dismiss(animated: true, completion: nil)
        // Sets the logged in flag to false.
        UserDefaults.standard.set(false, forKey: "userLoggedIn");
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell;
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        // Set Username
        cell.userNameLable.text = user["name"] as? String;
        // The index path gets the element number, and the ["text"] is the id within the element, in this case is tweet.
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String;
        
        // Logic for profile image
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!);
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data{
            cell.profileImageView.image = UIImage(data: imageData);
        }
        
        //Set Fav Icon
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool);
        //Set tweetId
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int;
        
        return cell
    }
}
