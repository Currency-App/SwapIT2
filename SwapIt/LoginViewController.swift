//
//  LoginViewController.swift
//  SwapIt
//
//  Created by Yao Yu on 4/30/20.
//  Copyright © 2020 FONZIES_LAB. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var messageContoller = MessagesViewController()
    
    @IBAction func login(_ sender: Any) {
        let Email = email.text!
        let Password = password.text!
        Auth.auth().signIn(withEmail: Email, password: Password) { (user, error) in
           if error == nil{
             self.performSegue(withIdentifier: "loginSuccess", sender: self)
           }
            else{
             let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
             let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            
              alertController.addAction(defaultAction)
              self.present(alertController, animated: true, completion: nil)
                 }
        }
                
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
