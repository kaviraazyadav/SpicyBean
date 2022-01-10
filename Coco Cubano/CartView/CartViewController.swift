//
//  CartViewController.swift
//  Coco Cubano
//
//  Created by kavi yadav on 15/12/21.
//

import UIKit
import Kingfisher

class CartViewController: UIViewController {

    @IBOutlet weak var clickHereBtn: UIButton!
    @IBOutlet weak var cat_table: UITableView!
    
    var cart_data = [ViewCarListResponse]()
    
    @IBOutlet weak var totalVlbl: UILabel!
    
    @IBOutlet weak var taxVLBl: UILabel!
    
    @IBOutlet weak var d_chargeLbl: UILabel!
    
    @IBOutlet weak var to_payLbl: UILabel!
    
    @IBOutlet weak var totalItemsPriceLbl: UILabel!
    
    @IBOutlet weak var proceedTopayBtn: UIButton!
    
    @IBOutlet var emptyCartView: UIView!
    
    var productQty = Int()
    var cartAmount = Double()
    var each_pro_price = Double()
    override func viewDidLoad() {
        super.viewDidLoad()
        cat_table.estimatedRowHeight = 800
        cat_table.rowHeight = UITableView.automaticDimension

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        user_id = userDefault.shared.getUserId(key: Constants.user_id)
        if user_id == ""{
            self.proceedTopayBtn.setTitle(title: "Login To Continue")
            self.addCartEmptyView()
        }else{
            self.callViewCartApi(param: ["user_id":user_id])

            self.proceedTopayBtn.setTitle(title: "Proceed To Pay")
        }
    }
    
   func addCartEmptyView(){
        self.emptyCartView.frame = CGRect(x: 0, y: 130, width: self.view.frame.size.width, height: self.view.frame.size.height - 130)
        self.view.addSubview(self.emptyCartView)
    }
    // View Cart Api
    func callViewCartApi(param:[String:Any]){
            showActivityIndicator(uiView: self)
        let req = NetworkManger.api.postRequest(reqType:.view_cart, params: param, responseType: ViewCartResponse.self, vc: self)
            req.done { (response:ViewCartResponse) in
                hideActivityIndicator(uiView: self)
                print(response)
                let responseCode = response.responseCode
                let message = response.message ?? ""
                print(message)
                if responseCode == "0"{
                    if let temp_data = response.list{
                        if temp_data.count != 0{
                            self.cart_data = temp_data
                            self.bill_details()
                            self.cat_table.tableViewReloadInMainThread()
                        }else{
                            self.addCartEmptyView()

                        }
                    }
                }else{
                    self.addCartEmptyView()
//                 AlertMsg(Msg: message, title: "Alert", vc: self)
                }
            }.catch { (error) in
                print(error)
                hideActivityIndicator(uiView: self)
            }
    }
    // delete_to_cart Api
    func calldeleteToCartApi(param:[String:Any]){
//            showActivityIndicator(uiView: self)
        let req = NetworkManger.api.postRequest(reqType:.delete_cart_item, params: param, responseType: CommonResponse.self, vc: self)
            req.done { (response:CommonResponse) in
                hideActivityIndicator(uiView: self)
                print(response)
                let responseCode = response.responseCode
                let message = response.message ?? ""
                print(message)
                if responseCode == "0"{
                }else{
                 AlertMsg(Msg: message, title: "Alert", vc: self)
                }
            }.catch { (error) in
                print(error)
                hideActivityIndicator(uiView: self)
            }
    }
    // decrement_to_cart Api
    func calldecrementCartApi(param:[String:Any]){
//            showActivityIndicator(uiView: self)
        let req = NetworkManger.api.postRequest(reqType:.decrement_item, params: param, responseType: CommonResponse.self, vc: self)
            req.done { (response:CommonResponse) in
                hideActivityIndicator(uiView: self)
                print(response)
                let responseCode = response.responseCode
                let message = response.message ?? ""
                print(message)
                if responseCode == "0"{
                }else{
                 AlertMsg(Msg: message, title: "Alert", vc: self)
                }
            }.catch { (error) in
                print(error)
                hideActivityIndicator(uiView: self)
            }
    }
    // increment_to_cart Api
    func callincrementCartApi(param:[String:Any]){
//            showActivityIndicator(uiView: self)
        let req = NetworkManger.api.postRequest(reqType:.increment_item, params: param, responseType: CommonResponse.self, vc: self)
            req.done { (response:CommonResponse) in
                hideActivityIndicator(uiView: self)
                print(response)
                let responseCode = response.responseCode
                let message = response.message ?? ""
                print(message)
                if responseCode == "0"{
                }else{
                 AlertMsg(Msg: message, title: "Alert", vc: self)
                }
            }.catch { (error) in
                print(error)
                hideActivityIndicator(uiView: self)
            }
    }


    
    func bill_details(){
        var final_amount = Double()
        for item in self.cart_data {
            print(item)
            if let proAmount = item.pro_amount{
                let single_amount = Double(proAmount)
                final_amount += single_amount!
            }else{
                let single_amount = Double(item.product_price ?? "")
                final_amount += single_amount!
            }
              
          
            
            if let add_on_data = item.addon_list {
                for data in add_on_data {
                    print(data)
                    let single_add_amount = Double(data.price!)
                    final_amount += single_add_amount!
                }
            }
            
        }
        if self.cart_data.count == 0 {
            self.totalVlbl.text = "$0.0"
            self.taxVLBl.text = "$0.0"
            self.d_chargeLbl.text = "$0.0"
            self.to_payLbl.text = "$0.0"
            self.totalItemsPriceLbl.text = "0 Item(s) |  $0.0"
        }else {
            let round_value = Double(round(1000 * final_amount) / 1000)
            self.totalVlbl.text = "$\(round_value)"
            self.taxVLBl.text = "$0.0"
            self.d_chargeLbl.text = "$0.0"
            self.to_payLbl.text = "$\(round_value)"
            self.totalItemsPriceLbl.text = "Item(s) : \(self.cart_data.count)"
        }
       
    }
    
    override func  viewDidLayoutSubviews(){
      clickHereBtn.viewBorder(radius: 5, color: .clear, borderWidth: 0)
    }
    
    @IBAction func tapOnClickHere(_ sender: Any) {
        goBack(vc: self)
    }
    @IBAction func tapOnminusBtn(_ sender: UIButton) {
        let i = sender.tag
        let cell = cat_table.cellForRow(at: IndexPath(row: i, section: 0)) as! CartTableViewCell
        let qty = cell.qtyTxt.text
        productQty = Int(qty!)!
        if productQty <= 1 {
            // if product qty is 0
        }else {
            if  let each_price = self.cart_data[i].product_price {
                let amountInt = Double(each_price)!
                each_pro_price = amountInt
            }
            productQty -= 1
            cell.qtyTxt.text = String(productQty)
            let qtyDouble = Double(productQty)
            let totalamount = qtyDouble * each_pro_price
            self.cart_data[i].pro_amount = String(totalamount)
            self.cart_data[i].product_quantity = String(productQty)
            self.bill_details()
            self.calldecrementCartApi(param: ["user_id":user_id,
                                              "product_id": self.cart_data[i].product_id ?? "",
                                              "cart_id": self.cart_data[i].id ?? "",
                                              "product_qty":String(productQty)
])
        }
    }
    
    @IBAction func tapOnDelBtn(_ sender: UIButton) {
        let index = sender.tag
        let pro_id = self.cart_data[index].product_id ?? ""
        let cat_id = self.cart_data[index].id ?? ""
        self.cart_data.remove(at: index)
        self.calldeleteToCartApi(param: ["user_id":user_id,
                                         "product_id": pro_id,
                                          "cart_id": cat_id])
        self.bill_details()
        self.cat_table.tableViewReloadInMainThread()
        if self.cart_data.count == 0{
            self.addCartEmptyView()
        }
    }
    
    @IBAction func tapOnPlusBtn(_ sender: UIButton) {
        print(sender.tag)
        let i = sender.tag
        let cell = cat_table.cellForRow(at: IndexPath(row: i, section: 0)) as! CartTableViewCell
        let qty = cell.qtyTxt.text
        if  let each_price = self.cart_data[i].product_price {
            let amountInt = Double(each_price)!
            each_pro_price = amountInt
        }
        productQty = Int(qty!)!
        productQty += 1
        cell.qtyTxt.text = String(productQty)
        let qtyDouble = Double(productQty)
        let totalamount = qtyDouble * each_pro_price
        let round_value = Double(round(1000 * totalamount) / 1000)

        self.cart_data[i].pro_amount = String(round_value)
        self.cart_data[i].product_quantity = String(productQty)
        self.bill_details()
        self.callincrementCartApi(param: ["user_id":user_id,
                                          "product_id": self.cart_data[i].product_id ?? "",
                                          "cart_id": self.cart_data[i].id ?? "",
                                          "product_qty":String(productQty)
])

    }
    
    @IBAction func tapOnBack(_ sender: Any) {
        goBack(vc: self)
    }
    
    @IBAction func tapOnProceedToPay(_ sender: Any) {
        if user_id == ""{
            goToNextVcThroughNavigation(currentVC: self, nextVCname: "LoginViewController", nextVC: LoginViewController.self)
        }else{
            
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
            vc.cartData = self.cart_data
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
extension  CartViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart_data.count
    }
    
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell:CartTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cart_cell") as! CartTableViewCell
            
            cell.proView.setCardView()
            cell.plusMinusView.viewBorder(radius: 5, color: .lightGray, borderWidth: 1)
            cell.minusBtn.tag = indexPath.row
            cell.plusBtn.tag = indexPath.row
            cell.delBtn.tag = indexPath.row
            let item = self.cart_data[indexPath.row]
            cell.bind_data(item: item)

            
            return cell
        }

    
    

}
