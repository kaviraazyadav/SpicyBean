//
//  SignIpViewController.swift
//  Coco Cubano
//
//  Created by kavi yadav on 15/12/21.
//

import UIKit

class SignIpViewController: UIViewController {

    @IBOutlet weak var userNameView: UIView!
    
    @IBOutlet weak var userNameTxt: UITextField!
    
    @IBOutlet weak var emailView: UIView!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var mobileView: UIView!
    
    @IBOutlet weak var mobileTxt: UITextField!
    
    @IBOutlet weak var pswdView: UIView!
    
    @IBOutlet weak var pswdTxt: UITextField!
    
    @IBOutlet weak var cnfPswdView: UIView!
    
    @IBOutlet weak var cnfPswdTxt: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        userNameView.viewBorder(radius: 10, color: .clear, borderWidth: 0)
        emailView.viewBorder(radius: 10, color: .clear, borderWidth: 0)
        mobileView.viewBorder(radius: 10, color: .clear, borderWidth: 0)
        pswdView.viewBorder(radius: 10, color: .clear, borderWidth: 0)
        cnfPswdView.viewBorder(radius: 10, color: .clear, borderWidth: 0)
        signUpBtn.viewBorder(radius: 10, color: .clear, borderWidth: 0)


    }
    func sign_up_validation(){
        let user_name = self.userNameTxt.text ?? ""
        let email = self.emailTxt.text ?? ""
        let mobile = self.mobileTxt.text ?? ""
        let pswd = self.pswdTxt.text ?? ""
        let cnf_pswd = self.cnfPswdTxt.text ?? ""
        if user_name != "" && email != "" && mobile != "" && pswd != "" && cnf_pswd != "" {
            if pswd == cnf_pswd {
                
                callSignupApi(param: ["userName":user_name,"mobile":mobile,"email":email,"userPassword":pswd,"confirmPassword":cnf_pswd])
            }else {
                AlertMsg(Msg: "Password and Confirm password does not match", title: "Alert!", vc: self)

            }
            
        }else{
            AlertMsg(Msg: "Please input all the fields", title: "Alert!", vc: self)
        }



        
    }
    // SignUp Api
    func callSignupApi(param:[String:Any]){
            showActivityIndicator(uiView: self)
        let req = NetworkManger.api.postRequest(reqType:.sign_up, params: param, responseType: LoginResponse.self, vc: self)
            req.done { (response:LoginResponse) in
                hideActivityIndicator(uiView: self)
                print(response)
                let responseCode = response.responseCode
                let message = response.message ?? ""
                print(message)
                if responseCode == "0"{
                    self.alertAction(msg: message, param: param)
                }else{
                    AlertMsg(Msg: message, title: "Alert!", vc: self)
                }
            }.catch { (error) in
                print(error)
                hideActivityIndicator(uiView: self)
            }
    }
    
    func alertAction(msg:String,param:[String:Any]){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)

           // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
               UIAlertAction in
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VerificationViewController") as! VerificationViewController
            vc.param = param
            self.navigationController?.pushViewController(vc, animated: true)

           }
           // Add the actions
           alertController.addAction(okAction)

           // Present the controller
        self.present(alertController, animated: true, completion: nil)

    }

    
    @IBAction func tapOnBackBtn(_ sender: Any) {
        goBack(vc: self)
    }
    
    @IBAction func tapOnSignUpBtn(_ sender: Any) {
        self.sign_up_validation()
    }
    
}
