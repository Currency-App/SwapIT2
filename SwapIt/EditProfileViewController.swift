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


class EditProfileViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var currentText: UITextField!
    @IBOutlet weak var desiredText: UITextField!
    var selectedCurrency: String?
    var currencyType = ["USD", "EUR"]
    var docRef: DocumentReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerView()
        dismissPickerView()
        docRef = Firestore.firestore().document("profileInformation/profile")

        // Do any additional setup after loading the view.
    }
    
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
    func createPickerView()
    {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        
        currentText.inputView = pickerView
        desiredText.inputView = pickerView
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 250, height: 250)
        let scaledImage = image.af_imageAspectScaled(toFill: size )
        
        profileImage.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveProfile(_ sender: Any) {
       
        guard let desiredC = desiredText.text, !desiredC.isEmpty else {return}
        guard let currentC = currentText.text, !currentC.isEmpty else {return}
        guard let profilename = nameText.text, !profilename.isEmpty else {return}
        
        let dataToSave: [String: Any] = ["profileName": profilename, "currentCurrency": currentC, "desiredCurrency": desiredC]
        
        docRef.setData(dataToSave, completion: { (error) in
            if let error = error {
                print("There is an error: \(error.localizedDescription)") }
            else {
                print("Data is saved")
                self.navigationController?.popViewController(animated: true)
            }
        })
 
        
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
