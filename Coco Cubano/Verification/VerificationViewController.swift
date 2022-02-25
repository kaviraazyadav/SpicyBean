//
//  VerificationViewController.swift
//  Coco Cubano
//
//  Created by kavi yadav on 16/12/21.
//

import UIKit

class VerificationViewController: UIViewController {

    @IBOutlet weak var code_view: UIView!
    
    @IBOutlet weak var verifyBtn: UIButton!
    
    @IBOutlet weak var codeTxt: UITextField!
    var param = [String:Any] ()
    var token = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        token = userDefault.shared.getFcmToken(key: Constants.user_token)
        // Do any additional setup after loading the view.
    }
    // verify Api
    func callverifyApi(param:[String:Any]){
            showActivityIndicator(uiView: self)
        let req = NetworkManger.api.postRequest(reqType:.verify, params: param, responseType: LoginResponse.self, vc: self)
            req.done { (response:LoginResponse) in
                hideActivityIndicator(uiView: self)
                print(response)
                let responseCode = response.responseCode
                let message = response.message ?? ""
                print(message)
                if responseCode == "0"{
                    self.gotoLoginView(data: "otp")
                    AlertMsg(Msg: message, title: "Alert!", vc: self)
                    
                }else{
                    AlertMsg(Msg: message, title: "Alert!", vc: self)
                }
            }.catch { (error) in
                print(error)
                hideActivityIndicator(uiView: self)
            }
    }
    
    func gotoLoginView(data:String){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        vc?.comes_from = data
        self.navigationController?.pushViewController(vc!, animated: true)

    }

    
    override func viewDidLayoutSubviews() {
        self.code_view.setCardView()
        self.verifyBtn.setCardView()
    }
    

    @IBAction func tapOnBack(_ sender: Any) {
        goBack(vc: self)
    }
    
    @IBAction func tapOnVerifyBtn(_ sender: Any) {
        let code = self.codeTxt.text ?? ""
        if code != "" {
            param["mobile_otp"] = code
            param["device_type"] = "2"
            param["token_id"] = token
            print(param)
            
            self.callverifyApi(param: param)
            
        }else {
            AlertMsg(Msg: "Please enter your code", title: "Alert!", vc: self)
        }
        
    }
}
extension VerificationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 4
        
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
}
