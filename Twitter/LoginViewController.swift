//
//  LoginViewController.swift
//  Twitter
//
//  Created by Hunter Boleman on 3/7/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    // When screen appears, do logic
    override func viewDidAppear(_ animated: Bool) {
        // Looks for logged in flag. If true, go to twitter screem.
        if (UserDefaults.standard.bool(forKey: "userLoggedIn") == true){
            // Seques to the twitter screen
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
    
    // Logon button logic
    @IBAction func onLoginButton(_ sender: Any) {
        // API URL
        let myURL = "https://api.twitter.com/oauth/request_token";
        // Acesses the twitter api caller function
        TwitterAPICaller.client?.login(url: myURL, success: {
            // Sets the logged in flag as true
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            // Segues to the twitter screen
            self.performSegue(withIdentifier: "loginToHome", sender: self)
            
        }, failure: { (Error) in
            print("ERROR: login failed")
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
