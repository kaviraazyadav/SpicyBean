//
//  MyorderViewController.swift
//  Coco Cubano
//
//  Created by kavi yadav on 21/12/21.
//

import UIKit

class MyorderViewController: UIViewController {

    
    @IBOutlet weak var upertabview: UIView!
    
    
    @IBOutlet weak var tableTopBtn: UIButton!
    @IBOutlet weak var delBtn: UIButton!
    
    @IBOutlet weak var tAwayBtn: UIButton!
    @IBOutlet weak var delView: UIView!
    
    @IBOutlet weak var tawayView: UIView!
    
    @IBOutlet weak var myOrderTable: UITableView!
    
    @IBOutlet weak var tableView: UIView!
    var myOrder_list_arr = [MyorderList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        // Do any additional setup after loading the view.
    }
    func initialSetup(){
        self.tawayView.backgroundColor = .clear
        self.delView.backgroundColor = hexStringToUIColor(hex: "#8EC400")
        self.callOrderListApi(param: ["id":userDefault.shared.getUserId(key: Constants.user_id),"orderType":"2"])

    }
    
    // Order List Api
    func callOrderListApi(param:[String:Any]){
            showActivityIndicator(uiView: self)
        let req = NetworkManger.api.postRequest(reqType:.orderList, params: param, responseType: MyorderResponse.self, vc: self)
            req.done { (response:MyorderResponse) in
                hideActivityIndicator(uiView: self)
                print(response)
                let responseCode = response.responseCode
                let message = response.message ?? ""
                print(message)
                if responseCode == "0"{
                    self.myOrder_list_arr.removeAll()
                    if let item = response.lists{
                        self.myOrder_list_arr = item
                    }
                    self.myOrderTable.tableViewReloadInMainThread()
                    
                }else{
                    self.myOrder_list_arr.removeAll()
                    self.myOrderTable.tableViewReloadInMainThread()
                 AlertMsg(Msg: message, title: "Alert", vc: self)
                }
            }.catch { (error) in
                print(error)
                hideActivityIndicator(uiView: self)
            }
    }

    
    @IBAction func tapOnMyorderBtn(_ sender: UIButton) {
        let item = self.myOrder_list_arr[sender.tag]
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyOrderDetailViewController") as! MyOrderDetailViewController
        vc.order_detail_data = item
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func taponBackBtn(_ sender: Any) {
        goBack(vc: self)
    }
    
    @IBAction func tapOnTableTop(_ sender: Any) {
        self.delView.backgroundColor = .clear
        self.delBtn.setTitleColor(.darkGray, for: .normal)
        self.tAwayBtn.setTitleColor(.darkGray, for: .normal)
        self.tawayView.backgroundColor = .clear
        self.tableView.backgroundColor = hexStringToUIColor(hex: "#8EC400")
        self.tableTopBtn.setTitleColor(hexStringToUIColor(hex: "#8EC400"), for: .normal)
        self.callOrderListApi(param: ["id":userDefault.shared.getUserId(key: Constants.user_id),"orderType":"3"])

    }
    
    @IBAction func tapOnDelView(_ sender: Any) {
        self.delView.backgroundColor = hexStringToUIColor(hex: "#8EC400")
        self.delBtn.setTitleColor(hexStringToUIColor(hex: "#8EC400"), for: .normal)
        self.tAwayBtn.setTitleColor(.darkGray, for: .normal)
        self.tawayView.backgroundColor = .clear
        self.tableTopBtn.setTitleColor(.darkGray, for: .normal)
        self.tableView.backgroundColor = .clear
        self.callOrderListApi(param: ["id":userDefault.shared.getUserId(key: Constants.user_id),"orderType":"2"])

    }
    
    @IBAction func tapOnTakeAwayBtn(_ sender: Any) {
        self.tawayView.backgroundColor = hexStringToUIColor(hex: "#8EC400")
        self.delView.backgroundColor = .clear
        self.delBtn.setTitleColor(.darkGray, for: .normal)
        self.tableTopBtn.setTitleColor(.darkGray, for: .normal)
        self.tableView.backgroundColor = .clear
        self.tAwayBtn.setTitleColor(hexStringToUIColor(hex: "#8EC400"), for: .normal)
        self.callOrderListApi(param: ["id":userDefault.shared.getUserId(key: Constants.user_id),"orderType":"1"])
    }
}
extension  MyorderViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myOrder_list_arr.count
    }
    
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell:MyOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MyOrderTableViewCell
            cell.cardView.setCardView()
            let item = self.myOrder_list_arr[indexPath.row]
            cell.bindData(item: item)
            cell.orderDetailBtn.tag = indexPath.row
            return cell
        }

    

}
