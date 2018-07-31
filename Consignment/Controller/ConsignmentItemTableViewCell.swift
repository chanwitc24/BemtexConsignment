//
//  ConsignmentItemTableViewCell.swift
//  Consignment
//
//  Created by Chanwit Chummung on 13/7/2561 BE.
//  Copyright © 2561 Chanwit Chummung. All rights reserved.
//

import UIKit

class ConsignmentItemTableViewCell: UITableViewCell {
    @IBOutlet weak var lblCustomer: UILabel!
    @IBOutlet weak var lblProduct: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblRemark: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
