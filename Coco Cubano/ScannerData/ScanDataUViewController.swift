//
//  ScanDataUViewController.swift
//  Coco Cubano
//
//  Created by kavi yadav on 22/12/21.
//

import UIKit
class ScanDataUViewController: UIViewController {

    @IBOutlet weak var nameView: UIView!
    
    @IBOutlet weak var nameTxt: UITextField!
    
    @IBOutlet weak var emailView: UIView!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var mobileView: UIView!
    
    @IBOutlet weak var mobileTxt: UITextField!
    
    @IBOutlet weak var tableNoView: UIView!
    
    @IBOutlet weak var tableTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.tableNoView.viewBorder(radius: 2, color: .lightGray, borderWidth: 1)
        self.mobileView.viewBorder(radius: 2, color: .lightGray, borderWidth: 1)
    }
    
    func validateQrInfo(){
        let email = self.emailTxt.text ?? ""
        let mobile = self.mobileTxt.text ?? ""
        let name = self.mobileTxt.text ?? ""
        let table_no = self.tableTxt.text ?? ""
        if email != "" && mobile != "" && name != "" && table_no != "" {
//            table_number = table_no
            AlertWithAction(Msg: "Thanks for choosing table, let's make order", title: "Message", vc: self)
        }else{
            AlertMsg(Msg: "Please input all the fields", title: "Message", vc: self)
        }
    }
    


    @IBAction func tapOnBack(_ sender: Any) {
        dismissController(vc: self)
    }
    @IBAction func taponsubmit(_ sender: Any) {
        validateQrInfo()
    }
}
