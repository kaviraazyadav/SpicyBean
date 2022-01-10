//
//  AddOnViewController.swift
//  Coco Cubano
//
//  Created by kavi yadav on 15/12/21.
//

import UIKit

class AddOnViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var pro_nameLbl: UILabel!
    @IBOutlet weak var pro_price_lbl: UILabel!
    
    @IBOutlet weak var add_on_table: UITableView!
    
    @IBOutlet weak var comment_view: UIView!
    
    @IBOutlet weak var addNoteTxt: UITextView!
    
    @IBOutlet weak var addItemBtn: UIButton!
    
    @IBOutlet weak var closeBtn: UIButton!
    
    var addonListArr = [AddonList]()
    var cart_item = CartProductLists()
    var arrSelectedIndex = [IndexPath]() // This is selected cell Index array
    var arrSelectedData = [AddonList]() // This is selected cell data array
var comes_from = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
        NotificationCenter.default.addObserver(self, selector: #selector(addOnProducts(notification:)), name: .addOnPro_toShow, object: nil)

    }
    @objc func addOnProducts(notification:Notification)
    {
        print(notification.userInfo as Any)
        let data = notification.userInfo!["data"] as? ProductLists
        comes_from = notification.userInfo!["comes_from"] as? String ?? ""
        print("reaction",data)
        if let proname = data?.item_name {
            self.pro_nameLbl.text = proname
            self.cart_item.item_name = proname
        }
        if let sale_price = data?.sales_price {
            self.pro_price_lbl.text = "$\(sale_price)"
            self.cart_item.sales_price = sale_price
            self.cart_item.pro_amount = sale_price
        }
        self.cart_item.pro_qty = "1"
        self.cart_item.item_image = data?.item_image
        self.cart_item.id = data?.id
        self.cart_item.category_id = data?.category_id
        
        if let add_ons = data?.item_list{
            self.addonListArr = add_ons
        }
       
        self.add_on_table.tableViewReloadInMainThread()
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
                }else{
                 AlertMsg(Msg: message, title: "Alert", vc: self)
                }
            }.catch { (error) in
                print(error)
                hideActivityIndicator(uiView: self)
            }
    }

    func send_pro_to_cartServer(){
        let name = self.cart_item.item_name ?? ""
        let price = self.cart_item.sales_price ?? ""
        let qty = self.cart_item.pro_qty ?? ""
        let id = self.cart_item.id ?? ""
        let userId = userDefault.shared.getUserId(key: Constants.user_id)
        let catId = self.cart_item.category_id ?? ""
        var addOnList = [String:Any]()
        var addonParam =  [[String:Any]]()
        for record in self.arrSelectedData {
            addOnList["addon_id"] = record.item_id
            addOnList["addon_qty"] = record.add_on_qty
            addOnList["addon_price"] = record.modifier_price
            addOnList["note"] = "sampe"
            addOnList["addon_name"] = record.modifier_name
            addonParam.append(addOnList)
        }
        print("addOns",addonParam)

        self.callAddToCartApi(param: ["user_id":userId,
                                      "productId":id,
                                      "productPrice":price,
                                      "product_quantity":qty,
                                      "opType":"0",
                                      "catId":catId,
                                      "product_name":name,
                                      "addon_list":addonParam])
    }
    
    

    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
dismissController(vc: self)
                
            }
        });
    }

    @IBAction func tapOnAddItem(_ sender: Any) {
        if comes_from == "product_vc" {
            self.cart_item.item_list = arrSelectedData
            print(self.cart_item)
            self.send_pro_to_cartServer()
            NotificationCenter.default.post(name: .addOnData_toProductView, object: nil , userInfo: ["data":[self.cart_item]])
            removeAnimate()

        }else if comes_from == "search_vc" {
            self.cart_item.item_list = arrSelectedData
            print(self.cart_item)
            self.send_pro_to_cartServer()
            NotificationCenter.default.post(name: .addOnData_toSeacrhView, object: nil , userInfo: ["data":[self.cart_item]])
            removeAnimate()
        }
        else{
            self.cart_item.item_list = arrSelectedData
            print(self.cart_item)
            self.send_pro_to_cartServer()
            NotificationCenter.default.post(name: .addOnData_tocart, object: nil , userInfo: ["data":[self.cart_item]])
            removeAnimate()
        }
          
        
    }
    @IBAction func tapOnClose(_ sender: Any) {
        removeAnimate()
    }
    
    @IBAction func tapOnCheckBtn(_ sender: UIButton) {
        let i = sender.tag
        let indexPath = IndexPath(row: i, section: 0)
        var add_on_item = self.addonListArr[i]
        let cell = add_on_table.cellForRow(at: IndexPath(row: i, section: 0)) as! AddOnTableViewCell
        if arrSelectedIndex.contains(indexPath) {
            arrSelectedIndex = arrSelectedIndex.filter { $0 != indexPath}
            arrSelectedData.remove(at: sender.tag)
            cell.checkBtn.setImage(UIImage(named: "uncheck"), for: .normal)
        }
        else {
            add_on_item.add_on_qty = "1"
            arrSelectedIndex.append(indexPath)
            cell.checkBtn.setImage(UIImage(named: "check"), for: .normal)
            arrSelectedData.append(add_on_item)
        }

    }
    
    
    
}
extension  AddOnViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addonListArr.count
    }
    
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell:AddOnTableViewCell = tableView.dequeueReusableCell(withIdentifier: "addOn_cell") as! AddOnTableViewCell
            cell.checkBtn.tag = indexPath.row
            let item = self.addonListArr[indexPath.row]
            if let name = item.modifier_name{
                cell.add_on_name.text = name
            }
            if let price = item.modifier_price{
                cell.add_on_pric.text = "$\(price)"
            }
            
            return cell
        }

    
    

}
