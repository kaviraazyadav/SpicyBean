//
//  SaveData.swift
//  BentChair
//
//  Created by kavi yadav on 04/02/19.
//  Copyright © 2019 kavi yadav. All rights reserved.
//

import Foundation
class userDefault {
    static let shared = userDefault ()
    private init () {}
    // Save Token
    func saveOutletId(data:Any,key:String){
        UserDefaults.standard.set(data, forKey: key) //setObject
    }
    func getOutletId(key:String) -> String{
        return  (UserDefaults.standard.string(forKey: key) ?? "")
    }
    // User_id
    func saveUserId(data:Any,key:String){
        UserDefaults.standard.set(data, forKey: key) //setObject
    }
    func getUserId(key:String) -> String{
        return  (UserDefaults.standard.string(forKey: key) ?? "")
    }
    // save dynamic_base_url
    func save_base_url(data:Any,key:String){
        UserDefaults.standard.set(data, forKey: key) //setObject
    }
    func getbase_url(key:String) -> String{
        return  (UserDefaults.standard.string(forKey: key) ?? "")
    }

    // save user info
    func saveUserInfo(data:Any,key:String){
        UserDefaults.standard.set(data, forKey: key) //setObject
    }
    func saveCartInfo(data:[CartProductLists],key:String){
        let encodedData = try! JSONEncoder().encode(data)
        let userDefaults = UserDefaults.standard
        userDefaults.set(encodedData, forKey: key)

    }
    func getCartInfo(key:String) -> [CartProductLists]{
        let placeData = UserDefaults.standard.data(forKey: key)
        var placeArray = [CartProductLists]()
        if placeData != nil{
            placeArray = try! JSONDecoder().decode([CartProductLists].self, from: placeData!)
        }
        return placeArray

        
    }
    func saveLoginInfo(data:LoginResponse,key:String){
        let encodedData = try! JSONEncoder().encode(data)
        let userDefaults = UserDefaults.standard
        userDefaults.set(encodedData, forKey: key)

    }
    func getLoginInfo(key:String) -> LoginResponse{
        let data = UserDefaults.standard.data(forKey: key)
        var login_info = LoginResponse()
        if data != nil{
            login_info = try! JSONDecoder().decode(LoginResponse.self, from: data!)
        }
        return login_info

        
    }


    func getUserInfo(key:String) -> NSDictionary{
        return  UserDefaults.standard.value(forKey: key) as! NSDictionary
    }
    func removeData(key:String) {
         UserDefaults.standard.removeObject(forKey: key)
    }
    
    func savebadgeCount(badge:String,key:String){
        UserDefaults.standard.set(badge, forKey: key) //setObject
    }
    func getBadgeCount(key:String) -> String {
        return  (UserDefaults.standard.string(forKey: key) ?? "")
    }
    func saveFcmToken(token:String,key:String){
        UserDefaults.standard.set(token, forKey: key) //setObject
    }
    func getFcmToken(key:String) -> String {
        return  (UserDefaults.standard.string(forKey: key) ?? "")
    }
    func saveLanguageCodes(lang:String,key:String){
        UserDefaults.standard.set(lang, forKey: key) //setObject
    }
    func getLangCodes(key:String) -> String {
        return  (UserDefaults.standard.string(forKey: key) ?? "")
    }

}
