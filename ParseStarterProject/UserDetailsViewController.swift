//
//  UserDetailsViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Siddharth Dhar on 4/7/20.
//  Copyright © 2020 Parse. All rights reserved.
//

import UIKit
import Parse

class UserDetailsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    @IBOutlet var userImage: UIImageView!
    
    @IBAction func updateProfileImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
       
        if let image = info[UIImagePickerControllerOriginalImage] as! UIImage? {
            userImage.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBOutlet var occupationSwitch: UISwitch!
    @IBOutlet var likeToSwitch: UISwitch!
    @IBOutlet var errorLabel: UILabel!
    
    @IBAction func update(_ sender: Any) {
        PFUser.current()?["isTutor"] = occupationSwitch.isOn
        PFUser.current()?["isTeaching"] = likeToSwitch.isOn
        let imageData = UIImagePNGRepresentation(userImage.image!)

        PFUser.current()?["photo"] = PFFile(name: "profile.png", data: imageData!)
        
        PFUser.current()?.saveInBackground(block: { (success, error) in
            
            
            if error != nil {
                
                var errorMessage = "Update failed - please try again"
                
                let error = error as NSError?
                
                if let parseError = error?.userInfo["error"] as? String {
                    
                    errorMessage = parseError
                    
                }
                
                self.errorLabel.text = errorMessage
                
            } else {
                
                print("Updated")
                
            }
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let isTutor = PFUser.current()?["isTutor"] as? Bool {
            occupationSwitch.setOn(isTutor, animated: false)
        }
        
        if let isTeaching = PFUser.current()?["isTeaching"] as? Bool {
            likeToSwitch.setOn(isTeaching, animated: false)
        }
        
        if let photo = PFUser.current()?["photo"] as? PFFile {
            photo.getDataInBackground(block: { (data, error) in
                if let imageData = data {
                    if let downloadedImage = UIImage(data: imageData) {
                        self.userImage.image = downloadedImage
                    }
                }
            })
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
