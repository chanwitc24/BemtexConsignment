//
//  ProductViewController.swift
//  Consignment
//
//  Created by Chanwit Chummung on 12/7/2561 BE.
//  Copyright © 2561 Chanwit Chummung. All rights reserved.
//

import UIKit
import Firebase

class ProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var txtProductKey: UITextField!
    @IBOutlet weak var txtProductName: UITextField!
    @IBOutlet weak var txtProductDescription: UITextField!
    @IBOutlet weak var switchStatus: UISwitch!
    @IBOutlet weak var txtProductPrice: UITextField!
    
    @IBOutlet weak var tableViewProduct: UITableView!
    
    var productList = [Product]()
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductTableViewCell
        
        let product: Product
        
        product = productList[indexPath.row]
        
        cell.lblProductKey.text = product.key
        cell.lblProductName.text = product.name
        cell.lblProductDescription.text = product.description
        cell.lblProductPrice.text = String(product.price!)
        
        return cell
        
    }
    
    @IBAction func btnAddProduct(_ sender: UIButton) {
        AddProduct()
    }
    
    func AddProduct() {
        let productDB = Database.database().reference().child("products")
        
        let product = ["productKey": txtProductKey.text! as String,
                       "productName": txtProductName.text! as String,
                       "productPrice": NSString(string: txtProductPrice.text!).doubleValue as Double,
                       "productDescription": txtProductDescription.text! as String,
                       "productStatus": switchStatus.isOn as Bool] as [String : Any]
        
        productDB.childByAutoId().setValue(product){
            (error, refference) in
            
            if error != nil {
                print(error!)
            }else{
                print("Product saved successfully!")
                self.txtProductKey.text = ""
                self.txtProductName.text = ""
                self.txtProductPrice.text = ""
                self.txtProductDescription.text = ""
            }
            
        }
        
    }
    
    func getAllProducts() {
        
        let productDB = Database.database().reference().child("products")
        
        productDB.observe(.value,with: { (snapshot) in
            
            if snapshot.childrenCount > 0 {
                
                self.productList.removeAll()
                
                for products in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let productObject = products.value as? [String: AnyObject]
                    let productId = productObject?["id"]
                    let productKey = productObject?["productKey"]
                    let productName = productObject?["productName"]
                    let productPrice = productObject?["productPrice"]
                    let productDescription = productObject?["productDescription"]
                    let productStatus = productObject?["productStatus"]
                    
                    let product = Product(id:  productId as! String?, name: productName as! String?,key: productKey as! String?,price: productPrice as? Double, description: productDescription as! String?,status: productStatus as? Bool)
                    
                    self.productList.append(product)
                }
                
                self.tableViewProduct.reloadData()
                
            }
            
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getAllProducts()
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
