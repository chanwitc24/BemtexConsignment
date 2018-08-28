//
//  NewProductViewController.swift
//  Consignment
//
//  Created by Chanwit Chummung on 6/8/2561 BE.
//  Copyright © 2561 Chanwit Chummung. All rights reserved.
//

import UIKit
import Firebase

class NewProductViewController: UIViewController {

    @IBOutlet weak var txtProductKey: UITextField!
    @IBOutlet weak var txtProductName: UITextField!
    @IBOutlet weak var txtProductPrice: UITextField!
    @IBOutlet weak var txtProductDescription: UITextField!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var txtImageUrl: UITextView!
    
    @IBOutlet weak var swtStatus: UISwitch!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBAction func AddProduct(_ sender: Any) {
        AddProduct()
    }
    
    func AddProduct() {
        let productDB = Database.database().reference().child("products")
        
        let product = ["productKey": txtProductKey.text! as String,
                       "productName": txtProductName.text! as String,
                       "productPrice": NSString(string: txtProductPrice.text!).doubleValue as Double,
                       "productDescription": txtProductDescription.text! as String,
                       "productStatus": swtStatus.isOn as Bool,
                       "productImageUrl": "" as String] as [String : Any]
        
        productDB.childByAutoId().setValue(product){
            (error, refference) in
            
            if error != nil {
                print(error!)
            }else{
                self.lblMsg.text = "Product saved successfully!"
                self.txtProductKey.text = ""
                self.txtProductName.text = ""
                self.txtProductPrice.text = ""
                self.txtProductDescription.text = ""
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
