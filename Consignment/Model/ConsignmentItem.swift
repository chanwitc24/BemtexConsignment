//
//  ConsignmentItem.swift
//  Consignment
//
//  Created by Chanwit Chummung on 13/7/2561 BE.
//  Copyright © 2561 Chanwit Chummung. All rights reserved.
//

class ConsignmentItem{
    
    var id: String?
    var customer: String?
    var product: String?
    var quantity: Int?
    var status: String?
    var remark: String?
    
    init(id: String?, customer: String?, product: String?, quantity: Int?, status: String?, remark: String?){
        self.id = id
        self.customer = customer
        self.product = product
        self.quantity = quantity
        self.status = status
        self.remark = remark
    }
    
}
