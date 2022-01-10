//
//  AddOnTableViewCell.swift
//  Coco Cubano
//
//  Created by kavi yadav on 15/12/21.
//

import UIKit

class AddOnTableViewCell: UITableViewCell {

    @IBOutlet weak var add_on_view: UIView!
    
    @IBOutlet weak var checkBtn: UIButton!
    
    @IBOutlet weak var add_on_name: UILabel!
    @IBOutlet weak var add_on_pric: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
