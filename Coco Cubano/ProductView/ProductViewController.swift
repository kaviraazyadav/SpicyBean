//
//  ProductViewController.swift
//  Coco Cubano
//
//  Created by kavi yadav on 15/12/21.
//

import UIKit

class ProductViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var cat_nameLbl: UILabel!
    
    @IBOutlet weak var badgeLbl: UILabel!
    @IBOutlet weak var searchView: UIView!
    
   
    @IBOutlet weak var catBtn: UIButton!
    
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var
pro_table: UITableView!
    var cat_id = ""
    var cat_name = ""
    var products_arr = [ProductLists]()
    var filter_products_arr = [ProductLists]()

    var cart_item = CartProductLists()
    var cart_data = [CartProductLists]()

    var productQty = Int()
    var cartAmount = Double()
    var each_pro_price = Double()
    var searchStr:String=""

    
    override func viewDidLoad() {
        self.cat_nameLbl.text = cat_name
        self.callProductListApi(param: ["category_id":cat_id])
        self.searchTxt.delegate = self
        super.viewDidLoad()
        self.notificationHits()
        self.searchTxt.addTarget(self, action: #selector(ProductViewController.textFieldDidChange(_:)), for: .editingChanged)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        user_id = userDefault.shared.getUserId(key: Constants.user_id)
        if user_id != ""{
            self.callViewCartApi(param: ["user_id":user_id], from: "")
        }

    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text == ""{
            searchStr = ""
            self.filter_products_arr.removeAll()
            self.pro_table.tableViewReloadInMainThread()
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
                }
            }.catch { (error) in
                print(error)
                hideActivityIndicator(uiView: self)
            }
    }

    override func viewDidLayoutSubviews() {
        catBtn.circleViewWithShadow()
        self.badgeLbl.layer.cornerRadius = self.badgeLbl.frame.width/2
        self.badgeLbl.layer.borderWidth = 1
        self.badgeLbl.layer.borderColor = hexStringToUIColor(hex: "#fcb419").cgColor
        self.badgeLbl.layer.masksToBounds = true
        self.searchView.viewBorder(radius: 5, color: .lightGray, borderWidth: 1)
    }
    
    func notificationHits(){
        NotificationCenter.default.addObserver(self, selector: #selector(addOnProducts(notification:)), name: .addOnData_toProductView, object: nil)
    }
    @objc func addOnProducts(notification:Notification)
    {
        print(notification.userInfo as Any)
        let data = notification.userInfo!["data"] as? [CartProductLists]
        if data != nil {
            for item in data! {
                self.cart_data.append(item)
            }
            
//            userDefault.shared.saveCartInfo(data: self.cart_data, key: Constants.cart_info)
//            self.badgeLbl.text = "\(self.cart_data.count)"
            if user_id != ""{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.callViewCartApi(param: ["user_id":user_id], from: "addon")
                }
            }
        }
      
       
    }
    func update_table_cell(item_id:String){
        for (i, item) in self.products_arr.enumerated() {
           if let pro_id = item.id {
                if item_id == pro_id {
                    self.products_arr[i].is_pro_addedTo_cart = true
                    self.products_arr[i].pro_qty = "1"
                }
            }
           
        }
        self.pro_table.tableViewReloadInMainThread()
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if string.isEmpty
        {
            if textField.text != ""{
                searchStr = textField.text ?? ""
            }else{
                searchStr = ""
            }
          
            
        }
        else
        {
            searchStr=textField.text!+string
        }

        print(searchStr)
        if searchStr.count >= 2 {
            filter_products_arr.removeAll()
            let filteredArray = self.products_arr.filter({guestData -> Bool in
                let searchLowercased = searchStr.uppercased()
                let matches:[String?] = [guestData.item_name]
                let nonNilElements = matches.compactMap { $0 }

                for element in nonNilElements {
                    if element.uppercased().contains(searchLowercased) {
                        return true
                    }
                }
                return false
            })
            if filteredArray.count > 0 {
                filter_products_arr = filteredArray
            }

        }else if searchStr.count >= 1{
            self.filter_products_arr.removeAll()
            self.filter_products_arr = self.products_arr
        }
        
        print(filter_products_arr)

   
        self.pro_table.tableViewReloadInMainThread()
        return true
    }



    @IBAction func tapOnplusbtn(_ sender: UIButton) {
    }
    
    @IBAction func tapOnMinusBtn(_ sender: UIButton) {
    }
    
    @IBAction func tapOnAddBtn(_ sender: UIButton) {
        var item = ProductLists()
        if searchStr != ""{
             item = self.filter_products_arr[sender.tag]

        }else{
             item = self.products_arr[sender.tag]

        }
        if user_id != "" {
            if let item_list = item.item_list{
                if item_list.count != 0 {
                    openPopUp(currentVC: self, nextVCname: "AddOnViewController", nextVC: AddOnViewController.self)
                    NotificationCenter.default.post(name: .addOnPro_toShow, object: nil , userInfo: ["data":item,"comes_from":"product_vc"])
                }else{
                    self.cart_item.pro_amount = item.sales_price
                    self.cart_item.pro_qty = "1"
                    self.cart_item.item_name = item.item_name
                    self.cart_item.id = item.id
                    self.cart_item.sales_price = item.sales_price
                    self.cart_item.item_image = item.item_image
                    self.cart_data.append(self.cart_item)
                    self.badgeLbl.text = "\(self.cart_data.count)"
                    self.send_pro_to_cartServer(data: self.cart_item)
                }
            }
        }else {
            goToNextVcThroughNavigation(currentVC: self, nextVCname: "LoginViewController", nextVC: LoginViewController.self)
        }
      
    }
    
    
    // Product Api
    func callProductListApi(param:[String:Any]){
            showActivityIndicator(uiView: self)
        let req = NetworkManger.api.postRequest(reqType:.products, params: param, responseType: ProductsResponse.self, vc: self)
            req.done { (response:ProductsResponse) in
                hideActivityIndicator(uiView: self)
                print(response)
                let responseCode = response.responseCode
                let message = response.message ?? ""
                print(message)
                if responseCode == "0"{
                    
                    if let items = response.list{
                        self.products_arr = items
                        self.pro_table.tableViewReloadInMainThread()
                    }

                }else{
                    AlertMsg(Msg: message, title: "Alert!", vc: self)
                }
            }.catch { (error) in
                print(error)
                hideActivityIndicator(uiView: self)
            }
    }

   
    @IBAction func tapOnBack(_ sender: Any) {
        goBack(vc: self)
    }
    @IBAction func tapOnAllCat(_ sender: Any) {
        goBack(vc: self)
    }
    
    @IBAction func tapOnHome(_ sender: Any) {
//        goToNextVcThroughNavigation(currentVC: self, nextVCname: "ViewController", nextVC: ViewController.self)
        goBack(vc: self)
    }
    
    @IBAction func tapOnTble(_ sender: Any) {
        openPopUp(currentVC: self, nextVCname: "TableReservationViewController", nextVC: TableReservationViewController.self)
    }
    @IBAction func tapOnProfile(_ sender: Any) {
        if user_id != "" {
            goToNextVcThroughNavigation(currentVC: self, nextVCname: "MyAccountViewController", nextVC: MyAccountViewController.self)

        }else{
            goToNextVcThroughNavigation(currentVC: self, nextVCname: "LoginViewController", nextVC: LoginViewController.self)

        }
        
    }
    
    @IBAction func taponCart(_ sender: Any) {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
//            vc.cart_data = self.cart_data
            self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension  ProductViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchStr != "" {
            return self.filter_products_arr.count
        }
        return self.products_arr.count
    }
    
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell:ProductTableViewCell = tableView.dequeueReusableCell(withIdentifier: "pro_cell") as! ProductTableViewCell
            
            cell.product_view.setCardView()
            cell.addBtn.viewBorder(radius: 10, color: .clear, borderWidth: 0)
            cell.pro_image.viewBorder(radius: 5, color: .clear, borderWidth: 0)
            cell.plusBtn.tag = indexPath.row
            cell.minusBtn.tag = indexPath.row
            cell.plusMinusView.viewBorder(radius: 15, color: .lightGray, borderWidth: 1)
            cell.addBtn.tag = indexPath.row
            if self.searchTxt.text != "" {
                if let item_list = self.filter_products_arr[indexPath.row].item_list{
                    if item_list.count != 0 {
                        cell.addBtn.setTitle(title: "Add+")
                    }
                    else{
                        cell.addBtn.setTitle(title: "Add")
                    }
                }

                let item = self.filter_products_arr[indexPath.row]
                cell.bind_data(item: item)
            }else{
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
            }
           
            return cell
        }
}
