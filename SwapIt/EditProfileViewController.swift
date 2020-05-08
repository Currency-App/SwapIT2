//
//  EditProfileViewController.swift
//  SwapIt
//
//  Created by Grace Leung on 5/3/20.
//  Copyright © 2020 FONZIES_LAB. All rights reserved.
//

import UIKit
import AlamofireImage
import FirebaseFirestore
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import FirebaseUI


class EditProfileViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var currentText: UITextField!
    @IBOutlet weak var desiredText: UITextField!
    var selectedCurrency: String?
    var currencyType = ["USD", "EUR", "HRK", "HUF", "SGD", "HKD", "JPY", "TWD"]
    
    var iURL: String?
    var imageName: String?
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerViewCurrent()
        createPickerViewDesired()
        dismissPickerView()
        
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
            let value = snapshot.value as? NSDictionary
            self.currentText.text = value?["currentCurrency"] as? String
            self.desiredText.text = value?["desiredCurrency"] as? String
            self.nameText.text = value?["profilename"] as? String
            let i = value?["imageName"] as? String
            if i != nil {
                let storageRef = Storage.storage().reference().child(i!)
                self.profileImage.sd_setImage(with: storageRef)
            }
        })}

        // Do any additional setup after loading the view.
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return currencyType[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedCurrency = currencyType[row]
        currentText.text = selectedCurrency
        desiredText.text = selectedCurrency
        
    }
    func createPickerViewCurrent()
    {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        
        currentText.inputView = pickerView
    }
    func dismissPickerView()
    {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        currentText.inputAccessoryView = toolBar
        desiredText.inputAccessoryView = toolBar
    }
    
    func createPickerViewDesired()
    {
        let pickerView = UIPickerView()
        pickerView.delegate = self
               
        desiredText.inputView = pickerView
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    
    @IBAction func changePhoto(_ sender: Any) {
        let picker  = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            picker.sourceType = .camera
        }
        else {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 250, height: 250)
        let scaledImage = image.af_imageAspectScaled(toFill: size )
        
        profileImage.image = scaledImage
        
        dismiss(animated: true, completion: nil)
        
        var data = Data()
        data = profileImage.image!.jpegData(compressionQuality: 0.8)!
        self.imageName = "images" + randomString(length: 20)
        let imageRef = Storage.storage().reference().child(self.imageName!)
        let uploadTask = imageRef.putData(data, metadata: nil) {(metadata, error) in
            guard let metadata = metadata else {return}
            imageRef.downloadURL{ (url, error) in
                guard let downloadURL = url else {return}
                self.iURL = downloadURL.absoluteString ?? ""
                print(self.iURL)
            }
        }}
    
    
    
    
    @IBAction func saveProfile(_ sender: Any) {
       
        let currentID = Auth.auth().currentUser?.uid
        
        ref = Database.database().reference()
        let userReferences = ref.child("users").child(currentID!)
        
        let profilename = nameText.text
        let desiredC = desiredText.text
        let currentC = currentText.text
        let profileImage = iURL
        
        
        let value = ["profilename": profilename,
        "desiredCurrency": desiredC,
        "currentCurrency": currentC,
        "profileImage": profileImage,
        "imageName": self.imageName]
        
        userReferences.updateChildValues(value) { (error, ref) in
                if error != nil {
                    print("error data saved")
                }
                else
                {
                     self.navigationController?.popViewController(animated: true)
            }
        }
        
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
