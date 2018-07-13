//
//  RegisterViewController.swift
//  Consignment
//
//  Created by Chanwit Chummung on 11/29/2560 BE.
//  Copyright © 2560 Chanwit Chummung. All rights reserved.
//

import Foundation
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func registerPressed(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            
            if error != nil {
                print(error!)
            }
            else{
                print("Registration successful!")
                
                SVProgressHUD.dismiss()
                
                self.performSegue(withIdentifier: "goToMain", sender: self)
            }
            
        }
        
    }
    
    
}
