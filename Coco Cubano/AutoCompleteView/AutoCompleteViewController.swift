//
//  AutoCompleteViewController.swift
//  Coco Cubano
//
//  Created by kavi yadav on 20/12/21.
//

import UIKit

class AutoCompleteViewController: UIViewController {

    @IBOutlet weak var place_table: UITableView!
    
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var searchTxt: UITextField!
    
    var autocompleteResults :[GApiResponse.Autocomplete] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GoogleApi.shared.initialiseWithKey("AIzaSyChxXW2iTnRPX7bXon6ton_wuaEalm36M8")


    }
    
    func showResults(string:String){
        var input = GInput()
        input.keyword = string
        GoogleApi.shared.callApi(input: input) { (response) in
            if response.isValidFor(.autocomplete) {
                DispatchQueue.main.async {
                    self.searchView.isHidden = false
                    self.autocompleteResults = response.data as! [GApiResponse.Autocomplete]
                    self.place_table.reloadData()
                }
            } else { print(response.error ?? "ERROR") }
        }
    }

    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
dismissController(vc: self)
                
            }
        });
    }


    
    @IBAction func taponCloseBtn(_ sender: Any) {
     removeAnimate()
    }
    

}
extension  AutoCompleteViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteResults.count
    }
    
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell:AutocompTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AutocompTableViewCell
            cell.addressLbl.text = autocompleteResults[indexPath.row].formattedAddress

            return cell
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selected_address = autocompleteResults[indexPath.row].formattedAddress
        NotificationCenter.default.post(name: .searched_address, object: nil , userInfo: ["data":selected_address])
        removeAnimate()
    }

    

}
extension AutoCompleteViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text! as NSString
        let fullText = text.replacingCharacters(in: range, with: string)
        if fullText.count > 2 {
            showResults(string:fullText)
        }else{
        }
        return true
    }
}
