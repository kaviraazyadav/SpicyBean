//
//  extensions.swift
//  BentChair
//
//  Created by kavi yadav on 31/01/19.
//  Copyright © 2019 kavi yadav. All rights reserved.
//

import Foundation
import UIKit
//import ExpandableLabel
enum VerticalLocation: String {
    case bottom
    case top
}

extension UIView {
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius

        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
      }
    
    func addShadow(location: VerticalLocation, color: UIColor, opacity: Float, radius: CGFloat) {
        switch location {
        case .bottom:
             addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -10), color: color, opacity: opacity, radius: radius)
        }
    }

    func addShadow(offset: CGSize, color: UIColor, opacity: Float, radius: CGFloat) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }


    func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    func customView() {
        self.layer.cornerRadius = 25
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height:1)
        self.layer.shadowOpacity = 0.4
    }
    func setCardView(){
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height:1)
        self.layer.shadowOpacity = 0.4
    }
    func setBottomShadowToView(){
        self.layer.cornerRadius = 0.0
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height:2)
        self.layer.shadowOpacity = 1
    }
    
    func circleView() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height/2
    }
    func viewCircleWithShadow(){
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height:1)
        self.layer.shadowOpacity = 1
    }
    func viewBorder(radius:CGFloat , color: UIColor ,borderWidth:CGFloat) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = radius
    }
    func circleViewWithShadow(){
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height/2
                    self.layer.borderWidth = 1
        self.layer.borderColor = hexStringToUIColor(hex: "#fcb419").cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 0.4
        self.clipsToBounds = true
        
    }
    func applyGradient()  {
        self.applyGradient(colours: [hexStringToUIColor(hex: "#20b9ae") , hexStringToUIColor(hex: "#006fd6")], locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = [0.0 , 1.0]
        self.layer.insertSublayer(gradient, at: 0)
    }
    func drawDiagonal(_ rect: CGRect) {
        // Drawing code
        // Get Height and Width
        let layerHeight = layer.frame.height
        let layerWidth = layer.frame.width
        // Create Path
        let bezierPath = UIBezierPath()
        //  Points
        //        let pointA = CGPoint(x: 0, y: 0)
        //        let pointB = CGPoint(x: layerWidth, y: 0)
        //        let pointC = CGPoint(x: layerWidth, y: layerHeight)
        //        let pointD = CGPoint(x: 0, y: layerHeight*2/3)
        let pointA = CGPoint(x: 0, y: 0)
        let pointB = CGPoint(x: layerWidth, y: 0)
        let pointC = CGPoint(x: layerWidth, y: layerHeight*2/3)
        let pointD = CGPoint(x: 0, y: layerHeight)
        
        // Draw the path
        bezierPath.move(to: pointA)
        bezierPath.addLine(to: pointB)
        bezierPath.addLine(to: pointC)
        bezierPath.addLine(to: pointD)
        bezierPath.close()
        // Mask to Path
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        layer.mask = shapeLayer
    }
    
    func makeViewCircle()  {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
    // Two corner round
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    //    func dottedView(){
    //        var yourViewBorder = CAShapeLayer()
    //        yourViewBorder.strokeColor = hexStringToUIColor(hex: Constants.bg_color_code).cgColor
    //        yourViewBorder.lineDashPattern = [5, 5]
    //        yourViewBorder.frame = self.bounds
    //        yourViewBorder.fillColor = nil
    //        yourViewBorder.path = UIBezierPath(rect: self.bounds).cgPath
    //        self.layer.addSublayer(yourViewBorder)
    //
    //    }
    
}
extension UIImageView{
    //    func setBorder()  {
    //        self.layer.borderWidth = 1
    //        self.layer.cornerRadius = 3.0
    //        self.layer.borderColor = UIColorFromHex(rgbValue: 13936768).cgColor
    //    }
    func addTapGesture(mySelect : Selector) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: mySelect)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGestureRecognizer)
        
    }
}
extension UILabel {
    func customLabel()  {
        self.font = UIFont(name:"Roboto-Regular", size:16.0)
    }
    func circle()  {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
    func circleLableWithoutBorder() {
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
    func labelCornerRadious() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
        
    }
    func textWidth() -> CGFloat {
        return UILabel.textWidth(label: self)
    }
    
    class func textWidth(label: UILabel) -> CGFloat {
        return textWidth(label: label, text: label.text!)
    }
    
    class func textWidth(label: UILabel, text: String) -> CGFloat {
        return textWidth(font: label.font, text: text)
    }
    
    class func textWidth(font: UIFont, text: String) -> CGFloat {
        let myText = text as NSString
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(labelSize.width)
    }
    
    
    
}
extension NSMutableAttributedString {
    
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        
        // Swift 4.2 and above
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)}
}

extension UIViewController {
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: 50, y: self.view.frame.size.height-180, width: self.view.frame.size.width - 100, height: 50))
        toastLabel.backgroundColor = hexStringToUIColor(hex: "#f1431d")
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.numberOfLines = 2
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 2.0, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    func customNvaBar(rgbValue:UInt32) {
        let logo = UIImage(named: "nav_bar_logo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        self.navigationController?.navigationBar.barTintColor = UIColorFromHex(rgbValue:rgbValue)
    }
    func customNvaBarWithTitle(rgbValue:UInt32,title : String) {
        self.navigationController?.navigationBar.barTintColor = UIColorFromHex(rgbValue:rgbValue)
        self.title = title
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white]
        
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    func customNavBarColor(){
        self.navigationController?.navigationBar.barTintColor = UIColorFromHex(rgbValue:16777215)
    }
    func goWithSegue(identifier:String){
        self.performSegue(withIdentifier: identifier, sender: nil)
        
    }
    
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension UIImageView {
    func makeImageCircle()  {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
    func cornerRadious() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
    }
    func circleImageWithBorder(){
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height/2
        self.layer.borderWidth = 5
        self.layer.borderColor = UIColor.white.cgColor
        self.clipsToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 0.4
        self.clipsToBounds = false
    }
    
}
extension UITextField {
    func makeCornerRound() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 20
    }
    
}
extension UICollectionView{
    func registerCollectionViewNibCell (nibName: String  , reUseIdentifire: String){
        self.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: reUseIdentifire)
    }
    func collectinViewReloadInMainThread (){
        DispatchQueue.main.async {
            self.reloadData()
        }
        
    }
}
extension UITableView {
    func tableViewReloadInMainThread (){
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    func reloadWithOutScroll() {
        let contentOffset = self.contentOffset
        self.reloadData()
        self.layoutIfNeeded()
        self.setContentOffset(contentOffset, animated: false)
    }
    
    func registerTableCellNib(nib:String ,identifier:String)  {
        let nib = UINib.init(nibName: nib, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
        
    }
    func updateHeaderViewHeight() {
        if let header = self.tableHeaderView {
            let newSize = header.systemLayoutSizeFitting(CGSize(width: self.bounds.width, height: 0))
            header.frame.size.height = newSize.height
        }
    }
    func refreshWithoutScrolling() {
        let contentOffset = self.contentOffset
        self.reloadData()
        self.layoutIfNeeded()
        self.setContentOffset(contentOffset, animated: false)
    }
    func reloadParticularCell(index:Int){
        let indexPath = IndexPath(item: index, section: 0)
        self.reloadRows(at: [indexPath], with: .fade)
    }
    
    
    
}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension String {
    // first letter capital
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    var decodeEmoji: String {
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        if data != nil {
            let valueUniCode = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue) as String?
            if valueUniCode != nil {
                return valueUniCode!
            } else {
                return self
            }
        } else {
            return self
        }
    }
    
    func trim()->String{
        return self.replacingOccurrences(of: "%", with: "")
    }
    func removeWhiteSpaces()-> String{
        return self.replacingOccurrences(of: " ", with: "")
        
    }
    
}
extension UIToolbar {
    
        func ToolbarPiker(mySelect : Selector) -> UIToolbar {
    
            let toolBar = UIToolbar()
    
            toolBar.barStyle = UIBarStyle.default
            toolBar.isTranslucent = true
            toolBar.tintColor = hexStringToUIColor(hex: Constants.bg_color_code)
            toolBar.sizeToFit()
    
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: mySelect)
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    
            toolBar.setItems([ spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            return toolBar
        }
    
}
public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
#if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,5":                                    return "iPhone 11 Pro Max"
            case "iPhone13,1":                                    return "iPhone 12 mini"
            case "iPhone13,2":                                    return "iPhone 12"
            case "iPhone13,3":                                    return "iPhone 12 Pro"
            case "iPhone13,4":                                    return "iPhone 12 Pro Max"
            case "iPhone14,4":                                    return "iPhone 13 mini"
            case "iPhone14,5":                                    return "iPhone 13"
            case "iPhone14,2":                                    return "iPhone 13 Pro"
            case "iPhone14,3":                                    return "iPhone 13 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad Mini 5"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
#elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
#endif
        }
        
        
        return mapToDevice(identifier: identifier)
    }()
    
}

extension UIScrollView {
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y,width: 1,height: self.frame.height), animated: animated)
        }
    }
    
    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    
    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
    
    
}
extension Notification.Name {
    static let add_miscPro_toCart = Notification.Name("add_miscPro_toCart")
    static let addOnPro_toShow = Notification.Name("addOnPro_toShow")
    static let addOnData_tocart = Notification.Name("addOnData_tocart")
    static let addOnData_toProductView = Notification.Name("addOnData_toProductView")
    static let addOnData_toSeacrhView = Notification.Name("addOnData_toSeacrhView")

    static let cart_data_from_productToHome = Notification.Name("cart_data_from_productToHome")
    static let searched_address = Notification.Name("searched_address")
    static let qr_code_scanned = Notification.Name("qr_code_scanned")


}
extension UIButton {
    func setTitle(title:String){
        self.setTitle(title, for: .normal)
    }
    func addPadingInTitle(){
        self.contentEdgeInsets = UIEdgeInsets(top: 5,left: 8,bottom: 5,right: 8)
    }
    
}
extension UITableViewCell{
    func selectedBackgroundColor(color:UIColor) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = color
        self.selectedBackgroundView = backgroundView
    }
}
extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

extension String {
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    // Get StringLength
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    public var withoutHtml: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }
        
        return attributedString.string
    }
    
    // Language Localize
    func localizableString(loc:String) -> String {
        let path = Bundle.main.path(forResource: loc, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    // html data to string
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    
}
extension Date {
    
    func timeAgoSinceDate() -> String {
        
        // From Time
        let fromDate = self
        
        // To Time
        let toDate = Date()
        
        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }
        
        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }
        
        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }
        
        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }
        
        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }
        
        return "a moment ago"
    }
}
//extension ExpandableLabel {
//    func makeLabelDynamic() {
//        self.numberOfLines = 3
//        self.collapsed = true
//        self.textAlignment = .justified
//        self.collapsedAttributedLink = NSAttributedString(string: "Read More",attributes: [NSAttributedString.Key.foregroundColor:UIColorFromHex(rgbValue: 13936768)])
//        self.expandedAttributedLink = NSAttributedString(string: "Read Less",attributes: [NSAttributedString.Key.foregroundColor:UIColorFromHex(rgbValue: 13936768)])
//        self.shouldCollapse = true
//    }
//}
extension UIColor {
    static let primary = UIColor(named: "primary")!
    static let secondary = UIColor(named: "secondary")!
    static let background = UIColor(named: "background")!
    static let placeholderBody = UIColor(named: "placeholderBody")!
    static let darkBody = UIColor(named: "darkBody")!
    static let separator = UIColor(named: "separator")!
    static let buttonShadow = UIColor(red: 27 / 255, green: 71 / 255, blue: 219 / 255, alpha: 0.3)
    static let primaryColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
    
}
extension UIImage {
    
    func cropped() -> UIImage? {
        let cropRect = CGRect(x: 0, y: 0, width: 30 * scale, height: 30 * scale)
        
        guard let croppedCGImage = cgImage?.cropping(to: cropRect) else { return nil }
        
        return UIImage(cgImage: croppedCGImage, scale: scale, orientation: imageOrientation)
    }
}
extension UITabBarController {
    func removeTabbarItemsText() {
        tabBar.items?.forEach {
            $0.title = ""
            $0.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
    }
}

