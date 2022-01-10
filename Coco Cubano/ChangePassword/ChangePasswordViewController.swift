//
//  ChangePasswordViewController.swift
//  Coco Cubano
//
//  Created by kavi yadav on 15/12/21.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    
    @IBOutlet weak var olpsdView: UIView!
    
    @IBOutlet weak var oldPsdTxt: UITextField!
    
    @IBOutlet weak var newPsdView: UIView!
    
    @IBOutlet weak var newPsdTxt: UITextField!
    
    @IBOutlet weak var cnfPsdView: UIView!
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var cnfPsdTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
        olpsdView.viewBorder(radius: 10, color: .clear, borderWidth: 0)
        newPsdView.viewBorder(radius: 10, color: .clear, borderWidth: 0)
        cnfPsdView.viewBorder(radius: 10, color: .clear, borderWidth: 0)
        submitBtn.viewBorder(radius: 10, color: .clear, borderWidth: 0)
    }



  

    

    @IBAction func tapOnSubmitBtn(_ sender: Any) {
    }
    
    @IBAction func tapOnBackBtn(_ sender: Any) {
        goBack(vc: self)
    }
}
