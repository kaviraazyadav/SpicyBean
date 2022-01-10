//
//  CartTableViewCell.swift
//  Coco Cubano
//
//  Created by kavi yadav on 15/12/21.
//

import UIKit

class CartTableViewCell: UITableViewCell,UITableViewDataSource {

    @IBOutlet weak var proName: UILabel!
    
    @IBOutlet weak var addOnName: UILabel!
    
    @IBOutlet weak var proPrice: UILabel!
    
    @IBOutlet weak var addOnPrice: UILabel!
    
    @IBOutlet weak var delBtn: UIButton!
    @IBOutlet weak var qtyTxt: UITextField!
    @IBOutlet weak var plusMinusView: UIView!
    
    @IBOutlet weak var minusBtn: UIButton!
    
    @IBOutlet weak var plusBtn: UIButton!
    
    @IBOutlet weak var proView: UIView!
    
    @IBOutlet weak var addOnTable: UITableView!
    
    @IBOutlet weak var addOnTableHeight: NSLayoutConstraint!
    var add_data = [ViewCartAddOnList]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addOnTable.dataSource = self

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind_data(item:ViewCarListResponse){
        if let name = item.product_name{
            self.proName.text = name
        }
        if let price = item.product_price{
            self.proPrice.text = "$\(price)"
        }
        if let qty = item.product_quantity{
            self.qtyTxt.text = qty
        }
        var count = self.add_data.count
        if let itemList = item.addon_list{
            self.add_data.removeAll()
            if itemList.count != 0 {
                self.add_data = itemList
                if self.add_data.count != 1 {
                    count = self.add_data.count
                    self.addOnTableHeight.constant = CGFloat (Double(count) * 35 + 35)
                    self.addOnTable.tableViewReloadInMainThread()
                }else{
                    count = self.add_data.count
                    self.addOnTableHeight.constant = CGFloat (Double(count) * 35 )
                    self.addOnTable.tableViewReloadInMainThread()
                }
               
            }else{
            }
        }
        count = self.add_data.count
        self.addOnTableHeight.constant = CGFloat (Double(count) * 35)
        self.addOnTable.tableViewReloadInMainThread()
        
    }
    
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return add_data.count
    }
    
        
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell:AddOnCartTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AddOnCartTableViewCell
            
            let item = self.add_data[indexPath.row]
            cell.addOnNameLbl.text = item.addon_name ?? ""
            cell.addOnPriceLbl.text = "$\(item.price ?? "")"
            
            return cell
        }

}

