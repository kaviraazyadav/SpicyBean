//
//  AutocompTableViewCell.swift
//  Coco Cubano
//
//  Created by kavi yadav on 20/12/21.
//

import UIKit

class AutocompTableViewCell: UITableViewCell {

    @IBOutlet weak var addressView: UIView!
    
    @IBOutlet weak var addressLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
