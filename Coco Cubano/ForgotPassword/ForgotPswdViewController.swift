//
//  ForgotPswdViewController.swift
//  Coco Cubano
//
//  Created by kavi yadav on 15/12/21.
//

import UIKit

class ForgotPswdViewController: UIViewController {

    @IBOutlet weak var emailView: UIView!
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var emailTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        emailView.viewBorder(radius: 10, color: .clear, borderWidth: 0)
        submitBtn.viewBorder(radius: 10, color: .clear, borderWidth: 0)
    }
    
    // Forgot Pswd Api
    func callforgotPswdApi(param:[String:Any]){
            showActivityIndicator(uiView: self)
        let req = NetworkManger.api.postRequest(reqType:.forgotPswd, params: param, responseType: CommonResponse.self, vc: self)
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


    @IBAction func tapOnBack(_ sender: Any) {
        goBack(vc: self)
    }
    
    @IBAction func tapOnSubmitBtn(_ sender: Any) {
        let email = self.emailTxt.text ?? ""
        if email != "" {
            if isValidEmail(email: email) == true{
                self.callforgotPswdApi(param: ["email":email])
            }else{
                showToast(message: "Please enter valid email", font: UIFont.systemFont(ofSize: 14))
            }
           
        }else{
            AlertMsg(Msg: "Please enter your email", title: "Alert!", vc: self)
        }
        
    }
    
    
}
