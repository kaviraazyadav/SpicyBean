//
//  MyAccountViewController.swift
//  Coco Cubano
//
//  Created by kavi yadav on 15/12/21.
//

import UIKit

class MyAccountViewController: UIViewController {

    @IBOutlet weak var myProfileView: UIView!
    
    @IBOutlet weak var myOderView: UIView!
    
    @IBOutlet weak var changePswdView: UIView!
    @IBOutlet weak var logOutView: UIView!
    
    @IBOutlet weak var myorderTabBtn: UIButton!
    
    @IBOutlet weak var logOutTabBtn: UIButton!
    @IBOutlet weak var changePswdTabBtn: UIButton!
    @IBOutlet weak var myProfileTabBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        myProfileTabBtn.contentHorizontalAlignment = .right
        myorderTabBtn.contentHorizontalAlignment = .right
        changePswdTabBtn.contentHorizontalAlignment = .right
        logOutTabBtn.contentHorizontalAlignment = .right


    }
    override func viewDidLayoutSubviews() {
        myProfileView.viewBorder(radius: 30, color: .lightGray, borderWidth: 1)
        myOderView.viewBorder(radius: 30, color: .lightGray, borderWidth: 1)
        changePswdView.viewBorder(radius: 30, color: .lightGray, borderWidth: 1)
        logOutView.viewBorder(radius: 30, color: .lightGray, borderWidth: 1)

    }
    
    func alertAction(msg:String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.view.tintColor = .green
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)

           // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
               UIAlertAction in
            userDefault.shared.removeData(key: Constants.user_id)
            userDefault.shared.removeData(key: Constants.login_info)

            goBack(vc: self)

           }
        let cancel = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.default) {
               UIAlertAction in

           }

           // Add the actions
        alertController.addAction(cancel)
           alertController.addAction(okAction)
      

           // Present the controller
        self.present(alertController, animated: true, completion: nil)

    }

    
    @IBAction func tapOnProfileBtn(_ sender: Any) {
        goToNextVcThroughNavigation(currentVC: self, nextVCname: "ProfileViewController", nextVC: ProfileViewController.self)
    }
    
    
    @IBAction func tapOnMyOrderBtn(_ sender: Any) {
        goToNextVcThroughNavigation(currentVC: self, nextVCname: "MyorderViewController", nextVC: MyorderViewController.self)
    }
    
    @IBAction func tapOnChangePswdBtn(_ sender: Any) {
        goToNextVcThroughNavigation(currentVC: self, nextVCname: "ChangePasswordViewController", nextVC: ChangePasswordViewController.self)

    }
    
    @IBAction func tapOnLogoutBtn(_ sender: Any) {
        self.alertAction(msg: "Are You Sure, You want to Logout")
        
    }
    
    @IBAction func tapOnBackBtn(_ sender: Any) {
        goBack(vc: self)
    }
    
}
