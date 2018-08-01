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


class ProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
    , UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var txtProductKey: UITextField!
    @IBOutlet weak var txtProductName: UITextField!
    @IBOutlet weak var txtProductDescription: UITextField!
    @IBOutlet weak var switchStatus: UISwitch!
    @IBOutlet weak var txtProductPrice: UITextField!
    
    @IBOutlet weak var tableViewProduct: UITableView!
    
    @IBOutlet weak var takePicButton: UIButton!
    @IBOutlet weak var urlTextView: UITextView!
    
    let storage = Storage.storage()
    
    @IBAction func didTapTakePicture(_: AnyObject) {
        let picker = UIImagePickerController()
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion:nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion:nil)
        
        urlTextView.text = "Beginning Upload"
        // if it's a photo from the library, not an image from the camera
        if #available(iOS 8.0, *), let referenceUrl = info[UIImagePickerControllerReferenceURL] as? URL {
            let assets = PHAsset.fetchAssets(withALAssetURLs: [referenceUrl], options: nil)
            let asset = assets.firstObject
            asset?.requestContentEditingInput(with: nil, completionHandler: { (contentEditingInput, info) in
                let imageFile = contentEditingInput?.fullSizeImageURL
                let filePath = Auth.auth().currentUser!.uid +
                "/\(Int(Date.timeIntervalSinceReferenceDate * 1000))/\(imageFile!.lastPathComponent)"
                // [START uploadimage]
                let storageRef = self.storage.reference(withPath: filePath)
                storageRef.putFile(from: imageFile!, metadata: nil) { (metadata, error) in
                    if let error = error {
                        print("Error uploading: \(error)")
                        self.urlTextView.text = "Upload Failed"
                        return
                    }
                    self.uploadSuccess(storageRef, storagePath: filePath)
                }
                // [END uploadimage]
            })
        } else {
            guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
            guard let imageData = UIImageJPEGRepresentation(image, 0.8) else { return }
            let imagePath = Auth.auth().currentUser!.uid +
            "/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let storageRef = self.storage.reference(withPath: imagePath)
            storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error uploading: \(error)")
                    self.urlTextView.text = "Upload Failed"
                    return
                }
                self.uploadSuccess(storageRef, storagePath: imagePath)
            }
        }
    }
    
    func uploadSuccess(_ storageRef: StorageReference, storagePath: String) {
        print("Upload Succeeded!")
        storageRef.downloadURL { (url, error) in
            if let error = error {
                print("Error getting download URL: \(error)")
                self.urlTextView.text = "Can't get download URL"
                return
            }
            self.urlTextView.text = url?.absoluteString ?? ""
            UserDefaults.standard.set(storagePath, forKey: "storagePath")
            UserDefaults.standard.synchronize()
//            self.downloadPicButton.isEnabled = true
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
    
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
                       "productStatus": switchStatus.isOn as Bool,
                       "productImageUrl": urlTextView.text! as String] as [String : Any]
        
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
                self.urlTextView.text = ""
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
        
        // [START storageauth]
        // Using Cloud Storage for Firebase requires the user be authenticated. Here we are using
        // anonymous authentication.
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously(completion: { (authResult, error) in
                if let error = error {
                    self.urlTextView.text = error.localizedDescription
                    self.takePicButton.isEnabled = false
                } else {
                    self.urlTextView.text = ""
                    self.takePicButton.isEnabled = true
                }
            })
        }
        // [END storageauth]
        
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
