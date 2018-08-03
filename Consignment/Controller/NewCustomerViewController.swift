//
//  NewCustomerViewController.swift
//  Consignment
//
//  Created by Chanwit Chummung on 3/8/2561 BE.
//  Copyright © 2561 Chanwit Chummung. All rights reserved.
//

import UIKit
import Firebase

class NewCustomerViewController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var swtStatus: UISwitch!
    
    @IBAction func btnAddCustomer(_ sender: Any) {
        AddCustomer()
    }
    
    func AddCustomer(){
        let customerDB = Database.database().reference().child("customers")
        
        let customer = ["customerName": txtName.text! as String,
                        "customerAddress": txtAddress.text! as String,
                        "customerPhone": txtPhone.text! as String,
                        "customerStatus": swtStatus.isOn as Bool,
                        "customerImageUrl": "" as String] as [String : Any]
        
        customerDB.childByAutoId().setValue(customer){
            (error, refference) in
            
            if error != nil {
                print(error!)
            }else{
                print("Customer saved successfully!")
                self.txtName.text = ""
                self.txtAddress.text = ""
                self.txtPhone.text = ""
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
