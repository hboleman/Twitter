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
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadTweets();
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
    
    
    
    func loadTweets(){
        
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json";
        let myParams = ["count": 10];
        
        
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
        return cell
    }
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
