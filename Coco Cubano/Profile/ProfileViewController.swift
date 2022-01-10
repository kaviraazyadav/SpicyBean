//
//  ProfileViewController.swift
//  Coco Cubano
//
//  Created by kavi yadav on 15/12/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameView: UIView!
    
    @IBOutlet weak var nameTxt: UITextField!
    
    @IBOutlet weak var emailView: UIView!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var mobileView: UIView!
    
    @IBOutlet weak var mobileTxt: UITextField!
    
    @IBOutlet weak var updateBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        let user_info = userDefault.shared.getLoginInfo(key: Constants.login_info)
        if user_info != nil {
            self.nameTxt.text = user_info.list?.customer_name ?? ""
            self.emailTxt.text = user_info.list?.email ?? ""
            self.mobileTxt.text = user_info.list?.mobile ?? ""
        }    }
    override func viewDidLayoutSubviews() {
        emailView.viewBorder(radius: 10, color: .black, borderWidth: 1)
        nameView.viewBorder(radius: 10, color: .black, borderWidth: 1)
        mobileView.viewBorder(radius: 10, color: .black, borderWidth: 1)
        updateBtn.viewBorder(radius: 10, color: .clear, borderWidth: 0)
    }
    
    // Update Profile Api
    func callUpdateProfileApi(param:[String:Any]){
            showActivityIndicator(uiView: self)
        let req = NetworkManger.api.postRequest(reqType:.updateProfile, params: param, responseType: CommonResponse.self, vc: self)
            req.done { (response:CommonResponse) in
                hideActivityIndicator(uiView: self)
                print(response)
                let responseCode = response.responseCode
                let message = response.message ?? ""
                print(message)
                if responseCode == "0"{
                    goBack(vc: self)
                    AlertMsg(Msg: message, title: "Alert", vc: self)

                }else{
                 AlertMsg(Msg: message, title: "Alert", vc: self)
                }
            }.catch { (error) in
                print(error)
                hideActivityIndicator(uiView: self)
            }
    }

    

    @IBAction func tapOnUpdate(_ sender: Any) {
        self.callUpdateProfileApi(param: ["customer_id":userDefault.shared.getUserId(key: Constants.user_id),
                                          "name":self.nameTxt.text ?? "",
                                          "email":self.emailTxt.text ?? ""])
        
    }
    
    @IBAction func tapOnBack(_ sender: Any) {
        goBack(vc: self)
    }
    
}
