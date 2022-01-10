//
//  CheckoutViewController.swift
//  Coco Cubano
//
//  Created by kavi yadav on 15/12/21.
//

import UIKit

class CheckoutViewController: UIViewController{

    @IBOutlet weak var nameView: UIView!
    
    @IBOutlet weak var nameTxt: UITextField!
    
    @IBOutlet weak var emailView: UIView!
    
    @IBOutlet weak var emailTxtx: UITextField!
    
    @IBOutlet weak var mobileView: UIView!
    
    @IBOutlet weak var mobileTxt: UITextField!
    
    @IBOutlet weak var streetView: UIView!
    
    @IBOutlet weak var streetTxt: UITextField!
    
    @IBOutlet weak var searchAddView: UIView!
    
    @IBOutlet weak var delTimeView: UIView!
    
    @IBOutlet weak var delTimeTxt: UITextField!
    
    @IBOutlet weak var commentsView: UIView!
    
    @IBOutlet weak var commentTxtView: UITextView!
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var subTotalV: UILabel!
    
    @IBOutlet weak var taxVlbl: UILabel!
    
    @IBOutlet weak var deliveryFee: UILabel!
    
    @IBOutlet weak var totalVLbl: UILabel!
    
    @IBOutlet weak var search_addressTxt: UITextField!
    
    @IBOutlet weak var searchAddressHeight: NSLayoutConstraint!
    
    @IBOutlet weak var streetHeight: NSLayoutConstraint!
    
    @IBOutlet weak var defaultAddressHeight: NSLayoutConstraint!
    @IBOutlet weak var checkoutTotalLbl: UILabel!
    
    @IBOutlet weak var pickUpAddressLbl: UILabel!
    
    @IBOutlet weak var addressLblV: UILabel!
    
    @IBOutlet weak var changeAddressBtn: UIButton!
    
    @IBOutlet weak var nameViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var emailViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var noteLblHeight: NSLayoutConstraint!
    @IBOutlet weak var delPikHeight: NSLayoutConstraint!
    @IBOutlet weak var mobileViewHeight: NSLayoutConstraint!
    var cartData = [ViewCarListResponse]()
    var item_qtyArr = [String]()
    var item_priceArr = [String]()
    var item_idArr = [String]()
    var addOnId_arr = [String]()
    var addOnOrice_arr = [String]()
    var addOnQty_arr = [String]()
    var addOnTotal_price = ""
    var sub_total = ""
    var selected_address = ""
    
    
    var datePickerView = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.deliverymodeDetail()
        let user_info = userDefault.shared.getLoginInfo(key: Constants.login_info)
        if user_info != nil {
            self.nameTxt.text = user_info.list?.customer_name ?? ""
            self.emailTxtx.text = user_info.list?.email ?? ""
            self.mobileTxt.text = user_info.list?.mobile ?? ""
        }
        self.bill_details()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CheckoutViewController.tapFunction))
        self.search_addressTxt.isUserInteractionEnabled = true
        self.search_addressTxt.addGestureRecognizer(tap)
        self.notificationHits()

        // Do any additional setup after loading the view.
    }
    
    func deliverymodeDetail(){
        changeAddressBtn.isHidden = true
        if mode_of_delivery == "1"{
            self.searchAddressHeight.constant = 0
            self.streetHeight.constant = 0
            self.delTimeTxt.placeholder = "Enter Pickup Time"
            selected_address = "Shop 1/145 McEvoy St, Alexandria NSW 2015,Australia"
            self.streetTxt.text = "145"
        }else if mode_of_delivery == "2" {
            self.defaultAddressHeight.constant = 0
            self.searchAddressHeight.constant = 50
            self.streetHeight.constant = 50
            self.delTimeTxt.placeholder = "Enter Delivery Time"
            self.callDefaultAddressListApi(param: ["customerId":userDefault.shared.getUserId(key: Constants.user_id)])
        }else if mode_of_delivery == "" {
            self.defaultAddressHeight.constant = 0
            self.nameViewHeight.constant = 0
            self.mobileViewHeight.constant = 0
            self.emailViewHeight.constant = 0
            self.searchAddressHeight.constant = 0
            self.delPikHeight.constant = 0
            self.noteLblHeight.constant = 0
            self.streetHeight.constant = 0
            selected_address = table_number
            self.streetTxt.text = table_number
        }

    }
    
    func notificationHits(){
        NotificationCenter.default.addObserver(self, selector: #selector(searchedAddress(notification:)), name: .searched_address, object: nil)
    }
    
    @objc func searchedAddress(notification:Notification)
    {
        print(notification.userInfo as Any)
        let data = notification.userInfo!["data"] as? String
        if data != nil {
            self.search_addressTxt.text = data
           
        }
      
       
    }
    
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        print("tap working")
        openPopUp(currentVC: self, nextVCname: "AutoCompleteViewController", nextVC: AutoCompleteViewController.self)

    }
    
    // Add Address Api
    func calladdAddressListApi(param:[String:Any]){
//            showActivityIndicator(uiView: self)
        let req = NetworkManger.api.postRequest(reqType:.addAddress, params: param, responseType: CommonResponse.self, vc: self)
            req.done { (response:CommonResponse) in
                hideActivityIndicator(uiView: self)
                print(response)
                let responseCode = response.responseCode
                let message = response.message ?? ""
                print(message)
                if responseCode == "0"{

                }else{
                    AlertMsg(Msg: message, title: "Alert!", vc: self)
                }
            }.catch { (error) in
                print(error)
                hideActivityIndicator(uiView: self)
            }
    }
    
    // Default Address Api
    func callDefaultAddressListApi(param:[String:Any]){
            showActivityIndicator(uiView: self)
        let req = NetworkManger.api.postRequest(reqType:.default_address, params: param, responseType: DefaultAddressResponse.self, vc: self)
            req.done { (response:DefaultAddressResponse) in
                hideActivityIndicator(uiView: self)
                print(response)
                let responseCode = response.responseCode
                let message = response.message ?? ""
                print(message)
                if responseCode == "0"{
                    self.bindDefaultAddressData(response: response)

                }else{
                    self.defaultAddressHeight.constant = 0
                }
            }.catch { (error) in
                print(error)
                hideActivityIndicator(uiView: self)
            }
    }
    
    func bindDefaultAddressData(response:DefaultAddressResponse){
        let address = "\(response.flatno!),\(response.Address!)"
        self.selected_address = address
        self.streetTxt.text = response.flatno ?? ""
        self.pickUpAddressLbl.text = "Delivery Address :"
        self.addressLblV.text = address
        self.defaultAddressHeight.constant = 128
        self.changeAddressBtn.isHidden = false
        self.nameViewHeight.constant = 0
        self.mobileViewHeight.constant = 0
        self.emailViewHeight.constant = 0
        self.searchAddressHeight.constant = 0
        self.emailTxtx.text = response.Email ?? ""
        self.nameTxt.text = response.Name ?? ""
        self.mobileTxt.text = response.Mobile ?? ""
        self.search_addressTxt.text = response.Address ?? ""
    }

    func pickUpDate(_ sender:UITextField) {
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(CheckoutViewController.dismissPicker))

        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!

        let currentDate: Date = Date()

        let components: NSDateComponents = NSDateComponents()
        
        components.year = -150
        let minDate: Date = gregorian.date(byAdding: components as DateComponents, to: currentDate, options: NSCalendar.Options(rawValue: 0))!
        
        sender.inputAccessoryView = toolBar
        datePickerView.datePickerMode = .dateAndTime
        datePickerView.minimumDate = minDate
        datePickerView.maximumDate = currentDate
        datePickerView.preferredDatePickerStyle = .inline
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)

    }

    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-mm-yyyy HH:mm"
        delTimeTxt.text = dateFormatter.string(from: sender.date)

    }
    @objc func dismissPicker() {
        
        view.endEditing(true)
        
    }

    
    override func viewDidLayoutSubviews() {
        self.nameView.viewBorder(radius: 10, color: .lightGray, borderWidth: 1)
        self.emailView.viewBorder(radius: 10, color: .lightGray, borderWidth: 1)
        self.mobileView.viewBorder(radius: 10, color: .lightGray, borderWidth: 1)
        self.streetView.viewBorder(radius: 10, color: .lightGray, borderWidth: 1)
        self.searchAddView.viewBorder(radius: 10, color: .lightGray, borderWidth: 1)
        self.delTimeView.viewBorder(radius: 10, color: .lightGray, borderWidth: 1)
        self.commentsView.viewBorder(radius: 10, color: .lightGray, borderWidth: 1)
        self.scrollview.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 100)

        
        
    }
    func bill_details(){
        var final_amount = Double()
        var addOnTotal_amount = Double()
        for item in self.cartData {
            print(item)
            if let proAmount = item.pro_amount{
                let single_amount = Double(item.pro_amount!)
                final_amount += single_amount!

            }else{
                let single_amount = Double(item.product_price!)
                final_amount += single_amount!
            }
            item_qtyArr.append(item.product_quantity ?? "")
            item_priceArr.append(item.product_price ?? "")
            item_idArr.append(item.id ?? "")
            if let add_on_data = item.addon_list {
                for data in add_on_data {
                    print(data)
                    let single_add_amount = Double(data.price!)
                    final_amount += single_add_amount!
                    addOnTotal_amount += single_add_amount!
                    addOnId_arr.append(data.addon_id ?? "")
                    addOnOrice_arr.append(data.price ?? "")
                    addOnQty_arr.append(data.qty ?? "")
                    addOnTotal_price = "\(addOnTotal_amount)"
                }
            }
            
        }
        if self.cartData.count == 0 {
            self.subTotalV.text = "$0.0"
            self.taxVlbl.text = "$0.0"
            self.deliveryFee.text = "$0.0"
            self.totalVLbl.text = "$0.0"
            self.checkoutTotalLbl.text = "$0.0"
        }else {
            let round_value = Double(round(1000 * final_amount) / 1000)
            self.sub_total = "$\(round_value)"
            self.subTotalV.text = "$\(round_value)"
            self.taxVlbl.text = "$0.0"
            self.deliveryFee.text = "$0.0"
            self.totalVLbl.text = "$\(round_value)"
            self.checkoutTotalLbl.text = "$\(round_value)"
        }
       
    }
   
    
    @IBAction func tapOnChangeAddress(_ sender: Any) {
        self.nameViewHeight.constant = 50
        self.mobileViewHeight.constant = 50
        self.emailViewHeight.constant = 50
        self.searchAddressHeight.constant = 50
    }
    
    @IBAction func tapOnPlaceOrder(_ sender: Any) {
        self.placeOrder()
    }
    
    func placeOrder(){
        let name = self.nameTxt.text ?? ""
        let email = self.emailTxtx.text ?? ""
        let mobile = self.mobileTxt.text ?? ""
        let flat_no = self.streetTxt.text ?? ""
        let location = self.search_addressTxt.text ?? ""
        let delivery_time = self.deliveryFee.text ?? ""
        if mode_of_delivery == "2"{
            if name != "" && email != "" && mobile != "" && flat_no != "" && location != "" && delivery_time != "" {
                self.calladdAddressListApi(param: ["customerId":userDefault.shared.getUserId(key: Constants.user_id),
                    "first_name":name,
                    "email":email,
                    "mobile":mobile,
                    "flatno":flat_no,
                    "location":location,
                    "landmark":"near test",
                    "address":location,
                    "userLat":"71.928282",
                    "userLong":"79.93939",
                    "note":self.commentTxtView.text ?? ""
                    ])
                self.movetoPayment()
            }else{
                AlertMsg(Msg: "Please input all the fields", title: "Alert!", vc: self)
            }
        }else{
            // for table top
            self.calladdAddressListApi(param: ["customerId":userDefault.shared.getUserId(key: Constants.user_id),
                "first_name":name,
                "email":email,
                "mobile":mobile,
                "flatno":flat_no,
                "location":location,
                "landmark":"near test",
                "address":location,
                "userLat":"71.928282",
                "userLong":"79.93939",
                "note":self.commentTxtView.text ?? ""
                ])
            self.movetoPayment()
        }
       

    }
    
    func movetoPayment(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        vc.item_idArr = self.item_idArr
        vc.item_qtyArr = self.item_qtyArr
        vc.item_priceArr = self.item_priceArr
        vc.addOnId_arr = self.addOnId_arr
        vc.addOnQty_arr = self.addOnQty_arr
        vc.addOnOrice_arr = self.addOnOrice_arr
        vc.addOnTotal_price = self.addOnTotal_price
        vc.sub_total = self.sub_total
        vc.note = self.commentTxtView.text ?? ""
        vc.name = self.nameTxt.text ?? ""
        vc.email = self.emailTxtx.text ?? ""
        vc.mobile = self.mobileTxt.text ?? ""
        vc.address = selected_address
        vc.location = self.streetTxt.text ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func tapOnBack(_ sender: Any) {
        goBack(vc: self)
    }
    
  
}
extension CheckoutViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == delTimeTxt{
            self.pickUpDate(delTimeTxt)
        }
    }
}
