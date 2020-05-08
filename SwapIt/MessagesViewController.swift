//
//  MessagesViewController.swift
//  SwapIt
//
//  Created by Yao Yu on 5/4/20.
//  Copyright © 2020 FONZIES_LAB. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var messages = [Message]()
    var messageDictionary = [String: Message]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
        
        let user = Auth.auth().currentUser

        if (user != nil) {
            observeUserMessages()
            //observeMessages()
            
        } else {
            print("no user")
        }
    }
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        var ref: DatabaseReference!
        ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let messageID = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageID)
            
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                     let message = Message()
                     message.fromID = dictionary["fromID"] as? String
                     message.toID = dictionary["toID"] as? String
                     message.text = dictionary["text"] as? String
                     message.timeStamp = dictionary["timeStamp"] as? NSNumber
                     if let toID = message.toID {
                         self.messageDictionary[toID] = message
                         self.messages = Array(self.messageDictionary.values)
                         self.messages.sort { (m1, m2) -> Bool in
                             return m1.timeStamp?.intValue > m2.timeStamp?.intValue
                         }
                     }
                     DispatchQueue.main.async {
                            self.tableView.reloadData()
                     }
                 }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    func observeMessages() {
        var ref: DatabaseReference!
        ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message()
                message.fromID = dictionary["fromID"] as? String
                message.toID = dictionary["toID"] as? String
                message.text = dictionary["text"] as? String
                message.timeStamp = dictionary["timeStamp"] as? NSNumber
                if let toID = message.toID {
                    self.messageDictionary[toID] = message
                    self.messages = Array(self.messageDictionary.values)
                    self.messages.sort { (m1, m2) -> Bool in
                        return m1.timeStamp?.intValue > m2.timeStamp?.intValue
                    }
                }
                DispatchQueue.main.async {
                       self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
        let message = messages[indexPath.row]
        let chatPartnerID: String?
        if message.fromID == Auth.auth().currentUser?.uid {
            chatPartnerID = message.toID
        }
        else {
            chatPartnerID = message.fromID
        }
        if let ID = chatPartnerID {
            var ref: DatabaseReference!
            ref = Database.database().reference().child("users").child(ID)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    cell.nameLabel.text = dictionary["firstName"] as? String
                    cell.lastNameLabel.text = dictionary["lastName"] as? String
                }
            }, withCancel: nil)
        }
        
        if let seconds = message.timeStamp?.doubleValue {
            let timeStampDate = NSDate(timeIntervalSince1970: seconds)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss a"
            cell.timeLabel.text = dateFormatter.string(from: timeStampDate as Date)
        }
        cell.messageLabel.text = message.text
       
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        let chatPartnerID: String?
        if message.fromID == Auth.auth().currentUser?.uid {
            chatPartnerID = message.toID
        }
        else {
            chatPartnerID = message.fromID
            var ref: DatabaseReference!
               ref = Database.database().reference().child("users").child(chatPartnerID!)
               ref.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                let user = User()
                user.id = chatPartnerID
                user.firstName = dictionary["firstName"] as? String
                user.lastName = dictionary["lastName"] as? String
                user.email = dictionary["email"] as? String
               }, withCancel: nil)
       }
        
       //self.performSegue(withIdentifier: "chatMessageView", sender: message)


    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "chatMessageView" {
                   let nav = segue.destination as! UINavigationController
                   let svc = nav.topViewController as! ChatViewController
                    svc.user = sender as? User
               }
    }
    
    @IBAction func newMessagesAction(_ sender: Any) {
        self.performSegue(withIdentifier: "newMessage", sender: nil)
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
