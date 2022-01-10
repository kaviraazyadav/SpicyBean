//
//  MyOrderTableViewCell.swift
//  Coco Cubano
//
//  Created by kavi yadav on 21/12/21.
//

import UIKit

class MyOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var custNameLbl: UILabel!
    
    @IBOutlet weak var orderIdLbl: UILabel!
  
    @IBOutlet weak var orderDateLbl: UILabel!
    
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var orderDetailBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(item:MyorderList){
        if let cust_name = item.customer_name{
            self.custNameLbl.text = "Name : \(cust_name)"
        }
        if let order_id = item.id{
            self.orderIdLbl.text = "Order Id : \(order_id)"
        }
        if let order_date = item.sales_date{
            self.orderDateLbl.text = "Order Date : \(order_date)"
        }
        if let amount = item.paid_amount{
            self.amountLbl.text = "Amount : $\(amount)"
        }

    }

}
