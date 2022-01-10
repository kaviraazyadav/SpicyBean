//
//  CategoryViewController.swift
//  Coco Cubano
//
//  Created by kavi yadav on 15/12/21.
//

import UIKit

class CategoryViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var allCatColl: UICollectionView!
    
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var badgeLbl: UILabel!
    
    var category_list_arr = [CategoryLists]()
    var cart_data = [CartProductLists]()
    var filter_category_list_arr = [CategoryLists]()

    var searchStr:String=""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.callCategoryListApi(param: ["":""])
            self.badgeLbl.text = "0"
        self.searchTxt.delegate = self
        self.searchTxt.addTarget(self, action: #selector(CategoryViewController.textFieldDidChange(_:)), for: .editingChanged)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        user_id = userDefault.shared.getUserId(key: Constants.user_id)
        if user_id != ""{
            self.callViewCartApi(param: ["user_id":user_id])
        }

       

    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text == ""{
            searchStr = ""
            self.filter_category_list_arr.removeAll()
            self.allCatColl.collectinViewReloadInMainThread()
        }

    }

    
    // View Cart Api
    func callViewCartApi(param:[String:Any]){
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
                        self.badgeLbl.text = "\(temp_count)"
                    }
                }else{
//                 AlertMsg(Msg: message, title: "Alert", vc: self)
                }
            }.catch { (error) in
                print(error)
                hideActivityIndicator(uiView: self)
            }
    }

    
    override func viewDidLayoutSubviews() {
        self.badgeLbl.layer.cornerRadius = self.badgeLbl.frame.width/2
        self.badgeLbl.layer.masksToBounds = true
        self.searchView.viewBorder(radius: 5, color: .lightGray, borderWidth: 1)
    }
    // Category Api
    func callCategoryListApi(param:[String:Any]){
            showActivityIndicator(uiView: self)
        let req = NetworkManger.api.postRequest(reqType:.category, params: param, responseType: CategoryResponse.self, vc: self)
            req.done { (response:CategoryResponse) in
                hideActivityIndicator(uiView: self)
                print(response)
                let responseCode = response.responseCode
                let message = response.message ?? ""
                print(message)
                if responseCode == "0"{
                    
                    if let items = response.list{
                        self.category_list_arr = items
                        self.allCatColl.collectinViewReloadInMainThread()
                    }

                }else{
                    AlertMsg(Msg: message, title: "Alert!", vc: self)
                }
            }.catch { (error) in
                print(error)
                hideActivityIndicator(uiView: self)
            }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if string.isEmpty
        {
            
            if textField.text != ""{
                searchStr = textField.text ?? ""
            }else{
                searchStr = ""
            }
          
        }
        else
        {
            searchStr=textField.text!+string
        }

        print(searchStr)

        if searchStr.count >= 2{
            self.filter_category_list_arr.removeAll()
            for item in self.category_list_arr {
                 let cat_name = item.categoryName
                    if cat_name.contains(searchStr.uppercased()){
                        print("cat_name",cat_name)
                        self.filter_category_list_arr.append(item)
                    }
            }
        }else if searchStr.count >= 1{
            self.filter_category_list_arr.removeAll()
            self.filter_category_list_arr = self.category_list_arr
        }
       
print("filterdArray",self.filter_category_list_arr)

//        if self.filter_category_list_arr.count > 0
//        {
//            filter_category_list_arr.removeAll()
//            filter_category_list_arr = filteredArray
//        }
//        else
//        {
////            SearchData=AllData
//        }

        self.allCatColl.collectinViewReloadInMainThread()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == ""{
            searchStr = ""
            self.filter_category_list_arr.removeAll()
            self.allCatColl.collectinViewReloadInMainThread()
        }
    }
    

    @IBAction func tapOnBackBtn(_ sender: Any) {
        goBack(vc: self)
    }
    
    @IBAction func tapOnAllCat(_ sender: Any) {
        goBack(vc: self)
    }
    
    @IBAction func tapOnHome(_ sender: Any) {
//        goToNextVcThroughNavigation(currentVC: self, nextVCname: "ViewController", nextVC: ViewController.self)
        goBack(vc: self)
    }
    
    @IBAction func tapOnTble(_ sender: Any) {
        openPopUp(currentVC: self, nextVCname: "TableReservationViewController", nextVC: TableReservationViewController.self)
    }
    @IBAction func tapOnProfile(_ sender: Any) {
        if user_id != "" {
            goToNextVcThroughNavigation(currentVC: self, nextVCname: "MyAccountViewController", nextVC: MyAccountViewController.self)

        }else{
            goToNextVcThroughNavigation(currentVC: self, nextVCname: "LoginViewController", nextVC: LoginViewController.self)

        }
    }
    
    @IBAction func taponCart(_ sender: Any) {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
//            vc.cart_data = self.cart_data
            self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension CategoryViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchStr != ""{
            return self.filter_category_list_arr.count
        }
        return self.category_list_arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : AllCatCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "all_cat_cell", for: indexPath) as! AllCatCollectionViewCell
        cell.alCatView.setCardView()
        cell.catimgSetView.setCardView()
        if searchStr != ""{
             let cat_name = self.filter_category_list_arr[indexPath.row].categoryName
                cell.cat_name.text = cat_name
            
            if let cat_image  = self.filter_category_list_arr[indexPath.row].categoryImage{
                showImgWithLink(imgUrl: cat_image, imgView: cell.catImg)
            }
        }else{
             let cat_name = self.category_list_arr[indexPath.row].categoryName
                cell.cat_name.text = cat_name
            
            if let cat_image  = self.category_list_arr[indexPath.row].categoryImage{
                showImgWithLink(imgUrl: cat_image, imgView: cell.catImg)
            }
        }
      
        
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if searchStr != ""{
            if let cat_id = self.filter_category_list_arr[indexPath.row].id{
                let cat_name = self.filter_category_list_arr[indexPath.row].categoryName
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
                vc.cat_id = cat_id
                vc.cat_name = cat_name ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
                }
        }else{
            if let cat_id = self.category_list_arr[indexPath.row].id{
                let cat_name = self.category_list_arr[indexPath.row].categoryName
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
                vc.cat_id = cat_id
                vc.cat_name = cat_name ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
                }
        }
      
        
    }
    // flow delegate
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  10
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/3, height: 100)

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

    
    
}
