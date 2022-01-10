//
//  LoginViewController.swift
//  Coco Cubano
//
//  Created by kavi yadav on 15/12/21.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailView: UIView!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var pswdView: UIView!
    
    @IBOutlet weak var pswdTxt: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var signInWithGView: UIView!
    @IBOutlet weak var fgPswd: UIButton!
    
    @IBOutlet weak var fbBtnView: UIView!
    
    var comes_from = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (AccessToken.current != nil) {
            print("PreviousTokenExists")
            // User is logged in, do work such as go to next view controller.
        }


        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        self.emailView.viewBorder(radius: 10, color: .clear, borderWidth: 0)
        self.pswdView.viewBorder(radius: 10, color: .clear, borderWidth: 0)
        self.loginBtn.viewBorder(radius: 10, color: .clear, borderWidth: 0)
        self.signInWithGView.viewBorder(radius: 10, color: .clear, borderWidth: 0)
        self.fbBtnView.viewBorder(radius: 10, color: .clear, borderWidth: 0)

    }
    func getFbLoginInfo() {
        let LoginManager = LoginManager()
        LoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            if let accessToken = AccessToken.current{
                self.fetchUserProfile()
            }
                else {
                print("Failed to login: \(error?.localizedDescription)")
                print("Failed to get access token")
                return
            }
        }
    }
    
    func fetchUserProfile()
    {
        let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields":"id, email, name, picture.width(480).height(480)"])
        graphRequest.start(completion: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                print("Error took place: \(String(describing: error))")
            }
            else
            {
                print("Print entire fetched result: \(String(describing: result))")
                guard let data = result as? [String:Any] else { return }
                let id : String = data["id"] as! String
                print("User ID is: \(id)")
                
                if let userName = data["name"] as? String
                {
                    print("User name is: \(userName)")
                }
                var pictureUrlString = ""
                if let profilePictureObj = data["picture"] as? NSDictionary
                {
                    print("User picture is: \(profilePictureObj)")
                    let data = profilePictureObj.value(forKey: "data") as! NSDictionary
                     pictureUrlString  = data.value(forKey: "url") as! String
                    let pictureUrl = NSURL(string: pictureUrlString)
                }
                let fullName = data["name"] as? String
                let user_id = data["id"] as? String
                let userEmail = data["email"] as? String
                
                self.callLoginSocialApi(param: ["UserName":fullName,
                                                "email": userEmail,
                                                "social_login": "FB"])
            }
        })
    }
    
    
    

    func login_validation (){
        let user_name = self.emailTxt.text ?? ""
        let password = self.pswdTxt.text ?? ""
        
        if user_name != "" && password != "" {
            callLoginApi(param: ["username":user_name , "password":password])
        }else{
            AlertMsg(Msg: "Please enter user name password", title: "Alert", vc: self)
        }
        
    }
    // Login Api
    func callLoginApi(param:[String:Any]){
            showActivityIndicator(uiView: self)
        let req = NetworkManger.api.postRequest(reqType:.login, params: param, responseType: LoginResponse.self, vc: self)
            req.done { (response:LoginResponse) in
                hideActivityIndicator(uiView: self)
                print(response)
                let responseCode = response.responseCode
                let message = response.message ?? ""
                print(message)
                if responseCode == "0"{
                    if let user_id = response.list?.id{
                        userDefault.shared.saveUserId(data: user_id, key: Constants.user_id)
                        userDefault.shared.saveLoginInfo(data: response, key: Constants.login_info)
                      goBack(vc: self)
                    }
                }else{
                    AlertMsg(Msg: message, title: "Alert!", vc: self)
                }
            }.catch { (error) in
                print(error)
                hideActivityIndicator(uiView: self)
            }
    }
    
    // Login Api
    func callLoginSocialApi(param:[String:Any]){
            showActivityIndicator(uiView: self)
        let req = NetworkManger.api.postRequest(reqType:.socialLogin, params: param, responseType: LoginResponse.self, vc: self)
            req.done { (response:LoginResponse) in
                hideActivityIndicator(uiView: self)
                print(response)
                let responseCode = response.responseCode
                let message = response.message ?? ""
                print(message)
                if responseCode == "0"{
                    if let user_id = response.list?.id{
                        userDefault.shared.saveUserId(data: user_id, key: Constants.user_id)
                        userDefault.shared.saveLoginInfo(data: response, key: Constants.login_info)
                      goBack(vc: self)
                    }
                }else{
                    AlertMsg(Msg: message, title: "Alert!", vc: self)
                }
            }.catch { (error) in
                print(error)
                hideActivityIndicator(uiView: self)
            }
    }

    


  
    @IBAction func tapOnLoginBtn(_ sender: Any) {
        self.login_validation()
    }
    
    @IBAction func tapOnForgotPswd(_ sender: Any) {
        goToNextVcThroughNavigation(currentVC: self, nextVCname: "ForgotPswdViewController", nextVC: ForgotPswdViewController.self)
    }
    @IBAction func tapOnSignUpBtn(_ sender: Any) {
        goToNextVcThroughNavigation(currentVC: self, nextVCname: "SignIpViewController", nextVC: SignIpViewController.self)

    }
    
    @IBAction func loginWithFb(_ sender: Any) {
        self.getFbLoginInfo()
    }
    
    @IBAction func tapOnSigninWithG(_ sender: Any) {
        self.loginWithGoogle()
    }
    func loginWithGoogle(){
        let signInConfig = GIDConfiguration.init(clientID:"590799002026-3dv3dutidfl8njdflpr6qioiltkpqgr6.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
          guard error == nil else { return }

          // If sign in succeeded, display the app's main content View.
        }
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }

            let emailAddress = user.profile?.email

            let fullName = user.profile?.name
            let givenName = user.profile?.givenName
            let familyName = user.profile?.familyName

            let profilePicUrl = user.profile?.imageURL(withDimension: 320)
            self.callLoginSocialApi(param: ["UserName":fullName,
                                            "email": emailAddress,
                                            "social_login": "google"])
        }

    }
    
    
    @IBAction func tapOnBack(_ sender: Any) {
        if comes_from == "otp"{
            goToNextVcThroughNavigation(currentVC: self, nextVCname: "ViewController", nextVC: ViewController.self)
        }else{
            goBack(vc: self)
        }
     
    }
    
    
}
