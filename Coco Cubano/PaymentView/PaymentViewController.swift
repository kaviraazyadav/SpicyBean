//
//  PaymentViewController.swift
//  Coco Cubano
//
//  Created by kavi yadav on 20/12/21.
//

import UIKit
import WebKit
class PaymentViewController: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    
    var item_qtyArr = [String]()
    var item_priceArr = [String]()
    var item_idArr = [String]()
    var addOnId_arr = [String]()
    var addOnOrice_arr = [String]()
    var addOnQty_arr = [String]()
    var addOnTotal_price = ""
    var sub_total = ""
    var note = ""
    var name = ""
    var email = ""
    var mobile = ""
    var address = ""
    var location = ""
    var saved_order_id = ""
    
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.save_order()
        webview.navigationDelegate = self
        if table_number == ""{
            table_number = "100"
        }

    }
    func save_order(){
        let cust_id = userDefault.shared.getUserId(key: Constants.user_id)
        let formatteditemIdArray = (self.item_idArr.map{String($0)}).joined(separator: ",")
        let formatteditem_qtyArrArray = (self.item_qtyArr.map{String($0)}).joined(separator: ",")
        let formatteditem_priceArrArray = (self.item_priceArr.map{String($0)}).joined(separator: ",")
        let formattedaddOnId_arrArray = (self.addOnId_arr.map{String($0)}).joined(separator: ",")
        let formattedaddOnOrice_arrArray = (self.addOnOrice_arr.map{String($0)}).joined(separator: ",")
        let formattedaddOnQty_arrArray = (self.addOnQty_arr.map{String($0)}).joined(separator: ",")


        if table_number != "" {
            self.callsaveOrderApi(param: ["customer_id":cust_id,
                                           "order_type":"tableTop",
                                           "subtotal":sub_total,
                                          "itemqty":formatteditem_qtyArrArray,
                                          "itemprice":formatteditem_priceArrArray,
                                           "tax_type":"1",
                                          "itemId":formatteditemIdArray,
                                           "name":name,
                                           "email":email,
                                           "mobile":mobile,
                                           "location":location,
                                           "address":address,
                                           "requested_for":"1",
                                          "addonId":formattedaddOnId_arrArray,
                                          "addonPrice":formattedaddOnOrice_arrArray,
                                          "addontotalPrice":self.addOnTotal_price,
                                          "addonqty":formattedaddOnQty_arrArray,
                                          "note":self.note,
                                          "table_number":table_number
    ])
        }else{
            self.callsaveOrderApi(param: ["customer_id":cust_id,
                                           "order_type":mode_of_delivery,
                                           "subtotal":sub_total,
                                          "itemqty":formatteditem_qtyArrArray,
                                          "itemprice":formatteditem_priceArrArray,
                                           "tax_type":"1",
                                          "itemId":formatteditemIdArray,
                                           "name":name,
                                           "email":email,
                                           "mobile":mobile,
                                           "location":location,
                                           "address":address,
                                           "requested_for":"1",
                                          "addonId":formattedaddOnId_arrArray,
                                          "addonPrice":formattedaddOnOrice_arrArray,
                                          "addontotalPrice":self.addOnTotal_price,
                                          "addonqty":formattedaddOnQty_arrArray,
                                          "note":self.note,
    ])
        }
       
    }
    // Save Order Api
    func callsaveOrderApi(param:[String:Any]){
            showActivityIndicator(uiView: self)
        let req = NetworkManger.api.postRequest(reqType:.saveOrder, params: param, responseType: CommonResponse.self, vc: self)
            req.done { (response:CommonResponse) in
                print(response)
                let responseCode = response.responseCode
                let message = response.message ?? ""
                print(message)
                if responseCode == "0"{
                    let orderId = response.order_id ?? ""
                    userDefault.shared.removeData(key: Constants.cart_info)
                    self.saved_order_id = orderId
                    let urlstring = "https://cococubanorousehill.com.au/Stripeweb?order_id=" + "\(orderId)"
                    self.webview.load(NSURLRequest(url: NSURL(string: urlstring)! as URL) as URLRequest)
                    self.scheduledTimerWithTimeInterval()
                }else{
                    AlertMsg(Msg: message, title: "Alert!", vc: self)
                }
            }.catch { (error) in
                print(error)
                hideActivityIndicator(uiView: self)
            }
    }
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)

    }
          
  @objc  func updateCounting(){
        self.callPaymentStatusApi(param: ["order_id":saved_order_id])
    }


    // Payment Status Api
    func callPaymentStatusApi(param:[String:Any]){
//            showActivityIndicator(uiView: self)
        let req = NetworkManger.api.postRequest(reqType:.paymentStatus, params: param, responseType: CommonResponse.self, vc: self)
            req.done { (response:CommonResponse) in
                print(response)
                let responseCode = response.responseCode
                let message = response.message ?? ""
                print(message)
                if responseCode == "0"{
                    if let paymen_s = response.payment_status{
                        print("status:",paymen_s)
                        if paymen_s == "success"{
                            self.timer.invalidate()
                            goToNextVc(currentVC: self, nextVCname: "SuccessViewController.self", nextVC: SuccessViewController.self)
                        }else if paymen_s == "failure"{
                            self.timer.invalidate()
                            goToNextVc(currentVC: self, nextVCname: "FailureViewController.self", nextVC: FailureViewController.self)

                        }else if paymen_s != ""{
                            self.timer.invalidate()
                            goToNextVc(currentVC: self, nextVCname: "FailureViewController.self", nextVC: FailureViewController.self)

                        }
                    }
                }else{
                    AlertMsg(Msg: message, title: "Alert!", vc: self)
                }
            }.catch { (error) in
                print(error)
                hideActivityIndicator(uiView: self)
                self.timer.invalidate()
                goToNextVc(currentVC: self, nextVCname: "FailureViewController.self", nextVC: FailureViewController.self)
            }
    }


    @IBAction func tapOnBack(_ sender: Any) {
        timer.invalidate()
        goBack(vc: self)
    }
    
}
extension PaymentViewController: WKNavigationDelegate {
     func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        print("Finished loading")
        hideActivityIndicator(uiView: self)
    }
}
