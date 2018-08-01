//
//  Product.swift
//  Consignment
//
//  Created by Chanwit Chummung on 11/7/2561 BE.
//  Copyright © 2561 Chanwit Chummung. All rights reserved.
//

class Product {
    
    var id: String?
    var name: String?
    var key: String?
    var price: Double?
    var description: String?
    var status: Bool?
    var imageUrl: String?
    
    init(id: String?, name: String?, key: String?, price: Double?, description: String?, status: Bool?, imageUrl: String?){
        self.id = id
        self.name = name
        self.key = key
        self.price = price
        self.description = description
        self.status = status
        self.imageUrl = imageUrl
    }
    
}
