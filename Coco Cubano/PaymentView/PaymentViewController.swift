//
//  PaymentViewController.swift
//  Coco Cubano
//
//  Created by kavi yadav on 20/12/21.
//

import UIKit
import WebKit
import PassKit
class PaymentViewController: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    
    @IBOutlet weak var applePay: UIButton!
    
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
    var grand_total = ""
    var saved_order_id = ""
    
    var timer = Timer()
    private var paymentRequest: PKPaymentRequest = {
            let request = PKPaymentRequest()
            request.merchantIdentifier = "merchant.testpayment.com"
            request.supportedNetworks = [.visa, .masterCard,.amex,.discover]
            request.supportedCountries = ["IN","US","AU"]
            request.merchantCapabilities = .capability3DS
            request.countryCode = "AU"
            request.currencyCode = "AUD"
//        request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Spicy Bean Cafe Payment", amount:NSDecimalNumber(string: sub_total))]
            return request
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.save_order()
        webview.navigationDelegate = self
        if table_number == ""{
            table_number = "100"
        }
        paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: "Spicy Bean Cafe", amount:NSDecimalNumber(string: sub_total))]


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
                                          "grand_total":grand_total,
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
                                          "grand_total":grand_total,
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
                    let urlstring = "https://cygenpos.com/restaturant/cygenglobal/Stripeweb?order_id=" + "\(orderId)"
                    self.webview.load(NSURLRequest(url: NSURL(string: urlstring)! as URL) as URLRequest)
//                    self.scheduledTimerWithTimeInterval()
                    self.callPaymentStatusApi(param: ["order_id":self.saved_order_id])
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
        let req = NetworkManger.api.postRequest(reqType:.paymentStatus, params: param, responseType: PaymentStatusResponse.self, vc: self)
            req.done { (response:PaymentStatusResponse) in
                print(response)
                let responseCode = response.responseCode
                let message = response.message ?? ""
                print(message)
                if responseCode == "0"{
                    if let paymen_s = response.payment_code{
                        print("status:",paymen_s)
                        if paymen_s == 0 {
                            self.timer.invalidate()
                            goToNextVcThroughNavigation(currentVC: self, nextVCname: "SuccessViewController", nextVC: SuccessViewController.self)
                        }else if paymen_s == 2{
                            self.timer.invalidate()
                            goToNextVcThroughNavigation(currentVC: self, nextVCname: "FailureViewController", nextVC: FailureViewController.self)

                        }else if paymen_s == 1{
//                            self.callPaymentStatusApi(param: ["order_id":self.saved_order_id])
                        }else{
//                            self.timer.invalidate()
                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FailureViewController") as? FailureViewController
                            self.navigationController?.pushViewController(vc!, animated: true)
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
    
    
    @IBAction func tapOnApplePay(_ sender: Any) {
        if let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) {
            controller.delegate = self
            present(controller, animated: true, completion: nil)
        }
    }
}
extension PaymentViewController: WKNavigationDelegate {
     func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        print("Finished loading")
        hideActivityIndicator(uiView: self)
    }
}
extension PaymentViewController: PKPaymentAuthorizationViewControllerDelegate {
 
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
 
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
 
}
