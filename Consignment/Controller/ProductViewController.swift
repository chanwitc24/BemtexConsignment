//
//  ProductViewController.swift
//  Consignment
//
//  Created by Chanwit Chummung on 12/7/2561 BE.
//  Copyright © 2561 Chanwit Chummung. All rights reserved.
//

import UIKit
import Photos
import Firebase


class ProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewProduct: UITableView!
    
    let storage = Storage.storage()
    
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
                    let productImageUrl = productObject?["productImageUrl"]
                    
                    let product = Product(id:  productId as! String?, name: productName as! String?,key: productKey as! String?,price: productPrice as? Double, description: productDescription as! String?,status: productStatus as? Bool,imageUrl: productImageUrl as! String?)
                    
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
