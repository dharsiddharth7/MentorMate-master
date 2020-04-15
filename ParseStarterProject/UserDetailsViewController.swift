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
                self.performSegue(withIdentifier: "showSwipingViewController", sender: self)
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
        
        let urlArray = ["http://cdn.madamenoire.com/wp-content/uploads/2013/08/penny-proud.jpg", "http://static.makers.com/styles/mobile_gallery/s3/betty-boop-cartoon-576km071213_0.jpg?itok=9qNg6GUd", "http://file1.answcdn.com/answ-cld/image/upload/f_jpg,w_672,c_fill,g_faces:center,q_70/v1/tk/view/cew/e8eccfc7/e367e6b52c18acd08104627205bbaa4ae16ee2fd.jpeg", "http://www.polyvore.com/cgi/img-thing?.out=jpg&size=l&tid=1760886", "http://vignette3.wikia.nocookie.net/simpsons/images/0/0b/Marge_Simpson.png/revision/20140826010629", "http://static6.comicvine.com/uploads/square_small/0/2617/103863-63963-torongo-leela.JPG", "https://itfinspiringwomen.files.wordpress.com/2014/03/scooby-doo-tv-09.jpg", "https://s-media-cache-ak0.pinimg.com/236x/9c/5e/86/9c5e86be6bf91c9dea7bac0ab473baa4.jpg"]
        
        var counter = 0
        
        for urlString in urlArray {
            counter += 1
            let url = URL(string: urlString)!
            do {
            let data = try Data(contentsOf: url)
                let imageFile = PFFile(name: "photo.png", data: data)
                let user = PFUser()
                
                user["photo"] = imageFile
                user.username = String(counter)
                user.password = "password"
                user["isTeaching"] = false
                user["isTutor"] = true
                
                let acl = PFACL()
                acl.getPublicWriteAccess = true
                user.acl = acl
                
                user.signUpInBackground(block: { (success, error) in
                    if success {
                        print("user signed up")
                    }
                })
                
            } catch {
                print("Could not get data")
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
