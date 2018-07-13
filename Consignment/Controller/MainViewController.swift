//
//  MainViewController.swift
//  Consignment
//
//  Created by Chanwit Chummung on 11/29/2560 BE.
//  Copyright © 2560 Chanwit Chummung. All rights reserved.
//

import Foundation
import Firebase
import SVProgressHUD

class MainViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func logOutPressed(_ sender: Any)
    {
        do{
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
        }
        catch{
            print("error: there was a problem logging out")
        }
    }
    
}
