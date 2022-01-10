//
//  ActivityIndicator.swift
//  CueServ
//
//  Created by Deepak on 30/10/17.
//  Copyright © 2017 Deepak. All rights reserved.
//

import UIKit

var container: UIView = UIView()
var loadingView: UIView = UIView()
var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

func showActivityIndicator(uiView: UIViewController) {
    if(uiView.navigationController != nil)
    {
//        uiView.navigationController?.navigationBar.isTranslucent = true
    }
    container.frame = uiView.view.frame
    container.center = uiView.view.center
    container.backgroundColor =  UIColor.black.withAlphaComponent(0.4) //UIColorFromHex(rgbValue: 0xFFFFFF, alpha: 0.3)
    //container.alpha = 0.5
    loadingView.frame = CGRect(x:0, y:0, width:80, height:80)
    loadingView.center = uiView.view.center
    loadingView.backgroundColor = UIColor.black
    
    //UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
    loadingView.clipsToBounds = true
    loadingView.layer.cornerRadius = 10
    
    activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
    activityIndicator.center = CGPoint(x:loadingView.frame.size.width / 2, y:loadingView.frame.size.height / 2);
    activityIndicator.color = UIColor.white
    
    DispatchQueue.main.async {
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.view.addSubview(container)
        uiView.view.bringSubviewToFront(container)
        activityIndicator.startAnimating()
    }
}

func hideActivityIndicator(uiView: UIViewController) {
    DispatchQueue.main.async {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
        if(uiView.navigationController != nil)
        {
//            uiView.navigationController?.navigationBar.isTranslucent = false
        }
    }
}




/*
 func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
 let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
 let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
 let blue = CGFloat(rgbValue & 0xFF)/256.0
 return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
 }
 */


