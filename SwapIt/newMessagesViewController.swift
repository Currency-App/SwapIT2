//
//  newMessagesViewController.swift
//  SwapIt
//
//  Created by Yao Yu on 5/4/20.
//  Copyright © 2020 FONZIES_LAB. All rights reserved.
//

import UIKit
import FirebaseDatabase

class newMessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var tableView: UITableView!
    var users = [User]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
        fetchUser()
    }
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.id = snapshot.key
                user.firstName = dictionary["firstName"] as? String
                user.lastName = dictionary["lastName"] as? String
                user.email = dictionary["email"] as? String
                self.users.append(user)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    @IBAction func Cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newMessageCell") as! newMessageCell
        let user = users[indexPath.row]
        cell.firstNameLabel.text = user.firstName
        cell.lastNameLabel.text = user.lastName
        cell.emailLabel.text = user.email
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        self.performSegue(withIdentifier: "chatView", sender: user)
            
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatView" {
            let nav = segue.destination as! UINavigationController
            let svc = nav.topViewController as! ChatViewController
            svc.user = sender as? User
        }
    }


}
