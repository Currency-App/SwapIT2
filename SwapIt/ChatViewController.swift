//
//  ChatViewController.swift
//  SwapIt
//
//  Created by Yao Yu on 5/5/20.
//  Copyright © 2020 FONZIES_LAB. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

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

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    @IBOutlet weak var messageTextField: UITextField!
        
    @IBOutlet weak var tableView: UITableView!
    var user: User?
    var messages = [Message]()
    var messageDictionary = [String: Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
      
        navigationItem.title = user?.firstName
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
        let user = Auth.auth().currentUser

        if (user != nil) {
            observeUserMessages()
            
        } else {
            print("no user")
        }
    }
    
    
    @IBAction func sendAction(_ sender: Any) {
        var ref: DatabaseReference!
        ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toID = user?.id!
        let fromID = Auth.auth().currentUser?.uid
        let timeStamp = NSDate().timeIntervalSince1970
        let values = ["text": messageTextField.text!, "toID": toID, "fromID": fromID, "timeStamp": timeStamp] as [String : Any]
        //childRef.updateChildValues(values)
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error ?? "")
                return
            }
            
            guard let messageId = childRef.key else { return }
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromID!).child(messageId)
            userMessagesRef.setValue(1)
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toID!).child(messageId)
            recipientUserMessagesRef.setValue(1)
        }
        
        messageTextField.text = ""
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
        let message = messages[indexPath.row]

        cell.messageLabel.text = message.text
        return cell

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
