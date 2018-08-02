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
import Alamofire
import AlamofireImage

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
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
        
        Alamofire.request(customer.imageUrl!).responseImage{ response in
            debugPrint(response)
            
            if let image = response.result.value {
                cell.customerImage.image = image
            }
        }
        
        return cell
    }
    
    func getAllCustomers(searhText : String){
        
//        let customerDB = Database.database().reference().child("customers")
        let db = Database.database().reference()
        let customers = db.child("customers");
        let query = customers
                            .queryOrdered(byChild: "customerName")
                            .queryStarting(atValue: searhText)
//                            .queryEqual(toValue: "อู่ ช่างวุฒิ")
                            .queryLimited(toFirst: 10)
        
        
        
//        customerDB.observe(.value,with: { (snapshot) in
        query.observe(.value,with: { (snapshot) in
        
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
                
                self.tableViewConsignment.reloadData()
                
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllCustomers(searhText: "")
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

//MARK: - Search bar methods

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
//        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        getAllCustomers(searhText: searchBar.text!)
        tableViewConsignment.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
//            loadItems()
            getAllCustomers(searhText: "")
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
            
        }
    }
    
}

