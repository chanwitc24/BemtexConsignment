//
//  LoginViewController.swift
//  Consignment
//
//  Created by Chanwit Chummung on 11/29/2560 BE.
//  Copyright © 2560 Chanwit Chummung. All rights reserved.
//

import Foundation
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var MessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginPressed(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) {(user, error) in
            if error != nil {
                print(error!)
                self.MessageLabel.text = error.debugDescription.description
                SVProgressHUD.dismiss()
            }else{
                print("Log in successful")
                self.MessageLabel.text = ""
                SVProgressHUD.dismiss()
                
                self.performSegue(withIdentifier: "goToMain", sender: self)
                
            }
        }
    }
    
    
}
