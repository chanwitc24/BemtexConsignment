//
//  Customer.swift
//  Consignment
//
//  Created by Chanwit Chummung on 11/7/2561 BE.
//  Copyright © 2561 Chanwit Chummung. All rights reserved.
//

class Customer {

    var id: String?
    var name: String?
    var address: String?
    var phone: String?
    var status: Bool?
    
    init(id: String?, name: String?, address: String?, phone: String?, status: Bool?){
        self.id = id
        self.name = name
        self.address = address
        self.phone = phone
        self.status = status
    }
}
