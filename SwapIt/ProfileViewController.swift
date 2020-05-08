//
//  ProfileViewController.swift
//  SwapIt
//
//  Created by Nanar Boursalian on 5/1/20.
//  Copyright © 2020 FONZIES_LAB. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var desiredLabel: UILabel!
    var ref: DatabaseReference!
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
            let value = snapshot.value as? NSDictionary
            
            DispatchQueue.main.async {
                self.currentLabel.text = value?["currentCurrency"] as? String
                self.desiredLabel.text = value?["desiredCurrency"] as? String
                self.usernameLabel.text = value?["profilename"] as? String
                
                let i = value?["imageName"] as? String
                if i != nil {
                    let storageRef = Storage.storage().reference().child(i!)
                    self.profileImage.sd_setImage(with: storageRef)
                }
                
            }
          }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func editButton(_ sender: Any) {
        self.performSegue(withIdentifier: "editSegue", sender: nil)
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
