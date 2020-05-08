//
//  HomeViewController.swift
//  SwapIt
//
//  Created by Yao Yu on 4/30/20.
//  Copyright © 2020 FONZIES_LAB. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currency:[String] = []
    var values: [Double] = []
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var amountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        
        let url = URL(string: "http://data.fixer.io/api/latest?access_key=950d9516c67b78c187ebee7055841efc")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession.init(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main
        )
        let task = session.dataTask(with: request) { (data, response, error) in
            
        if error != nil {
                print("error")
            }
            else {
                if let content = data {
                    do {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        print(myJson)
                        if let rates = myJson["rates"] as? NSDictionary {
                            for (key, value) in rates {
                                self.currency.append((key as? String)!)
                                self.values.append((value as? Double)!)
                            }
                            print(self.currency)
                            print(self.values)
                        }
                    }
                    catch {
                        
                    }
                }
                self.tableview.reloadData()
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currency.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currencies = currency[indexPath.row]
        let value = values[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell") as! CurrencyCell
        cell.currencyLabel.text = currencies
        cell.valuesLabel.text = String(value)
        return cell
    }
    
    @IBAction func postAction(_ sender: Any) {
        let currentID = Auth.auth().currentUser?.uid
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userReferences = ref.child("users").child(currentID!)
        let amount = amountTextField.text!
        let value = ["currency": amount]
        userReferences.updateChildValues(value) { (error, ref) in
                if error != nil {
                                 print("error saving data")
                }
        }
        
        amountTextField.text = ""
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
