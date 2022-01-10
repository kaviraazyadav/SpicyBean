//
//  OrderDetailTableViewCell.swift
//  Coco Cubano
//
//  Created by kavi yadav on 21/12/21.
//

import UIKit

class OrderDetailTableViewCell: UITableViewCell {

    
    @IBOutlet weak var proname: UILabel!
    
    
    @IBOutlet weak var price: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
