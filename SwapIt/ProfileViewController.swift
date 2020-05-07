//
//  ProfileViewController.swift
//  SwapIt
//
//  Created by Nanar Boursalian on 5/1/20.
//  Copyright © 2020 FONZIES_LAB. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var desiredLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        
        // Do any additional setup after loading the view.
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
