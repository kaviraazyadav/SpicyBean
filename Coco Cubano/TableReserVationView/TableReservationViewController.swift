//
//  TableReservationViewController.swift
//  Coco Cubano
//
//  Created by kavi yadav on 15/12/21.
//

import UIKit

class TableReservationViewController: UIViewController {

    @IBOutlet weak var nameView: UIView!
    
    @IBOutlet weak var emailView: UIView!
    
    @IBOutlet weak var peopleView: UIView!
    
    @IBOutlet weak var dateTimeView: UIView!
    
    @IBOutlet weak var dateTimeTxt: UITextField!
    
    var datePickerView = UIDatePicker()
    var myPicker = UIPickerView ()
    @IBOutlet weak var mobileView: UIView!
    
    @IBOutlet weak var mobileTxt: UITextField!
    
    @IBOutlet weak var noteView: UIView!
    
    @IBOutlet weak var noteTxtView: UITextView!
    
    @IBOutlet weak var nameTxt: UITextField!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var noPeopleTxt: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
        noteTxtView.textColor = .lightGray
        noteTxtView.text = "message..."
        let user_info = userDefault.shared.getLoginInfo(key: Constants.login_info)
        if user_info != nil {
            self.nameTxt.text = user_info.list?.customer_name ?? ""
            self.emailTxt.text = user_info.list?.email ?? ""
            self.mobileTxt.text = user_info.list?.mobile ?? ""
        }


    }
    
    
    
    override func viewDidLayoutSubviews() {
        self.nameView.viewBorder(radius: 2, color: .lightGray, borderWidth: 1)
        self.emailView.viewBorder(radius: 2, color: .lightGray, borderWidth: 1)
        self.peopleView.viewBorder(radius: 2, color: .lightGray, borderWidth: 1)
        self.dateTimeView.viewBorder(radius: 2, color: .lightGray, borderWidth: 1)
        self.mobileView.viewBorder(radius: 2, color: .lightGray, borderWidth: 1)
        self.noteView.viewBorder(radius: 2, color: .lightGray, borderWidth: 1)
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
    func pickUpDate(_ sender:UITextField) {
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(TableReservationViewController.dismissPicker))

        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!

        let currentDate: Date = Date()

        let components: NSDateComponents = NSDateComponents()
        
//        components.year = -150
//        let minDate: Date = gregorian.date(byAdding: components as DateComponents, to: currentDate, options: NSCalendar.Options(rawValue: 0))!
        components.month = 1
        
        let maxDate: Date = gregorian.date(byAdding: components as DateComponents, to: currentDate, options: NSCalendar.Options(rawValue: 0))!
        
        sender.inputAccessoryView = toolBar
        datePickerView.datePickerMode = .dateAndTime
        datePickerView.minimumDate = currentDate
        datePickerView.maximumDate = maxDate
        datePickerView.preferredDatePickerStyle = .inline
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }

    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY hh:mm"
        dateTimeTxt.text = dateFormatter.string(from: sender.date)

    }
    @objc func dismissPicker() {
        
        view.endEditing(true)
        
    }
    
    func clearFields(){
       self.nameTxt.text = ""
        self.emailTxt.text =  ""
         self.mobileTxt.text =  ""
         self.noPeopleTxt.text =  ""
        self.dateTimeTxt.text =  ""
        self.noteTxtView.text = ""
    }
    
    func validateReserveTableApi(){
        let name = self.nameTxt.text ?? ""
        let email = self.emailTxt.text ?? ""
        let mobile = self.mobileTxt.text ?? ""
        let people_count = self.noPeopleTxt.text ?? ""
        let date_time = self.dateTimeTxt.text ?? ""

        let note = self.noteTxtView.text ?? ""
        
        if name != "" && email != "" && mobile != "" && people_count != "" && date_time != "" {
            if isValidEmail(email: email) == true{
                let dateArr = date_time.components(separatedBy: " ")
                let date = dateArr[0]
                let time = dateArr[1]
                self.callreserveTableApi(param: ["res_email":email,
                                                 "res_mobile": mobile,
                                                 "res_name": name,
                                                 "res_people":people_count,
                                                 "res_date":date,
                                                 "res_time":time,
                                                 "res_message":note])
                
            }else{
                showToast(message: "Enter valid email", font: UIFont.systemFont(ofSize: 14))
            }
           
        }else{
            AlertMsg(Msg: "Please input all the fields", title: "Alert!", vc: self)
        }
        
    }
    
    // TableReservation Api
    func callreserveTableApi(param:[String:Any]){
            showActivityIndicator(uiView: self)
        let seconds = 1.0
        let req = NetworkManger.api.postRequest(reqType:.reserveTable, params: param, responseType: ReserveTableResponse.self, vc: self)
            req.done { (response:ReserveTableResponse) in
                hideActivityIndicator(uiView: self)
                print(response)
                let responseCode = response.responseCode
                let message = response.message ?? ""
                print(message)
                if responseCode == "0"{
                    self.clearFields()
                    AlertWithAction(Msg: message, title: "Alert", vc: self)
                }else{
                 AlertMsg(Msg: message, title: "Alert", vc: self)
                }
            }.catch { (error) in
                print(error)
                hideActivityIndicator(uiView: self)
            }
    }


    
    @IBAction func tapOnSubmitBtn(_ sender: Any) {
        self.validateReserveTableApi()
        
    }
    
    
    @IBAction func tapOnBack(_ sender: Any) {
        removeAnimate()
    }
    
}
extension TableReservationViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateTimeTxt{
            self.pickUpDate(dateTimeTxt)
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mobileTxt {
            let maxLength = 10
            
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
       return true
    }
}
extension TableReservationViewController: UITextViewDelegate{
    func textViewDidBeginEditing (_ textView: UITextView) {
        if noteTxtView.textColor == .lightGray && noteTxtView.isFirstResponder {
            noteTxtView.text = nil
            noteTxtView.textColor = .black
        }
    }

    func textViewDidEndEditing (_ textView: UITextView) {
        if noteTxtView.text.isEmpty || noteTxtView.text == "" {
            noteTxtView.textColor = .lightGray
            noteTxtView.text = "message..."
        }
    }
}
