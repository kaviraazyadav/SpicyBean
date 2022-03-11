//
//  SuccessViewController.swift
//  Coco Cubano
//
//  Created by kavi yadav on 20/12/21.
//

import UIKit

class SuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapOnBack(_ sender: Any) {
        
    }
    
    @IBAction func tapOnViewOrder(_ sender: Any) {
        goToNextVcThroughNavigation(currentVC: self, nextVCname: "ViewController", nextVC: ViewController.self)
    }
    

}
