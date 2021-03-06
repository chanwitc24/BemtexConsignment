//
//  CustomerViewController.swift
//  Consignment
//
//  Created by Chanwit Chummung on 12/7/2561 BE.
//  Copyright © 2561 Chanwit Chummung. All rights reserved.
//

import UIKit
import Firebase

class CustomerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var customerTableView: UITableView!
    
    var customerList = [Customer]()
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomerTableViewCell
        
        let customer: Customer
        
        customer = customerList[indexPath.row]
        
        cell.lblName.text = customer.name
        cell.lblAddress.text = customer.address
        cell.lblPhone.text = customer.phone
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoCustomerItem", sender: self)
    }
    
    func getAllCustomers(){
        
        let customerDB = Database.database().reference().child("customers")
        
        customerDB.observe(.value,with: { (snapshot) in
            
            if snapshot.childrenCount > 0 {
                
                self.customerList.removeAll()
                
                for customers in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let customerObject = customers.value as? [String: AnyObject]
                    let customerId = customerObject?["id"]
                    let customerName = customerObject?["customerName"]
                    let customerAddress = customerObject?["customerAddress"]
                    let customerPhone = customerObject?["customerPhone"]
                    let customerStatus = customerObject?["customerStatus"]
                    let customerImageUrl = customerObject?["customerImageUrl"]
                    
                    let customer = Customer(id:  customerId as! String?, name: customerName as! String?, address: customerAddress as! String?,phone: customerPhone as! String?,status: customerStatus as? Bool,imageUrl: customerImageUrl as! String?)
                    
                    self.customerList.append(customer)
                }
                
                self.customerTableView.reloadData()
                
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getAllCustomers()
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
