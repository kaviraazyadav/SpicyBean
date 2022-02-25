//
//  SearchViewController.swift
//  Coco Cubano
//
//  Created by kavi yadav on 06/01/22.
//

import UIKit

class SearchViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var cat_nameLbl: UILabel!
    
    @IBOutlet weak var badgeLbl: UILabel!
    
    @IBOutlet weak var searchView: UIView!
   
    @IBOutlet weak var pro_table: UITableView!
    @IBOutlet weak var seacrhTxt: UITextField!
    
    var cat_id = ""
    var cat_name = ""
    var products_arr = [ProductLists]()
    var cart_item = CartProductLists()
    var cart_data = [CartProductLists]()

    var productQty = Int()
    var cartAmount = Double()
    var each_pro_price = Double()
   var bag_count = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.seacrhTxt.delegate = self
        // Do any additional setup after loading the view.
        if bag_count != ""{
            self.badgeLbl.text = bag_count
        }else{
            self.badgeLbl.text = "0"
        }
        self.notificationHits()
        self.seacrhTxt.addTarget(self, action: #selector(SearchViewController.textFieldDidChange(_:)), for: .editingChanged)

    }
    
    
    func notificationHits(){
        NotificationCenter.default.addObserver(self, selector: #selector(addOnProductsSeacrh(notification:)), name: .addOnData_toSeacrhView, object: nil)
    }
    @objc func addOnProductsSeacrh(notification:Notification)
    {
        print(notification.userInfo as Any)
        let data = notification.userInfo!["data"] as? [CartProductLists]
        if data != nil {
            for item in data! {
                self.cart_data.append(item)
            }

            if user_id != ""{
                self.callViewCartApi(param: ["user_id":user_id], from: "addon")
            }
        }
      
       
    }
    // View Cart Api
    func callViewCartApi(param:[String:Any],from:String){
//            showActivityIndicator(uiView: self)
        let req = NetworkManger.api.postRequest(reqType:.view_cart, params: param, responseType: ViewCartResponse.self, vc: self)
            req.done { (response:ViewCartResponse) in
                hideActivityIndicator(uiView: self)
                print(response)
                let responseCode = response.responseCode
                let message = response.message ?? ""
                print(message)
                if responseCode == "0"{
                    if let temp_count = response.count{
                        self.badgeLbl.text = "\(temp_count)"
                    }
                    if from == "addon"{
                        AlertMsg(Msg: "Product updated successfully", title: "Message", vc: self)
                    }
                }else{
//                 AlertMsg(Msg: message, title: "Alert", vc: self)
                    self.badgeLbl.text = "0"
                }
            }.catch { (error) in
                print(error)
                hideActivityIndicator(uiView: self)
            }
    }
    // Product Api
    func callProductListApi(param:[String:Any]){
//            showActivityIndicator(uiView: self)
        let req = NetworkManger.api.postRequest(reqType:.products, params: param, responseType: ProductsResponse.self, vc: self)
            req.done { (response:ProductsResponse) in
                hideActivityIndicator(uiView: self)
                print(response)
                let responseCode = response.responseCode
                let message = response.message ?? ""
                print(message)
                if responseCode == "0"{
                    self.products_arr.removeAll()
                    if let items = response.list{
                        self.products_arr = items
                        self.pro_table.tableViewReloadInMainThread()
                    }

                }
                else{
                    self.products_arr.removeAll()
                    self.pro_table.tableViewReloadInMainThread()
                    AlertMsg(Msg: message, title: "Alert!", vc: self)
                }
            }.catch { (error) in
                print(error)
                hideActivityIndicator(uiView: self)
            }
    }
    override func viewDidLayoutSubviews() {
        searchView.viewBorder(radius: 5, color: .lightGray, borderWidth: 1)
        self.badgeLbl.layer.cornerRadius = self.badgeLbl.frame.width/2
        self.badgeLbl.layer.masksToBounds = true

    }
    @objc func textFieldDidChange(_ textField: UITextField) {
      if textField.text == ""{
            self.products_arr.removeAll()
            self.pro_table.tableViewReloadInMainThread()
        }

    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
            let str = string
        if str != ""{
            if textField.text!.count >= 2{
                self.callProductListApi(param: ["search_text":textField.text ?? ""])
            }
        }
        if let char = string.cString(using: String.Encoding.utf8) {
               let isBackSpace = strcmp(char, "\\b")
               if (isBackSpace == -92) {
                   print("Backspace was pressed")
               }
           }
            return true
        }

    func send_pro_to_cartServer(data:CartProductLists){
        let name = data.item_name ?? ""
        let price = data.sales_price ?? ""
        let qty = data.pro_qty ?? ""
        let id = data.id ?? ""
        let userId = userDefault.shared.getUserId(key: Constants.user_id)
        let catId = self.cart_item.category_id ?? ""
        var addOnList = [String:Any]()
        var addonParam =  [[String:Any]]()
        if let add_on_data = data.item_list{
            for record in add_on_data {
                addOnList["addon_id"] = record.item_id
                addOnList["addon_qty"] = record.add_on_qty
                addOnList["addon_price"] = record.modifier_price
                addOnList["note"] = "sampe"
                addOnList["addon_name"] = record.modifier_name
                addonParam.append(addOnList)
            }
        }
        
       

        self.callAddToCartApi(param: ["user_id":userId,
                                      "productId":id,
                                      "productPrice":price,
                                      "product_quantity":qty,
                                      "opType":"0",
                                      "catId":catId,
                                      "product_name":name,
                                      "addon_list":addonParam])
    }
    // Add_to_cart Api
    func callAddToCartApi(param:[String:Any]){
//            showActivityIndicator(uiView: self)
        let req = NetworkManger.api.postRequest(reqType:.addToCart, params: param, responseType: CommonResponse.self, vc: self)
            req.done { (response:CommonResponse) in
                hideActivityIndicator(uiView: self)
                print(response)
                let responseCode = response.responseCode
                let message = response.message ?? ""
                print(message)
                if responseCode == "0"{
                    AlertMsg(Msg: message, title: "Message", vc: self)
                    self.callViewCartApi(param: ["user_id":user_id], from: "")

                }else{
                 AlertMsg(Msg: message, title: "Alert", vc: self)
                }
            }.catch { (error) in
                print(error)
                hideActivityIndicator(uiView: self)
            }
    }

    @IBAction func tapOnBack(_ sender: Any) {
        goBack(vc: self)
    }
    
    @IBAction func tapOnAdProBtn(_ sender: UIButton) {
        let item = self.products_arr[sender.tag]
        if user_id != "" {
            if let item_list = item.item_list{
                if item_list.count != 0 {
                    openPopUp(currentVC: self, nextVCname: "AddOnViewController", nextVC: AddOnViewController.self)
                    NotificationCenter.default.post(name: .addOnPro_toShow, object: nil , userInfo: ["data":item,"comes_from":"search_vc"])
                }else{
                    self.cart_item.pro_amount = item.sales_price
                    self.cart_item.pro_qty = "1"
                    self.cart_item.item_name = item.item_name
                    self.cart_item.id = item.id
                    self.cart_item.sales_price = item.sales_price
                    self.cart_item.item_image = item.item_image
                    self.cart_data.append(self.cart_item)
                    self.send_pro_to_cartServer(data: self.cart_item)
                }
            }
        }else {
            goToNextVcThroughNavigation(currentVC: self, nextVCname: "LoginViewController", nextVC: LoginViewController.self)
        }

    }
    
}
extension  SearchViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products_arr.count
    }
    
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell:SearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "search_cell") as! SearchTableViewCell
            
            cell.product_view.setCardView()
            cell.addBtn.viewBorder(radius: 10, color: .clear, borderWidth: 0)
            cell.pro_image.viewBorder(radius: 5, color: .clear, borderWidth: 0)
            cell.addBtn.tag = indexPath.row

            if let item_list = self.products_arr[indexPath.row].item_list{
                if item_list.count != 0 {
                    cell.addBtn.setTitle(title: "Add+")
                }
                else{
                    cell.addBtn.setTitle(title: "Add")
                }
            }

            let item = self.products_arr[indexPath.row]
            cell.bind_data(item: item)
            return cell
        }

    

}
