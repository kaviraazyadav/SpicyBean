//
//  SearchTableViewCell.swift
//  Coco Cubano
//
//  Created by kavi yadav on 06/01/22.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var product_view: UIView!
    
    @IBOutlet weak var pro_image: UIImageView!
    
    @IBOutlet weak var pro_name: UILabel!
    
    @IBOutlet weak var pro_price: UILabel!
    
    @IBOutlet weak var addBtn: UIButton!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func bind_data(item:ProductLists){
        if let name = item.item_name{
            self.pro_name.text = name
        }
        if let pro_image = item.item_image{
            showImgWithLink(imgUrl: pro_image, imgView: self.pro_image)
        }
        if let pro_price = item.sales_price{
            self.pro_price.text = "$\(pro_price)"
        }
    }
}
