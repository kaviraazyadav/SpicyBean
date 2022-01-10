//
//  Common.swift
//  CueServ
//
//  Created by Deepak on 05/10/17.
//  Copyright © 2017 Deepak. All rights reserved.
//

import Foundation
import WebKit
import UIKit
import SwiftEntryKit
import Kingfisher
import AVFoundation
import SystemConfiguration

func isInternetAvailable() -> Bool
{
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        NSLog("There IS NO internet connection");
        return false
    }
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    NSLog("There IS internet connection");
    return (isReachable && !needsConnection)
}


class Common{
class func AddGredientColor( uiview:CALayer )
{
    
    uiview.sublayers?.forEach { $0.removeFromSuperlayer() }
    let gradientLeft: CAGradientLayer = CAGradientLayer()
    
    gradientLeft.colors = [UIColor.darkGray.cgColor, UIColor.white.cgColor,UIColor.darkGray.cgColor]
    gradientLeft.locations = [0.0 , 1.0]
    gradientLeft.startPoint = CGPoint(x: 0.0, y: 0.0)
    gradientLeft.endPoint = CGPoint(x: 1.0, y: 1.0)
    gradientLeft.frame = CGRect(x: 0.0, y: 0.0, width: (uiview.frame.size.width), height: 0.5)
    
    let gradientRight: CAGradientLayer = CAGradientLayer()
    
    gradientRight.colors = [UIColor.darkGray.cgColor, UIColor.white.cgColor,UIColor.darkGray.cgColor]
    gradientRight.locations = [0.0 , 1.0]
    gradientRight.startPoint = CGPoint(x: 1.0, y: 0.0)
    gradientRight.endPoint = CGPoint(x: 0.0, y: 1.0)
    gradientRight.frame = CGRect(x: (uiview.frame.size.width), y: 0.0, width: (uiview.frame.size.width), height: 0.5)
    uiview.insertSublayer(gradientLeft, at: 0)
    uiview.insertSublayer(gradientRight, at: 1)
    
    //print(gradientLeft.frame.width)
    // print(uiview.frame.width)
    //gradientLeft.frame.size.width = (uiview.bounds.size.width)/2
    //gradientRight.frame.size.width = (uiview.bounds.size.width)/2
    }
class func OnlineStatus( lblStatus:UILabel, status:Int)
    {
        lblStatus.lineBreakMode = .byWordWrapping
        lblStatus.numberOfLines = 0
        lblStatus.layer.cornerRadius = 8
        lblStatus.layer.borderWidth = 1
        lblStatus.layer.masksToBounds = true
        lblStatus.clipsToBounds = true
        lblStatus.font = UIFont(name: "Avenir", size: 12)
        //lblStatus.frame.size = CGSize(width: 68, height: 16)
        lblStatus.textAlignment = NSTextAlignment.center
        
        switch status {
        case 1:
            lblStatus.textColor = UIColor.white
            lblStatus.layer.borderColor = UIColorFromHex(rgbValue: 0x7ED321, alpha: 1.0).cgColor
            lblStatus.backgroundColor = UIColorFromHex(rgbValue: 0x7ED321, alpha: 1.0)
            lblStatus.text = "Online"
        case 2:
            lblStatus.textColor = UIColor.white
            lblStatus.layer.borderColor = UIColorFromHex(rgbValue: 0xE8DB3F, alpha: 1.0).cgColor
            lblStatus.backgroundColor = UIColorFromHex(rgbValue: 0xE8DB3F, alpha: 1.0)
            lblStatus.text = "Away"
        default:
            lblStatus.textColor = UIColor.white
            lblStatus.layer.borderColor = UIColorFromHex(rgbValue: 0xE7233B, alpha: 1.0).cgColor
            lblStatus.backgroundColor = UIColorFromHex(rgbValue: 0xE7233B, alpha: 1.0)
            lblStatus.text = "Offline"
        }
  
    }
}

func getCurrentDateUTC()->String
{
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"  // yyyy-MM-dd'T'HH:mm:ss.SSS
    let result = formatter.string(from: date)
    return  localToUTC(date: result)
    
}


func getFormattedDate(dt:Date, format:String)->String
{
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: dt)
   
}
func getDateStringFromUTC(dateVal:Double) -> String {
    let date = Date(timeIntervalSince1970: dateVal)
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US")
    dateFormatter.dateStyle = .medium
    return dateFormatter.string(from: date)
}
func getTimeFromDate(dateVal: String)-> String
{
    let newdate = convertTimestamp(serverTimestamp: Double(dateVal)!)
    let dtTimeArr : [String] = newdate.components(separatedBy: " ")
    if dtTimeArr.count==6
    {
        let tm  =  dtTimeArr[4].components(separatedBy: ":")
        if tm.count==3
        {
            return tm[0] + ":" + tm[1] + " " + dtTimeArr[5]
        }
    }
    return newdate
}

func convertTimestamp(serverTimestamp: Double) -> String {
    let x = serverTimestamp / 1000
    let date = NSDate(timeIntervalSince1970: x)
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter.string(from: date as Date)
}

func convertTimestampNew(serverTimestamp: Double) -> Date {
    let x = serverTimestamp / 1000
    let date = NSDate(timeIntervalSince1970: x)
    let formatter = DateFormatter()
    
    formatter.dateFormat = "d.' 'MMM' 'yyyy' 'hh':'mm' 'a' 'Z'"
    let timeZone : TimeZone = TimeZone.init(secondsFromGMT: 1790)!
    formatter.timeZone = timeZone
    return formatter.date(from: formatter.string(from: date as Date))!
}

func getNewDate(dt: Date) -> String {
    let formatter = DateFormatter()
    
    formatter.dateFormat = "d.' 'MMM' 'yyyy'"
    formatter.timeZone = TimeZone.current
    return formatter.string(from: dt as Date)
}

func getNewTime(dt: Date) -> String {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "d.' 'MMM' 'yyyy' 'hh':'mm' 'a' 'Z'"
    let timeZone : TimeZone = TimeZone.init(secondsFromGMT: 1790)!
    formatter.timeZone = timeZone
   // print(formatter.string(from: dt as Date))
    let time = formatter.string(from: dt as Date)
    let timArr  = time.components(separatedBy: " ")
   // print(timArr)
    if(timArr.count > 0)
    {
        return "\(timArr[3])\(timArr[4].lowercased())"
    }
    return ""
}

func convertDateToTimeStamp(date:String) -> Int {
    let dfmatter = DateFormatter()
    dfmatter.dateFormat="dd MMM yyyy"
    let date = dfmatter.date(from: date)
    let dateStamp:TimeInterval = date!.timeIntervalSince1970
    let dateSt:Int = Int(dateStamp)
    return dateSt
}


func ampm(tm:String) -> String
{
    return tm
    /*
    if (tm == "IST")
    {
      return tm
    }
    let timeArr : [String] = tm.components(separatedBy: ":")
    var hr : Int
    hr = Int(timeArr[0])!
    
    if hr>12
    {
        hr =  hr-12
        return String (hr) + ":" + timeArr[1] + " " + "PM"
    }
    else
    {
        return timeArr[0] + ":" + timeArr[1] + " " + "AM"
    }
 */
}
func localToUTC(date:String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm a"
    dateFormatter.calendar = NSCalendar.current
    dateFormatter.timeZone = TimeZone.current
    
   if let dt = dateFormatter.date(from: date)
   {
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    dateFormatter.dateFormat = "H:mm:ss"
    return dateFormatter.string(from: dt)
   }
    else
   {
    return date
    }

}

func UTCToLocal(date:String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "H:mm:ss"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    
   if let dt = dateFormatter.date(from: date)
   {
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = "h:mm a"
    
    return dateFormatter.string(from: dt)
    }
    else
   {
    return date
    
    }
}
func converTimestampToDate(timeStamp:Double) -> String {
    let date = Date(timeIntervalSince1970: timeStamp)
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "dd-MMM" //Specify your format that you want
   return dateFormatter.string(from: date)

}
func converTimestampToFullDate(timeStamp:Double) -> String {
    let date = Date(timeIntervalSince1970: timeStamp)
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "dd MMM,yyyy" //Specify your format that you want
    return dateFormatter.string(from: date)
    
}
//func hideIndicator(){
//    DispatchQueue.main.async {
//        activityIndicator.stopAnimating()
//        container.removeFromSuperview()
//    }
//
//}

func converTimestampToTime(timeStamp:Double) -> String {
    let date = Date(timeIntervalSince1970: timeStamp)
    
//    let dateFormatter = DateFormatter()
//    dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
//    dateFormatter.locale = NSLocale.current
//    dateFormatter.dateFormat = "hh:mm a" //Specify your format that you want
    return date.timeAgoSinceDate()
    
}



func generateMsgId(length: Int) -> String {
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    
    var randomString = ""
    
    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    
    return randomString
}

func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
    let blue = CGFloat(rgbValue & 0xFF)/256.0
    return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
}
func imageToBase64(image:UIImage){
    let imageData:NSData = image.pngData()! as NSData
    let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
   // print(strBase64)

}

func AlertMsg(Msg : String, title : String, vc:UIViewController)
{
    let alert = UIAlertController(title: title, message: Msg, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style:.default, handler: nil))
    vc.present(alert, animated: false, completion:nil)
   
//    let tr = CATransition()
//    tr.duration = 0.15
//    tr.type = kCATransitionMoveIn
//    tr.subtype = kCATransitionFromBottom
//    vc.view.window?.layer.add(tr, forKey: kCATransition)
//    vc.present(alert, animated: false)
    
    
//    let transition = CATransition()
//    transition.duration = 0.5
//    transition.type = kCATransitionPush
//    transition.subtype = kCATransitionFromTop
//    transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
//    alert.view.frame.origin = CGPoint.zero
//    alert.view.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
//
//    vc.present(alert, animated: false,completion: { () in print("Done🔨")
//
//        alert.view.transform = CGAffineTransform.identity
//        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
//            alert.view.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
//        }) { (animationCompleted: Bool) -> Void in
//        }
//
//        //alert.view.transform = CGAffineTransform.identity
//         //alert.view.window!.layer.add(transition, forKey: kCATransition)
//    })
//
    
    // return
    
}
func AlertWithAction(Msg : String, title : String, vc:UIViewController)
{
    let alert = UIAlertController(title: title, message: Msg, preferredStyle: UIAlertController.Style.alert)
    let alertController = UIAlertController(title: title, message: Msg, preferredStyle: .alert)

       // Create the actions
    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
           UIAlertAction in
        dismissController(vc: vc)
        
       }
       // Add the actions
       alertController.addAction(okAction)

       // Present the controller
    vc.present(alertController, animated: true, completion: nil)
}


func encodeToBase64String(image:UIImage)->String{
    let imageData = image.pngData()
    var strBase64 = imageData?.base64EncodedString(options: .lineLength64Characters)
    strBase64 = strBase64?.replacingOccurrences(of: "+", with: "%2B")
    strBase64 = strBase64?.trimmingCharacters(in: .whitespaces)
    return strBase64!
}

func decodeBase64ToImage(strBase64:String)->UIImage{
    let dataDecoded : Data = Data(base64Encoded: strBase64, options: .ignoreUnknownCharacters)!
    let decodedimage = UIImage(data: dataDecoded)
    return decodedimage!
}
func SetCustomNavigation(navVC:UINavigationController)
{
     navVC.navigationBar.barTintColor = UIColor(red: 60.0/255.0, green: 60/255.0, blue: 60/255.0, alpha: 1.0)

    
}

func getUniqueId()->String
{
    
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    var randomString = ""
    for _ in 0 ..< 15 {
        let rand = arc4random_uniform(15)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    return randomString
}
func thumbCreator(size: Int, imgUrl:String,isNew :Bool = false)->String
{
    var thumbImg = ""
    
    thumbImg = imgUrl.replacingOccurrences(of: " ", with: "%20")
    if(size == 0)
    {
        return thumbImg  
    }
    thumbImg = thumbImg.replacingOccurrences(of: ".jpg", with: "_thumb\(size).jpg")
    thumbImg = thumbImg.replacingOccurrences(of: ".png", with: "_thumb\(size).png")
    thumbImg = thumbImg.replacingOccurrences(of: ".bmp", with: "_thumb\(size).bmp")
    if (isNew == true)
    {
        return "\(thumbImg)?\(getUniqueId())"
    }
    return thumbImg
}
func LetterSpacing(lbl:UILabel){
    
    let attributedString = NSMutableAttributedString(string: lbl.text!)
    attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
    lbl.attributedText = attributedString
    
}
func isKeyPresentInUserDefaults(key: String) -> Bool {
    return UserDefaults.standard.object(forKey: key) != nil
}
//func RatingView(View:CosmosView)
//{
//            View.settings.updateOnTouch = true
//            View.settings.fillMode = .full
//            View.settings.fillMode = .half
//            View.settings.fillMode = .precise
//           // View.settings.starSize = 25
//            View.settings.starMargin = 5
//            //View.rating = 4
//            View.settings.filledColor =  UIColorFromHex(rgbValue: 0x6BB7E5, alpha: 1.0)
//            View.settings.emptyBorderColor = UIColorFromHex(rgbValue: 0x6BB7E5, alpha: 1.0)
//            View.settings.filledBorderColor =  UIColorFromHex(rgbValue: 0x6BB7E5, alpha: 1.0)
//            View.settings.minTouchRating = 0;
//            View.settings.emptyBorderWidth = 1.5
//    
////            View.didFinishTouchingCosmos = {
////                rating in
////                RattingValue = rating
////                //print(self.RattingValu e)
////            }
////            View.didTouchCosmos = {
////                rating in
////                RattingValue = rating
////            }
//
//}
func goToNextVcThroughNavigation < T: UIViewController>(currentVC: UIViewController, nextVCname: String, nextVC: T.Type){
    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: nextVCname) as? T
    currentVC.navigationController?.pushViewController(vc!, animated: true)
}
func openPopUp < T: UIViewController>(currentVC: UIViewController, nextVCname: String, nextVC: T.Type){
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let pvc = storyboard.instantiateViewController(withIdentifier: nextVCname) as? T
    pvc?.modalPresentationStyle = UIModalPresentationStyle.custom
    pvc?.transitioningDelegate = currentVC as? UIViewControllerTransitioningDelegate
    pvc?.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    currentVC.navigationController?.present(pvc!, animated: true, completion: nil)
}
func openOrderDetailPopUp (currentVC: UIViewController,data:String){
//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//    let pvc = storyboard.instantiateViewController(withIdentifier: "MyorderDetailViewController") as? MyorderDetailViewController
//    pvc?.modalPresentationStyle = UIModalPresentationStyle.custom
//    pvc?.transitioningDelegate = currentVC as? UIViewControllerTransitioningDelegate
//    pvc?.order_id = data
//    pvc?.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
//    currentVC.navigationController?.present(pvc!, animated: true, completion: nil)
}




func goToNextVc< T: UIViewController>(currentVC: UIViewController,nextVCname: String, nextVC: T.Type) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var controller: UIViewController!
    controller = storyboard.instantiateViewController(withIdentifier: nextVCname) as? T
    let nc = UINavigationController(rootViewController: controller)
    currentVC.navigationController?.present(nc, animated: true, completion: nil)
}
//func goToStaticPages(currentVC: UIViewController,page_type: String) {
//    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "StaticPagesViewController") as! StaticPagesViewController
//    vc.page_type = page_type
//    let nc = UINavigationController(rootViewController: vc)
//    currentVC.revealViewController().pushFrontViewController(nc, animated: true)
//}


func goBack(vc:UIViewController){
vc.navigationController?.popViewController(animated: true)
    
}
func isValidEmail(email:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: email)
}
func emailAndPasswordValidation (email:String,password:String,vc:UIViewController) -> Bool{
    if (email == "") {
        AlertMsg(Msg: "Please enter username", title: "Alert!", vc: vc)
                return false
    }
    else if (isValidEmail(email: email) == false) {
        showToast(message: "Please enter valid email", vc: vc)
        return false
    }
    else if (password == ""){
        AlertMsg(Msg:  "Please enter password", title: "Alert!", vc: vc)
        return false
    }
 return true
}
func newPetValidation (petImg:UIImage,petName:String,aboutPet:String,petDob:String,vc:UIViewController) -> Bool{
    if petImg == UIImage(named: "placeholder"){
        showToast(message: "Please choose your pet image", vc: vc)
        return false
    }
    if (petName == "") {
        showToast(message: "Please enter pet name", vc: vc)
        return false
    }
    else if (petDob == ""){
        showToast(message: "Please enter pet date of birth", vc: vc)
        return false
    }
    else if (aboutPet == ""){
        showToast(message: "Please enter about your pet", vc: vc)
        return false
    }

    return true
}
func createGroupPetValidation (groupImg:UIImage,groupName:String,vc:UIViewController) -> Bool{
    if groupImg == UIImage(named: "placeholder"){
        showToast(message: "Please choose your group image", vc: vc)
        return false
    }
   else if (groupName == "") {
        showToast(message: "Please enter group name", vc: vc)
        return false
    }
    return true
}


func emailValidation (email:String,vc:UIViewController) -> Bool{
    if (email == "") {
        showToast(message: "Please enter email", vc: vc)

        return false
    }
    else if (isValidEmail(email: email) == false) {
        showToast(message: "Please enter valid email", vc: vc)

        return false
    }
    return true
}
func resetPasswordValidation (otp:String ,email:String,password:String,vc:UIViewController) -> Bool{
    if (otp == "") {
        showToast(message: "Please enter otp", vc: vc)

        return false
    }
    else if (email == "") {
        showToast(message: "Please enter email", vc: vc)
        return false
    }
    else if (isValidEmail(email: email) == false) {
        showToast(message: "Please enter email", vc: vc)
        return false
    }
    else if (password == ""){
        showToast(message: "Please enter password", vc: vc)

        return false
    }
    return true
}

func changePasswordValidation (oldPassword:String,password:String,confirmPassword:String,vc:UIViewController) -> Bool{
    
    if oldPassword == "" {
        AlertMsg(Msg: "Please enter password", title: "Alert!", vc: vc)
        return false
    }
    else if (password == ""){
        AlertMsg(Msg: "Please enter password", title: "Alert!", vc: vc)
        return false
    }
    else if (confirmPassword == ""){
        AlertMsg(Msg: "Please enter confirm password", title: "Alert!", vc: vc)
        return false

    }
    else if (password != confirmPassword) {
        AlertMsg(Msg: "Password and confirm password are not match", title: "Alert!", vc: vc)
        return false

    }
    return true
}
func loginValidation (userName:String,password:String,vc:UIViewController) -> Bool{
    
    if userName == "" {
        AlertMsg(Msg: "Please enter username", title: "Alert!", vc: vc)
        return false
    }
    else if (password == ""){
        AlertMsg(Msg: "Please enter password", title: "Alert!", vc: vc)
        return false
    }
    return true
}

func createAccountValidation (firstName:String ,email:String,password:String,lastName:String,dob:String, vc:UIViewController) -> Bool{
    if (firstName == "") {
        AlertMsg(Msg: "Please enter your first name", title: "Alert!", vc: vc)
        return false
    }
    else if (lastName == "") {
        AlertMsg(Msg: "Please enter your last name", title: "Alert!", vc: vc)
        return false
    }
    else if (email == "") {
        AlertMsg(Msg: "Please enter your email", title: "Alert!", vc: vc)
        return false
    }
    else if (isValidEmail(email: email) == false) {
        AlertMsg(Msg: "Please enter valid email", title: "Alert!", vc: vc)

        return false
    }
    else if (password == ""){
        AlertMsg(Msg: "Please enter your password", title: "Alert!", vc: vc)
        return false
    }
    else if (dob == ""){
        AlertMsg(Msg: "Please enter you date of birth", title: "Alert!", vc: vc)

        return false
    }

    

    return true
}
func moreInfoValidation (mobile:String,zipCode:String,gender:String,petanimal:String, vc:UIViewController) -> Bool{
     if (mobile == "") {
        showToast(message: "Please enter your mobile number", vc: vc)
        return false
    }
    else if (zipCode == "") {
        showToast(message: "Please enter your zipcode", vc: vc)
        return false
    }
    else if (gender == "") {
        showToast(message: "Please choose your gender", vc: vc)
        
        return false
    }
    else if (petanimal == ""){
        showToast(message: "Please enter your favourite pet", vc: vc)
        
        return false
    }
    
    return true
}
func newMomentValidation (petabout:String,pet_type:String,pet_category:String,location:String, vc:UIViewController) -> Bool{
    if (petabout == "" || petabout == "Say something") {
        showToast(message: "Please enter about your post", vc: vc)
        return false
    }
    else if (pet_type == "") {
        showToast(message: "Please select pet type", vc: vc)
        return false
    }
    else if (pet_category == "") {
        showToast(message: "Please choose pet category", vc: vc)
        
        return false
    }
    else if (location == ""){
        showToast(message: "Please add location", vc: vc)
        
        return false
    }
    
    return true
}


func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
//func hideIndicator(){
//    DispatchQueue.main.async {
//        activityIndicator.stopAnimating()
//        container.removeFromSuperview()
//    }
//
//}
func tableViewReloadInMainThread (tableView:UITableView){
    DispatchQueue.main.async {
    tableView.reloadData()
    }

}
func collectinViewReloadInMainThread (collectinView:UICollectionView){
    DispatchQueue.main.async {
        collectinView.reloadData()
    }
    
}

func showToast(message:String,vc:UIViewController){
    // Generate top floating entry and set some properties
    var attributes = EKAttributes.topFloat
    //        attributes.entryBackground = .gradient(gradient: .init(colors: [.orange, .orange], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
    attributes.entryBackground = .color(color: .white)
        attributes.displayDuration = 3

    attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
    attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
    attributes.statusBar = .dark
    attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
    attributes.positionConstraints.maxSize = .init(width: .constant(value: vc.view.frame.size.width), height: .intrinsic)

    let title = EKProperty.LabelContent(text: "Coco Cubano", style: .init(font: UIFont.boldSystemFont(ofSize: 16), color: UIColor.white))
    let description = EKProperty.LabelContent(text: message, style: .init(font: UIFont.boldSystemFont(ofSize: 14), color: UIColor.white))
    let image = EKProperty.ImageContent(image: UIImage(named: "logoone")!, size: CGSize(width: 40, height: 40))
    let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
    let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)

    let contentView = EKNotificationMessageView(with: notificationMessage)
    SwiftEntryKit.display(entry: contentView, using: attributes)

}
//func logOutFromApp(vc:UIViewController , userName:String) {
//        // Generate textual content
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    var attributes = EKAttributes.centerFloat
//    attributes.entryBackground = .color(color: .white)
//    attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
//    attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
//    attributes.statusBar = .dark
//    attributes.entryInteraction = .absorbTouches
//    attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
//    attributes.displayDuration = .infinity
//    attributes.positionConstraints.maxSize = .init(width: .constant(value: vc.view.frame.size.width), height: .intrinsic)
//        let title = EKProperty.LabelContent(text: userName, style: .init(font: UIFont.boldSystemFont(ofSize: 14), color: UIColor.black))
//        let description = EKProperty.LabelContent(text: "Are You Sure Want to Log Out?".localizableString(loc: appDelegate.loclizeStr), style: .init(font: UIFont.boldSystemFont(ofSize: 14), color: UIColor.black))
//        let image = EKProperty.ImageContent(imageName: "AppLogo", size: CGSize(width: 35, height: 35), contentMode: .scaleAspectFit)
//        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
//
//        // Generate buttons content
//        let buttonFont = UIFont.boldSystemFont(ofSize: 14)
//
//        // Close button - Just dismiss entry when the button is tapped
//        let closeButtonLabelStyle = EKProperty.LabelStyle(font: buttonFont, color: hexStringToUIColor(hex: Constants.bg_color_code))
//        let closeButtonLabel = EKProperty.LabelContent(text: "Not Now".localizableString(loc: appDelegate.loclizeStr), style: closeButtonLabelStyle)
//        let closeButton = EKProperty.ButtonContent(label: closeButtonLabel, backgroundColor: .clear, highlightedBackgroundColor: hexStringToUIColor(hex: Constants.bg_color_code)) {
//            SwiftEntryKit.dismiss()
//        }
//        // Ok Button - Make transition to a new entry when the button is tapped
//        let okButtonLabelStyle = EKProperty.LabelStyle(font: buttonFont, color:hexStringToUIColor(hex: Constants.bg_color_code))
//        let okButtonLabel = EKProperty.LabelContent(text: "Yes".localizableString(loc: appDelegate.loclizeStr), style: okButtonLabelStyle)
//        let okButton = EKProperty.ButtonContent(label: okButtonLabel, backgroundColor: .clear, highlightedBackgroundColor: hexStringToUIColor(hex: Constants.bg_color_code)) {
////            userLogOut(view: vc)
//            goToNextVcThroughNavigation(currentVC: vc, nextVCname: "ViewController", nextVC: ViewController.self)
//            userDefault.shared.removeData(key: Constants.user_id)
//            userDefault.shared.removeData(key: Constants.lang_code)
//            SwiftEntryKit.dismiss()
//        }
//        let buttonsBarContent = EKProperty.ButtonBarContent(with: closeButton, okButton, separatorColor: UIColor.lightGray, expandAnimatedly: true)
//
//        // Generate the content
//        let alertMessage = EKAlertMessage(simpleMessage: simpleMessage, imagePosition: .left, buttonBarContent: buttonsBarContent)
//
//        let contentView = EKAlertMessageView(with: alertMessage)
//
//        SwiftEntryKit.display(entry: contentView, using: attributes)
//    }
func showImgWithLink (imgUrl:String , imgView:UIImageView){
    var imageView : UIImageView = imgView
    if imgUrl != "" {
        let url = URL(string: imgUrl)
        let placeHolderImage = UIImage(named: "no_image")
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url, placeholder: placeHolderImage)
    }
}
//func showUserImgWithLink (imgUrl:String , imgView:UIImageView){
//    imgView.layer.cornerRadius = 10
//    if imgUrl == "user_profile/default.png" || imgUrl == "userProfile/default.png"  {
//        imgView.image = UIImage(named: "placeholderImage")
//    }else{
//        let url = URL(string:imgUrl)
//        let placeHolderImage = UIImage(named: "placeholder")
//        imgView.kf.setImage(with: url, placeholder: placeHolderImage)
//    }
//
//}
func convertDateFormate(date:String) -> String {
    var dobDate = ""
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    if let updatedDob = dateFormatter.date(from: date){
        dateFormatter.dateFormat = "dd MMM yyyy"
        dobDate = dateFormatter.string(from: updatedDob)
    }
    return dobDate
}
func dismissController(vc:UIViewController){
    vc.dismiss(animated: true, completion: nil)
}
func makeImageUrlToImage (url:String?) -> UIImage{
    var image = UIImage ()
    if let imageEndpoint = url {
        let urlString = URL(string:imageEndpoint)
        if let imageUrl = urlString{
        if let data = try? Data(contentsOf: imageUrl)
        {
            image = UIImage(data: data)!
        }
    }
    }
    return image
}
func openWhatsApp(vc:UIViewController, orderNumber:String , is_menu : Bool){
    var urlWhats = ""
    if is_menu {
        urlWhats = "whatsapp://send?phone=+919811775778&abid=12354&text=Hello"
    }else{
        urlWhats = "whatsapp://send?phone=+919811775778&abid=12354&text=Hello, this is my order number \(orderNumber)"
    }
    if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
        if let whatsappURL = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(whatsappURL) {
                UIApplication.shared.openURL(whatsappURL)
            } else {
                print("Install Whatsapp")
                showToast(message: "Please Install Whatsapp In Your Phone", vc: vc)
            }
        }
    }
}

//func userLogOut(view:UIViewController) {
//    if isInternetAvailable() {
//        let req = NetworkManger.api.getRequest(reqType: .log_out, responseType: GeneralResponse.self)
//        req.done { (response:BaseResponse<GeneralResponse>) in
//
//            let msg = response.message
//            let status = response.status
//            if status == Constants.response_success{
//                print(msg)
//            }else{
//                print(msg)
//            }
//
//            }.catch { (error) in
//                print(error)
//        }
//
//    }else{
//        showToast(message: Constants.Check_Connection, vc: view)
//    }
//}
func setUpHamburgerMenu (vc:UIViewController , menuButton: UIBarButtonItem){
//    if vc.revealViewController() != nil {
//        print("Sw reveal not ! nulll ")
//        menuButton.target = vc.revealViewController()
//        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
//        vc.view.addGestureRecognizer(vc.revealViewController().panGestureRecognizer())
//    }else{
//        print("Sw reveal nulll ")
//    }
    
}
func loadYoutubeVideo(videoLink:String , videoView :WKWebView ){
    //          let htmlString = "<iframe width=\"\(self.view.frame.size.width-40)\" height=\"\(self.videoView.frame.size.height)\" src=\"\(videoLink)\" frameborder=\"0\" allowfullscreen></iframe>"
    //            videoView.loadHTMLString(htmlString, baseURL: nil)
    videoView.configuration.mediaTypesRequiringUserActionForPlayback = .all
    videoView.configuration.allowsInlineMediaPlayback = false
    videoView.configuration.allowsInlineMediaPlayback = false
    let myURL = URL(string:videoLink)
    let youtubeRequest = URLRequest(url: myURL!)
    videoView.load(youtubeRequest)
    
}

func presentViewBottomToTop<T : UIViewController>(currentVc:UIViewController,vcIdentifier:String,nextVc:T.Type){
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let dstvc = storyBoard.instantiateViewController(withIdentifier: vcIdentifier) as! T
    let transition:CATransition = CATransition()
    transition.duration = 0.5
    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    transition.type = CATransitionType.push
    transition.subtype = CATransitionSubtype.fromTop
    currentVc.navigationController!.view.layer.add(transition, forKey: kCATransition)
    currentVc.navigationController?.pushViewController(dstvc, animated: true)
}
func closeView(currentVc:UIViewController) {
    let transition = CATransition()
    transition.duration = 0.5
    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    transition.type = CATransitionType.reveal
    transition.subtype = CATransitionSubtype.fromBottom
    currentVc.navigationController?.view.layer.add(transition, forKey: nil)
    _ = currentVc.navigationController?.popViewController(animated: false)
}

func collectionViewEqualSpacingCell(numberOfCells:Int,collectionView:UICollectionView,collectionViewLayout: UICollectionViewLayout)->Int{
    let noOfCellsInRow = numberOfCells
    
    let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
    
    let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
    
    let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
    return size

}
func goToPetProfileScreen(pet_id:String, vc:UIViewController){
//    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//    let dstvc = storyBoard.instantiateViewController(withIdentifier: "PetProfileViewController") as! PetProfileViewController
//    dstvc.pet_id = pet_id
//    let transition:CATransition = CATransition()
//    transition.duration = 0.5
//    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//    transition.type = CATransitionType.push
//    transition.subtype = CATransitionSubtype.fromTop
//    vc.navigationController!.view.layer.add(transition, forKey: kCATransition)
//    vc.navigationController?.pushViewController(dstvc, animated: true)
}
func generateThumbnail(path: URL) -> UIImage? {
    do {
        let asset = AVURLAsset(url: path, options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
        let thumbnail = UIImage(cgImage: cgImage)
        return thumbnail
    } catch let error {
        print("*** Error generating thumbnail: \(error.localizedDescription)")
        return nil
    }
}
//func gotoCommentsView(post_id:String,vc:UIViewController){
//    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//    let dstvc = storyBoard.instantiateViewController(withIdentifier: "PostCommentViewController") as! PostCommentViewController
//    dstvc.postId = post_id
//    let transition:CATransition = CATransition()
//    transition.duration = 0.5
//    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//    transition.type = CATransitionType.push
//    transition.subtype = CATransitionSubtype.fromTop
//    vc.navigationController!.view.layer.add(transition, forKey: kCATransition)
//    vc.navigationController?.pushViewController(dstvc, animated: true)
//}
//func gotoVideoPlayer(post_id:String,vc:UIViewController,urlString:String){
//    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//    let dstvc = storyBoard.instantiateViewController(withIdentifier: "PostVideoPlayerViewController") as! PostVideoPlayerViewController
//    dstvc.postId = post_id
//    dstvc.video_urlString = urlString
//    let transition:CATransition = CATransition()
//    transition.duration = 0.5
//    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//    transition.type = CATransitionType.push
//    transition.subtype = CATransitionSubtype.fromTop
//    vc.navigationController!.view.layer.add(transition, forKey: kCATransition)
//    vc.navigationController?.pushViewController(dstvc, animated: true)
//}
//func gotoMymessageview(vc:UIViewController){
//    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//    let dstvc = storyBoard.instantiateViewController(withIdentifier: "MymessageViewController") as! MymessageViewController
//    let transition:CATransition = CATransition()
//    transition.duration = 0.5
//    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//    transition.type = CATransitionType.push
//    transition.subtype = CATransitionSubtype.fromTop
//    vc.navigationController!.view.layer.add(transition, forKey: kCATransition)
//    vc.navigationController?.pushViewController(dstvc, animated: true)
//}
//func goToChatview(vc:UIViewController,receiver_userId:String,receiverName:String,receiver_image:String){
//    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//    let dstvc = storyBoard.instantiateViewController(withIdentifier: "ChatsViewController") as! ChatsViewController
//    dstvc.receiver_id = receiver_userId
//    dstvc.receiver_name = receiverName
//    dstvc.receiver_image = receiver_image
//    let transition:CATransition = CATransition()
//    transition.duration = 0.5
//    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//    transition.type = CATransitionType.push
//    transition.subtype = CATransitionSubtype.fromTop
//    vc.navigationController!.view.layer.add(transition, forKey: kCATransition)
//    vc.navigationController?.pushViewController(dstvc, animated: true)
//}
//

func getReadableDate(timeStamp: TimeInterval) -> String? {
    let date = Date(timeIntervalSince1970: timeStamp)
    let dateFormatter = DateFormatter()
    
    if Calendar.current.isDateInTomorrow(date) {
        return "Tomorrow"
    } else if Calendar.current.isDateInYesterday(date) {
        return "Yesterday"
    } else if dateFallsInCurrentWeek(date: date) {
        if Calendar.current.isDateInToday(date) {
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        } else {
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: date)
        }
    } else {
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
}


func dateFallsInCurrentWeek(date: Date) -> Bool {
    let currentWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: Date())
    let datesWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: date)
    return (currentWeek == datesWeek)
}
func goNextVcWithModalyPresent<T:UIViewController>(vc:UIViewController,nextVc_id:String,next_vc:T.Type){
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let dstvc = storyBoard.instantiateViewController(withIdentifier: nextVc_id) as! T
    let transition:CATransition = CATransition()
    transition.duration = 0.5
    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    transition.type = CATransitionType.push
    transition.subtype = CATransitionSubtype.fromTop
    vc.navigationController!.view.layer.add(transition, forKey: kCATransition)
    vc.navigationController?.pushViewController(dstvc, animated: true)
}


func SharePostActivity(msg:String?, image:UIImage?, url:String?, sourceRect:CGRect?,vc:UIViewController){
    var objectsToShare = [AnyObject]()
    
    if let url = url {
        objectsToShare = [url as AnyObject]
    }
    
    if let image = image {
        objectsToShare = [image as AnyObject]
    }
    
    if let msg = msg {
        objectsToShare = [msg as AnyObject]
    }
    
    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
    activityVC.modalPresentationStyle = .popover
    activityVC.popoverPresentationController?.sourceView = vc.view
    if let sourceRect = sourceRect {
        activityVC.popoverPresentationController?.sourceRect = sourceRect
    }
    
    vc.present(activityVC, animated: true, completion: nil)
}
func decode_emoji(_ s: String) -> String? {
    let data = s.data(using: .utf8)!
    return String(data: data, encoding: .nonLossyASCII)
}
func encode_emoji(_ s: String) -> String {
    let data = s.data(using: .nonLossyASCII, allowLossyConversion: true)!
    return String(data: data, encoding: .utf8)!
}
func encodedUrl(from string: String) -> String? {
    
    // Remove preexisting encoding
    guard let decodedString = string.removingPercentEncoding,
        // Reencode, to revert decoding while encoding missed characters
        let percentEncodedString = decodedString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            // Coding failed
            return "Uncensored message"
    }
    
    // Create URL from encoded string, or nil if failed
    return percentEncodedString
}



func decodedUrl(from string: String) -> String? {
    
    return string.removingPercentEncoding
    
}



