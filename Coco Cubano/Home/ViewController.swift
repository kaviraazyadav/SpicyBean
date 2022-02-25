//
//  ViewController.swift
//  Coco Cubano
//
//  Created by kavi yadav on 14/12/21.
//

import UIKit
import FSPagerView
import Kingfisher
var user_id = ""
var mode_of_delivery = ""
var table_number = ""
class ViewController: UIViewController,FSPagerViewDataSource,FSPagerViewDelegate {
    
    
    @IBOutlet weak var cat_btn: UIButton!
    @IBOutlet weak var tab_barView: UIView!
    @IBOutlet weak var tab_barImg: UIImageView!
    
    @IBOutlet weak var pagerView: FSPagerView!{
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
    
    @IBOutlet weak var searchViw: UIView!
    @IBOutlet weak var deliveryPickUpView: UIView!
    
    @IBOutlet weak var deliveryBtn: UIButton!
    
    @IBOutlet weak var pickUpBtn: UIButton!
    
    @IBOutlet weak var cat_coll: UICollectionView!
    
    @IBOutlet weak var pro_table: UITableView!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var bookTableImg: UIImageView!
    
    @IBOutlet weak var table_top: UIButton!
    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var badgeLbl: UILabel!
    
    @IBOutlet weak var searchBtn: UIButton!
    let count = 40
    var banner_list_arr = [BannerLists]()
    var category_list_arr = [CategoryLists]()
    var products_arr = [ProductLists]()
    var cart_lists = [CartProductLists]()
    
    var productQty = Int()
    var cartAmount = Double()
    var each_pro_price = Double()
    var cart_item = CartProductLists()
    var badge_count = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mode_of_delivery = "1"
        searchBtn.contentHorizontalAlignment = .left
        self.notificationHits()
        self.pickUpBtn.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let seconds = 2.0
        self.callBannerListApi(param: [:])
        self.callProductListApi(param: ["category_id":"122"])
        user_id = userDefault.shared.getUserId(key: Constants.user_id)
        if user_id != ""{
            self.callViewCartApi(param: ["user_id":user_id], from: "")
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.calllocationApi(param: ["user_id": user_id,
                                             "latitude": userDefault.shared.getuser_lat(key: Constants.user_lat),
                                             "longitude": userDefault.shared.getuser_long(key: Constants.user_long),])
            }
           
        }else {
            self.badgeLbl.text = "0"
        }
    }
    
    func notificationHits(){
        NotificationCenter.default.addObserver(self, selector: #selector(addOnProductsDatatoCart(notification:)), name: .addOnData_tocart, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(qr_data(notification:)), name: .qr_code_scanned, object: nil)
        
    }
    @objc func addOnProductsDatatoCart(notification:Notification)
    {
        print(notification.userInfo as Any)
        let data = notification.userInfo!["data"] as? [CartProductLists]
        print("reaction",data)
        if data != nil {
            for item in data! {
                self.cart_lists.append(item)
            }
            if user_id != ""{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.callViewCartApi(param: ["user_id":user_id], from: "addon")
                }
                
            }
            
        }
        
        
    }
    
    // QR DATA
    @objc func qr_data(notification:Notification)
    {
        print(notification.userInfo as Any)
        let data = notification.userInfo!["data"] as? String
        print("reaction",data)
        if data != ""{
            table_number = data ?? ""
        }
        else{
            // del btn activated
            self.deliveryBtn.backgroundColor = .white
            self.pickUpBtn.backgroundColor = .clear
            self.table_top.backgroundColor = .clear
            mode_of_delivery = "2"
        }
        
        
        
    }
    
    
    func update_table_cell(item_id:String){
        for (i, item) in self.products_arr.enumerated() {
            if let pro_id = item.id {
                if item_id == pro_id {
                    self.products_arr[i].is_pro_addedTo_cart = true
                    self.products_arr[i].pro_qty = "1"
                }
            }
            
        }
        self.pro_table.tableViewReloadInMainThread()
    }
    
    override func viewDidLayoutSubviews() {
        cat_btn.circleViewWithShadow()
        self.pagerView.viewBorder(radius: 10, color: .clear, borderWidth: 0)
        self.deliveryPickUpView.viewBorder(radius: 25, color: .clear, borderWidth: 0)
        self.deliveryBtn.viewBorder(radius: 22, color: .clear, borderWidth: 0)
        self.pickUpBtn.viewBorder(radius: 22, color: .clear, borderWidth: 0)
        self.table_top.viewBorder(radius: 22, color: .clear, borderWidth: 0)
        self.badgeLbl.layer.cornerRadius = self.badgeLbl.frame.width/2
        self.badgeLbl.layer.borderWidth = 1
        self.badgeLbl.layer.borderColor = hexStringToUIColor(hex: "#fcb419").cgColor
        self.badgeLbl.layer.masksToBounds = true
        searchViw.viewBorder(radius: 5, color: .clear, borderWidth: 0)
        
        self.bookTableImg.viewBorder(radius: 10, color: .clear, borderWidth: 0)
        self.setScrollContentInset()
        
    }
    
    func setScrollContentInset(){
        let deviceModel = UIDevice.modelName
        print(deviceModel)
        DispatchQueue.main.async {
            self.scrollView.contentInsetAdjustmentBehavior = .never
            let count = self.products_arr.count
//            self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + CGFloat (Double(count) * 120))
            self.tableViewHeight.constant = CGFloat (Double(count) * 120)
            self.contentViewHeight.constant = self.view.frame.size.height + self.tableViewHeight.constant - 950
        }
        
       
        
    }
    
    // Banner Api
    func callBannerListApi(param:[String:Any]){
        showActivityIndicator(uiView: self)
        let req = NetworkManger.api.postRequest(reqType:.banners, params: param, responseType: BannerResponse.self, vc: self)
        req.done { (response:BannerResponse) in
            hideActivityIndicator(uiView: self)
            print(response)
            let responseCode = response.responseCode
            let message = response.message ?? ""
            print(message)
            if responseCode == "0"{
                
                if let items = response.list{
                    self.banner_list_arr = items
                    self.createBanner()
                }
                
            }else{
                //AlertMsg(Msg: message, title: "Alert!", vc: self)
            }
        }.catch { (error) in
            print(error)
            hideActivityIndicator(uiView: self)
        }
    }
    
    // Product Api
    func callProductListApi(param:[String:Any]){
        showActivityIndicator(uiView: self)
        let req = NetworkManger.api.postRequest(reqType:.products, params: param, responseType: ProductsResponse.self, vc: self)
        req.done { (response:ProductsResponse) in
            hideActivityIndicator(uiView: self)
            print(response)
            let responseCode = response.responseCode
            let message = response.message ?? ""
            print(message)
            self.products_arr.removeAll()
            if responseCode == "0"{
                
                if let items = response.list{
                    self.products_arr = items
                    self.setScrollContentInset()
                    self.pro_table.tableViewReloadInMainThread()
                }
                
            }else{
                //                    AlertMsg(Msg: message, title: "Alert!", vc: self)
            }
        }.catch { (error) in
            print(error)
            hideActivityIndicator(uiView: self)
        }
    }
    
    // location Api
    func calllocationApi(param:[String:Any]){
//        showActivityIndicator(uiView: self)
        let req = NetworkManger.api.postRequest(reqType:.location, params: param, responseType: CommonResponse.self, vc: self)
        req.done { (response:CommonResponse) in
            hideActivityIndicator(uiView: self)
            print(response)
            let responseCode = response.responseCode
            let message = response.message ?? ""
            print(message)
            if responseCode == "0"{
                
            }else{
            }
        }.catch { (error) in
            print(error)
            hideActivityIndicator(uiView: self)
        }
    }
    
    func send_pro_to_cartServer(data:CartProductLists){
        let name = data.item_name ?? ""
        let price = data.sales_price ?? ""
        let qty = data.pro_qty ?? ""
        let id = data.id ?? ""
        let userId = userDefault.shared.getUserId(key: Constants.user_id)
        let catId = data.category_id ?? ""
        var addOnList = [String:Any]()
        var addonParam =  [[String:Any]]()
        if let add_on_data = data.item_list{
            for record in add_on_data {
                addOnList["addon_id"] = record.item_id
                addOnList["addon_qty"] = record.add_on_qty
                addOnList["addon_price"] = record.modifier_price
                addOnList["note"] = "sampe"
                addOnList["addon_name"] = record.modifier_name
                addonParam.append(addOnList)
            }
        }
        
        
        
        self.callAddToCartApi(param: ["user_id":userId,
                                      "productId":id,
                                      "productPrice":price,
                                      "product_quantity":qty,
                                      "opType":"0",
                                      "catId":catId,
                                      "product_name":name,
                                      "addon_list":addonParam])
    }
    // Add_to_cart Api
    func callAddToCartApi(param:[String:Any]){
        //            showActivityIndicator(uiView: self)
        let req = NetworkManger.api.postRequest(reqType:.addToCart, params: param, responseType: CommonResponse.self, vc: self)
        req.done { (response:CommonResponse) in
            hideActivityIndicator(uiView: self)
            print(response)
            let responseCode = response.responseCode
            let message = response.message ?? ""
            print(message)
            if responseCode == "0"{
                AlertMsg(Msg: message, title: "Message", vc: self)
                self.callViewCartApi(param: ["user_id":user_id], from: "")
            }else{
                AlertMsg(Msg: message, title: "Alert", vc: self)
            }
        }.catch { (error) in
            print(error)
            hideActivityIndicator(uiView: self)
        }
    }
    
    // View Cart Api
    func callViewCartApi(param:[String:Any],from:String){
        //            showActivityIndicator(uiView: self)
        let req = NetworkManger.api.postRequest(reqType:.view_cart, params: param, responseType: ViewCartResponse.self, vc: self)
        req.done { (response:ViewCartResponse) in
            hideActivityIndicator(uiView: self)
            print(response)
            let responseCode = response.responseCode
            let message = response.message ?? ""
            print(message)
            if responseCode == "0"{
                if let temp_count = response.count{
                    self.badge_count = "\(temp_count)"
                    self.badgeLbl.text = "\(temp_count)"
                }
                if from == "addon"{
                    AlertMsg(Msg: "Product updated successfully", title: "Message", vc: self)
                }
            }else{
                //                 AlertMsg(Msg: message, title: "Alert", vc: self)
                self.badgeLbl.text = "0"
            }
        }.catch { (error) in
            print(error)
            hideActivityIndicator(uiView: self)
        }
    }
    
    
    
    
    func createBanner(){
        pagerView.automaticSlidingInterval = 3.0
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.isInfinite = true
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        // Create a page control
        //                pageControl.currentPage = 1
        //        self.pageControl.numberOfPages = self.bannerArray.count
    }
    
    
    @IBAction func tapOnSearchBtn(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        vc.bag_count = self.badge_count
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func tapOnAddProBtn(_ sender: UIButton) {
        let item = self.products_arr[sender.tag]
        if user_id != "" {
            if let item_list = item.item_list{
                if item_list.count != 0 {
                    openPopUp(currentVC: self, nextVCname: "AddOnViewController", nextVC: AddOnViewController.self)
                    NotificationCenter.default.post(name: .addOnPro_toShow, object: nil , userInfo: ["data":item])
                }else{
                    self.cart_item.pro_amount = item.sales_price
                    self.cart_item.pro_qty = "1"
                    self.cart_item.item_name = item.item_name
                    self.cart_item.id = item.id
                    self.cart_item.sales_price = item.sales_price
                    self.cart_item.item_image = item.item_image
                    self.send_pro_to_cartServer(data: self.cart_item)
                }
            }
            
        }else{
            goToNextVcThroughNavigation(currentVC: self, nextVCname: "LoginViewController", nextVC: LoginViewController.self)
        }
        
    }
    
    @IBAction func tapOnPlusBtn(_ sender: UIButton) {
        
        let i = sender.tag
        var cart_index = 0
        let cell = pro_table.cellForRow(at: IndexPath(row: i, section: 0)) as! ProTableViewCell
        let qty = cell.qty.text
        for (loopindex,record) in self.cart_lists.enumerated() {
            let cart_proId = record.id
            if cart_proId == self.products_arr[i].id{
                if  let each_price = self.cart_lists[loopindex].sales_price {
                    cart_index = loopindex
                    let amountInt = Double(each_price)!
                    each_pro_price = amountInt
                }
            }
        }
        productQty = Int(qty!)!
        productQty += 1
        cell.qty.text = String(productQty)
        let qtyDouble = Double(productQty)
        let totalamount = qtyDouble * each_pro_price
        let round_value = Double(round(1000 * totalamount) / 1000)
        self.cart_lists[cart_index].pro_amount = String(round_value)
        self.cart_lists[cart_index].pro_qty = String(productQty)
        
    }
    
    @IBAction func tapOnminusBtn(_ sender: UIButton) {
        let i = sender.tag
        var cart_index = 0
        let cell = pro_table.cellForRow(at: IndexPath(row: i, section: 0)) as! ProTableViewCell
        let qty = cell.qty.text
        productQty = Int(qty!)!
        if productQty <= 1 {
            // if product qty is 0
        }else {
            for (loopindex,record) in self.cart_lists.enumerated() {
                let cart_proId = record.id
                if cart_proId == self.products_arr[i].id{
                    if  let each_price = self.cart_lists[loopindex].sales_price {
                        cart_index = loopindex
                        let amountInt = Double(each_price)!
                        each_pro_price = amountInt
                    }
                }
            }
            productQty -= 1
            cell.qty.text = String(productQty)
            let qtyDouble = Double(productQty)
            let totalamount = qtyDouble * each_pro_price
            self.cart_lists[cart_index].pro_amount = String(totalamount)
            self.cart_lists[cart_index].pro_qty = String(productQty)
            self.badgeLbl.text = "\(self.cart_lists.count)"
            
        }
    }
    
    
    
    @IBAction func tapOnPickUpBtn(_ sender: Any) {
        self.deliveryBtn.backgroundColor = .clear
        self.pickUpBtn.backgroundColor = .white
        self.table_top.backgroundColor = .clear
        mode_of_delivery = "1"
    }
    
    @IBAction func tapOnDeliveryBtn(_ sender: Any) {
//        self.deliveryBtn.backgroundColor = .white
//        self.pickUpBtn.backgroundColor = .clear
//        self.table_top.backgroundColor = .clear
//        mode_of_delivery = "2"
        showToast(message: "Currently we are not providing this feature.", font: UIFont.systemFont(ofSize: 15))
        
    }
    
    @IBAction func tapOnTableTop(_ sender: Any) {
        self.deliveryBtn.backgroundColor = .clear
        self.pickUpBtn.backgroundColor = .clear
        self.table_top.backgroundColor = .white
        goToNextVcThroughNavigation(currentVC: self, nextVCname: "ScannerViewController", nextVC: ScannerViewController.self)
        mode_of_delivery = ""
    }
    
    @IBAction func tabpOnAllCatBtn(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
        vc.cart_data = self.cart_lists
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func tapOnBookTable(_ sender: Any) {
        openPopUp(currentVC: self, nextVCname: "TableReservationViewController", nextVC: TableReservationViewController.self)
        
    }
    
    @IBAction func tapOnViewAll(_ sender: Any) {
        //        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
        //        vc.cart_data = self.cart_lists
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapOnHomeBtn(_ sender: Any) {
    }
    
    @IBAction func tapOnTableBtn(_ sender: Any) {
        openPopUp(currentVC: self, nextVCname: "TableReservationViewController", nextVC: TableReservationViewController.self)
    }
    
    @IBAction func tapOnProfileBtn(_ sender: Any) {
        if user_id != "" {
            goToNextVcThroughNavigation(currentVC: self, nextVCname: "MyAccountViewController", nextVC: MyAccountViewController.self)
            
        }else{
            goToNextVcThroughNavigation(currentVC: self, nextVCname: "LoginViewController", nextVC: LoginViewController.self)
            
        }
        
    }
    
    @IBAction func tapOnCartBTn(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // Fs Page Delegate
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return banner_list_arr.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        if let image = self.banner_list_arr[index].banner_image{
            let url = URL(string: image)
            cell.imageView?.kf.setImage(with: url)
        }
        cell.imageView?.viewBorder(radius: 10, color: .clear, borderWidth: 0)
        
        
        return cell
    }
    // MARK:- FSPagerView Delegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        //                self.pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        //                self.pageControl.currentPage = pagerView.currentIndex
    }
    
}


extension  ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products_arr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ProTableViewCell = tableView.dequeueReusableCell(withIdentifier: "pro_cell") as! ProTableViewCell
        cell.product_view.setCardView()
        cell.addBtn.viewBorder(radius: 10, color: .clear, borderWidth: 0)
        cell.pro_image.viewBorder(radius: 5, color: .clear, borderWidth: 0)
        cell.addBtn.tag = indexPath.row
        if let item_list = self.products_arr[indexPath.row].item_list{
            if item_list.count != 0 {
                cell.addBtn.setTitle(title: "Add+")
            }
            else{
                cell.addBtn.setTitle(title: "Add")
            }
        }
        
        let item = self.products_arr[indexPath.row]
        cell.bind_data(item: item)
        
        
        
        return cell
    }
    
    
    
    
}

