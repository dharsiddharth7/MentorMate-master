/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {

    var signupMode = true
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signupOrLoginButton: UIButton!
    @IBOutlet weak var changeSignupModeButton: UIButton!
    @IBOutlet weak var accountQuestionLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            performSegue(withIdentifier: "showSwipingViewController", sender: self)
            performSegue(withIdentifier: "goToUserInfo", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }
    
    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: view)
        
        let label = gestureRecognizer.view!
        
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        
        let scale = min(abs(100 / xFromCenter), 1)
        
        var stretchAndRotation = rotation.scaledBy(x: scale, y: scale) // rotation.scaleBy(x: scale, y: scale) is now rotation.scaledBy(x: scale, y: scale)
        
        label.transform = stretchAndRotation
        
        
        if gestureRecognizer.state == UIGestureRecognizer.State.ended {
            
            if label.center.x < 100 {
                
                print("Not chosen")
                
            } else if label.center.x > self.view.bounds.width - 100 {
                
                print("Chosen")
                
            }
            
            rotation = CGAffineTransform(rotationAngle: 0)
            
            stretchAndRotation = rotation.scaledBy(x: 1, y: 1) // rotation.scaleBy(x: scale, y: scale) is now rotation.scaledBy(x: scale, y: scale)

            
            label.transform = stretchAndRotation
            
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupOrLogin(_ sender: Any) {
        if (usernameField.text == "") {
            let alert = UIAlertController.init(title: "", message: "Enter a Username!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated:true)
        }
        else if (passwordField.text == "") {
            let alert = UIAlertController.init(title: "", message: "Enter a Password!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated:true)
        }
        else {
            if signupMode {
            let user = PFUser()
                user.username = usernameField.text
                user.password = passwordField.text
                let acl = PFACL()
                acl.getPublicWriteAccess = true
                user.acl = acl
            
                user.signUpInBackground { (success, error) in
                    if error != nil {
                        var errorMessage = "Signup Failed! Please try again."
                        let error = error as NSError?
                        if let parseError = error?.userInfo["error"] as? String {
                            errorMessage = parseError
                        }
                        let alert = UIAlertController.init(title:"", message: errorMessage, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                    else {
                        print("Signed up!")
                        self.performSegue(withIdentifier: "goToUserInfo", sender: nil)
                    }
                }
            }
            else {
                PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!, block: { (user, error) in
                    if error != nil {
                        var errorMessage = "Login Failed! Please try again."
                        let error = error as NSError?
                        if let parseError = error?.userInfo["error"] as? String {
                            errorMessage = parseError
                        }
                        let alert = UIAlertController.init(title:"", message: errorMessage, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                    else {
                        print("Logged in!")
                        self.performSegue(withIdentifier: "goToUserInfo", sender: nil)
                    }
                })
            }
        }
    }
    
    @IBAction func changeSignupMode(_ sender: Any) {
        
        if signupMode {
            signupMode = false
            signupOrLoginButton.setTitle("Log In", for: []) //for:[] means for the default control state
            changeSignupModeButton.setTitle("Sign Up", for: [])
            accountQuestionLabel.text = "Don't Have an Account?"
            signupOrLogin(sender)
        }
        else {
            signupMode = true
            signupOrLoginButton.setTitle("Sign Up", for: [])
            changeSignupModeButton.setTitle("Log In", for: [])
            accountQuestionLabel.text = "Already Have an Account?"
            signupOrLogin(sender)
        }
    }
}

