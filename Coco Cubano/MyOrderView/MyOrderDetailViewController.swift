//
//  MyOrderDetailViewController.swift
//  Coco Cubano
//
//  Created by kavi yadav on 21/12/21.
//

import UIKit

class MyOrderDetailViewController: UIViewController {

    @IBOutlet weak var orderView: UIView!
    
    @IBOutlet weak var custNmae: UILabel!
    
    @IBOutlet weak var orderId: UILabel!
    
    @IBOutlet weak var ord_date: UILabel!
    
    @IBOutlet weak var amount: UILabel!
    
    @IBOutlet weak var ordTable: UITableView!
    
    @IBOutlet weak var paymentDetailView: UIView!
    
    @IBOutlet weak var itemsLbl: UILabel!
    
    @IBOutlet weak var subTotalLBl: UILabel!
    
    @IBOutlet weak var taxLbl: UILabel!
    
    @IBOutlet weak var del_charges: UILabel!
    @IBOutlet weak var total: UILabel!
    
    var order_detail_data = MyorderList()
    var pro_arr = [OrderProductsList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind_data()
    }
    override func viewDidLayoutSubviews() {
        self.orderView.setCardView()
    }
    
    func bind_data(){
        
        if let ord_id = self.order_detail_data.id{
            self.orderId.text = "Order Id : \(ord_id)"
        }
        if let cust_name = self.order_detail_data.customer_name{
            self.custNmae.text = "Name : \(cust_name)"
        }
        if let orddate = self.order_detail_data.sales_date{
            self.ord_date.text = "Oder Date : \(orddate)"
        }
        if let p_status = self.order_detail_data.payment_status{
            self.amount.text = "Payment Status : \(p_status)"
        }
        if let pro_list = self.order_detail_data.item_list{
            for item in pro_list {
                self.pro_arr.append(item)
            }
            self.bill_details()
            self.ordTable.tableViewReloadInMainThread()
        }
        
    }
    func bill_details(){
        var final_amount = Double()
        for item in self.pro_arr {
            print(item)
            let single_amount = Double(item.total_cost!)
            final_amount += single_amount!
            
        }
        if self.pro_arr.count == 0 {
            self.total.text = "$0.0"
            self.subTotalLBl.text = "$0.0"
            self.del_charges.text = "$0.0"
            self.taxLbl.text = "$0.0"
            self.itemsLbl.text = "0"
        }else {
            let round_value = Double(round(1000 * final_amount) / 1000)
            self.total.text = "$\(round_value)"
            self.subTotalLBl.text = "$\(round_value)"
            self.del_charges.text = "$0.0"
            self.taxLbl.text = "$0.0"
            self.itemsLbl.text = "\(self.pro_arr.count)"
        }
       
    }


    @IBAction func tapOnBack(_ sender: Any) {
        goBack(vc: self)
    }
    
}
extension  MyOrderDetailViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pro_arr.count
    }
    
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell:OrderDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! OrderDetailTableViewCell
            let data = self.pro_arr[indexPath.row]
            if let pro_name = data.item_name{
                cell.proname.text = pro_name
            }
            if let price = data.total_cost{
                cell.price.text = "$\(price)"
            }

            
            return cell
        }

    
    

}

