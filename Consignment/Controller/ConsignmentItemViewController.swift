//
//  ConsignmentItemViewController.swift
//  Consignment
//
//  Created by Chanwit Chummung on 13/7/2561 BE.
//  Copyright © 2561 Chanwit Chummung. All rights reserved.
//

import UIKit
import Firebase
import iOSDropDown
import NumberField


class ConsignmentItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var txtCustomerId: UITextField!
    
    @IBOutlet weak var txtProductId: UITextField!
    
    @IBOutlet weak var txtQuantity: UITextField!
    
    @IBOutlet weak var txtStatus: UITextField!
    
    @IBOutlet weak var txtRemark: UITextField!
    
    @IBOutlet weak var tableConsignmentItem: UITableView!
    
    @IBOutlet var dropCustom: [DropDown]!
    
    @IBOutlet weak var numberField2: NumberField!
    
    var customerList = [Customer]()
    var customerArray = [String]()
    var customerId = [Int]()
    
    var productList = [Product]()
    var productArray = [String]()
    var productId = [Int]()
    
    var conditionArray = ["วางใหม่","นำกลับ","ขายไปแล้ว"]
    var conditionId = [1,2,3]
    
    var consignmentItemList = [ConsignmentItem]()
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consignmentItemList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConsignmentItemTableViewCell
        
        let consignmentItem: ConsignmentItem
        
        consignmentItem = consignmentItemList[indexPath.row]
        
        cell.lblCustomer.text = consignmentItem.customer
        print(consignmentItem.customer as Any)
        cell.lblProduct.text = consignmentItem.product
        print(consignmentItem.product as Any)
        cell.lblQuantity.text = String(consignmentItem.quantity!)
        print(String(consignmentItem.quantity!))
        cell.lblStatus.text = consignmentItem.status
        print(consignmentItem.status as Any)
        cell.lblRemark.text = consignmentItem.remark
        print(consignmentItem.remark as Any)
        
        return cell
    }
    
    @IBAction func btnAddConsignmentItem(_ sender: UIButton) {
        AddConsignmentItem()
    }
    
    func AddConsignmentItem(){
        let consignmentItemDB = Database.database().reference().child("consignmentItems")
        
        let consignmentItem = ["customerId": txtCustomerId.text! as String,
                               "productId": txtProductId.text! as String,
                               "quantity": Int(numberField2.value) ,
                               "status": txtStatus.text! as String,
                               "remark": txtRemark.text! as String] as [String : Any]
        
        consignmentItemDB.childByAutoId().setValue(consignmentItem){
            (error, refference) in
            
            if error != nil {
                print(error!)
            }else {
                print("ConsignmentItem saved successfully!")
                self.txtCustomerId.text = ""
                self.txtProductId.text = ""
                self.txtQuantity.text = ""
                self.txtStatus.text = ""
                self.txtRemark.text = ""
            }
            
        }
        
    }
    
    func getAllConsignmentItems(){
        let consignmentItemDB = Database.database().reference().child("consignmentItems")
        
        consignmentItemDB.observe(.value, with: { (snapshot) in
        
            if snapshot.childrenCount > 0 {
                
                self.consignmentItemList.removeAll()
                
                for consignmentItems in snapshot.children.allObjects as! [DataSnapshot]{
                    
                    let consignmentItemObject = consignmentItems.value as? [String: AnyObject]
                    let consignmentItemId = consignmentItemObject?["id"]
                    let consignmentItemCustomerId = consignmentItemObject?["customerId"]
                    let consignmentItemProductId = consignmentItemObject?["productId"]
                    let consignmentItemQuantity = consignmentItemObject?["quantity"]
                    let consignmentItemStatus = consignmentItemObject?["status"]
                    let consignmentItemRemark = consignmentItemObject?["remark"]
                    
                    let consignmentItem = ConsignmentItem(id: consignmentItemId as! String?,customer: consignmentItemCustomerId as! String?, product: consignmentItemProductId as! String?, quantity: consignmentItemQuantity as! Int?, status: consignmentItemStatus as! String?, remark: consignmentItemRemark as! String?)
                    
                    self.consignmentItemList.append(consignmentItem)
                    
                }
                
                self.tableConsignmentItem.reloadData()
                
            }
        })
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
                    self.customerArray.append(customer.name!)
                    self.customerId.append(self.customerList.count)
                }
                
                // The list of array to display. Can be changed dynamically
                self.dropCustom[0].optionArray = self.customerArray
                self.dropCustom[0].isSearchEnable = false
                self.dropCustom[0].selectedRowColor = .cyan
                //Its Id Values and its optional
                self.dropCustom[0].optionIds = self.customerId
                // The the Closure returns Selected Index and String
                self.dropCustom[0].didSelect{(selectedText , index ,id) in
                    self.dropCustom[0].isSearchEnable = true
                    self.txtCustomerId.text = selectedText
                }
                
            }
        })
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
                    self.productArray.append("\(product.key!):\(product.name!)")
                    self.productId.append(self.productList.count)

                }
                
                // The list of array to display. Can be changed dynamically
                self.dropCustom[1].optionArray = self.productArray
                self.dropCustom[1].isSearchEnable = false
                self.dropCustom[1].selectedRowColor = .cyan
                //Its Id Values and its optional
                self.dropCustom[1].optionIds = self.productId
                // The the Closure returns Selected Index and String
                self.dropCustom[1].didSelect{(selectedText , index ,id) in
                    self.dropCustom[1].isSearchEnable = true
                    self.txtProductId.text = selectedText
                }
                
            }
            
        })
        
    }
    
    func setupField2() {
        //Customization
        numberField2.value = 0
        numberField2.maxValue = 1000
        numberField2.decimalPlace = 0
        numberField2.valueLabel.font = UIFont.systemFont(ofSize: 20)
        
        //Prefix and Suffix
        numberField2.suffixLabel.text = "pcs"
        numberField2.prefixLabel.text = "QUANTITY"
        numberField2.textAlignment = .left
        numberField2.isPrefixAndSuffixStickToSides = false
        numberField2.prefixLabel.font = UIFont.boldSystemFont(ofSize: 16)
        numberField2.suffixLabel.font = UIFont.boldSystemFont(ofSize: 16)
        numberField2.prefixLabel.textColor = UIColor.gray
        numberField2.suffixLabel.textColor = UIColor.gray
        
        //Add Border
        numberField2.layer.borderWidth = 0.5
        numberField2.layer.borderColor = UIColor.lightGray.cgColor
        numberField2.layer.cornerRadius = 4
        
        //Listen to NumberField Events
        numberField2.addTarget(self, action: #selector(numberFieldEditingDidBegin), for: .editingDidBegin)
        numberField2.addTarget(self, action: #selector(numberFieldEditingDidEnd), for: .editingDidEnd)
        numberField2.addTarget(self, action: #selector(numberFieldEditingChanged), for: .editingChanged)
        numberField2.addTarget(self, action: #selector(numberFieldEditingRejected), for: .editingRejected)
    }
    
//    @objc func tapGestureHandler() {
//        view.endEditing(true)
//    }
    
    //Listen to NumberField Events
    @objc func numberFieldEditingDidBegin(numberField: NumberField) {
        //Called when editing did begin
//        warningLabel.isHidden = true
    }
    @objc func numberFieldEditingDidEnd(numberField: NumberField) {
        //Called when editing did end
//        warningLabel.isHidden = true
    }
    @objc func numberFieldEditingChanged(numberField: NumberField) {
        //Called when value changed on editing
//        warningLabel.isHidden = true
    }
    @objc func numberFieldEditingRejected(numberField: NumberField) {
        //Called when input rejected. i.e. Value exceeded maximum value.
//        warningLabel.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getAllCustomers()
        getAllProducts()
        
        dropCustom[2].optionArray = conditionArray
        dropCustom[2].optionIds = conditionId
        dropCustom[2].isSearchEnable = false
        dropCustom[2].didSelect{(selectedText , index ,id) in
            self.dropCustom[2].isSearchEnable = true
            self.txtStatus.text = selectedText
        }
        
        getAllConsignmentItems()
        
        setupField2()
        // Hide keyboard when tapping outside
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
//        view.addGestureRecognizer(tapGesture)
        
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
