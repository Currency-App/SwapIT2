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

class ChatViewController: UIViewController {

    @IBOutlet weak var messageTextField: UITextField!
        
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        //nameLabel.text = user?.firstName
        navigationItem.title = user?.firstName
        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
