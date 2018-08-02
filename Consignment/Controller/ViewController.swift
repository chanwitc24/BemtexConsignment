//
//  ViewController.swift
//  Consignment
//
//  Created by Chanwit Chummung on 11/29/2560 BE.
//  Copyright © 2560 Chanwit Chummung. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblMsg: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginPressed(_ sender: AnyObject) {
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!) {(user, error) in
            if error != nil {
                print(error!)
                self.lblMsg.text = error.debugDescription.description
                SVProgressHUD.dismiss()
            }else{
                print("Log in successful")
                self.lblMsg.text = ""
                SVProgressHUD.dismiss()
                
                self.performSegue(withIdentifier: "goToMain", sender: self)
                
            }
        }
    }
    

}

