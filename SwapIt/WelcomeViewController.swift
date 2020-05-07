//
//  WelcomeViewController.swift
//  SwapIt
//
//  Created by Grace Leung on 5/2/20.
//  Copyright © 2020 FONZIES_LAB. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func GoToHome(_ sender: Any) {
        self.performSegue(withIdentifier: "homeSegue", sender: nil)
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
