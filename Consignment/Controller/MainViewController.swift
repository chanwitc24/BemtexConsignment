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

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewConsignment: UITableView!
    
    var customerList = [Customer]()
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainTableViewCell
        
        let customer: Customer
        
        customer = customerList[indexPath.row]
        
        cell.customerName.text = customer.name
        cell.customerAddress.text = customer.address
        cell.customerPhone.text = customer.phone
        
        
        return cell
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
                    
                    let customer = Customer(id:  customerId as! String?, name: customerName as! String?, address: customerAddress as! String?,phone: customerPhone as! String?,status: customerStatus as? Bool)
                    
                    self.customerList.append(customer)
                }
                
                self.tableViewConsignment.reloadData()
                
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         getAllCustomers()
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
