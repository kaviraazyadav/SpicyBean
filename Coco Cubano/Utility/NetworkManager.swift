
//  NetworkManager.swift
//
//  Created by Kavi Raaz Yadav on 3/4/19.


import Foundation
import PromiseKit
import Alamofire
import UIKit
// live Server_Url
let Base_Url = "https://cococubanorousehill.com.au/coco_api/api/"
// Test Server_Url
//let Base_Url = "http://182.70.254.235:3001"


enum RequestType {
    case banners
    case outletLogin
    case category
    case products
    case login
    case sign_up
    case verify
    case addAddress
    case saveOrder
    case default_address
    case updateProfile
    case forgotPswd
    case socialLogin
    case orderList
    case addToCart
    case paymentStatus
    case reserveTable
    case view_cart
    case delete_cart_item
    case increment_item
    case decrement_item
}

class NetworkManger {
    static let  api = NetworkManger ()
    private init () {}
    let tokenHeader : HTTPHeaders = ["api-token":"ODdwUk5nVEM0U1hTdGVyNWZtd2I5WE9CM0ExbzNTVHBvU2U1akJNN3F0WTFPOEZGTlpnbjVpRGRhZkt25c7d83f082b2c"]
    
    func postRequest<T:Decodable>(reqType:RequestType ,params:[String:Any],responseType : T.Type,vc:UIViewController) -> Promise <T> {
        return Promise <T> { resolver in
            let urlString = getUrl(requestType: reqType)
            let req = reqType
            print("URL:",urlString)
            guard let url = URL(string: urlString) else {return}
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
          request.setValue("1234", forHTTPHeaderField: "api-key")

            do {
                request.httpBody   = try JSONSerialization.data(withJSONObject: params)
            } catch let error {
                print("Error : \(error.localizedDescription)")
            }
            AF.request(request).responseString{ response in
                switch(response.result){
                case .success(let data):
                    if let json = data.data(using: .utf8){
                        do {
                            let res = try JSONDecoder().decode(T.self, from: json)
                            resolver.fulfill(res)
                            
                        } catch {
                            resolver.reject(error)
                            print("error",error)
                            //                            hideIndicator()
                        }
                    }
                case .failure(let error):
                    print("error")
                    resolver.reject(error)
                    //                    hideIndicator()
                }
                
            }
        }
    }
    func postRequestForArrayReturns<T:Decodable>(reqType:RequestType ,params:[String:Any],responseType : T.Type,vc:UIViewController) -> Promise <BaseResponseForArrays<T>> {
        return Promise <BaseResponseForArrays<T>> { resolver in
            let url = getUrl(requestType: reqType)
            print("urlAndHeader",url)
            AF.request(url, method: .post, parameters: params).responseString{ response in
                switch(response.result){
                case .success(let data):
                    if let json = data.data(using: .utf8){
                        do {
                            let res = try JSONDecoder().decode(BaseResponseForArrays<T>.self, from: json)
                            let status = res.status
                            if status == 2{
                                goToNextVcThroughNavigation(currentVC: vc, nextVCname: "ViewController", nextVC: ViewController.self)
                            }else{
                                resolver.fulfill(res)
                            }
                        } catch {
                            resolver.reject(error)
                            print("error",error)
                            //                            hideIndicator()
                        }
                    }
                case .failure(let error):
                    print("error")
                    resolver.reject(error)
                    //                    hideIndicator()
                }
                
            }
        }
    }
    
    
    func getRequest<T:Decodable>(reqType : RequestType,responseType:T.Type,vc:UIViewController) -> Promise<BaseResponseForArrays<T>> {
        return Promise <BaseResponseForArrays<T>> {resolver in
            _ = getHeader(reqType: reqType)
            let url = getUrl(requestType: reqType)
            AF.request(url, method: .get).responseString {
                response in
                switch (response.result) {
                case .success(let data ):
                    if let json = data.data(using: .utf8){
                        do {
                            let res = try JSONDecoder ().decode(BaseResponseForArrays<T>.self, from: json)
                            let status = res.status
                            if status == 2{
                                goToNextVcThroughNavigation(currentVC: vc, nextVCname: "ViewController", nextVC: ViewController.self)
                            }else{
                                resolver.fulfill(res)
                            }
                        }catch{
                            resolver.reject(error)
                            print("error",error)
                            //                            hideIndicator()
                        }
                    }
                case .failure(let error):
                    print(error)
                    //                    hideIndicator()
                }
            }
        }
    }
    func getUrl(requestType : RequestType) -> String {
        switch requestType {
        case .banners:
            return Base_Url + Constants.banner_list_api_action
        case .outletLogin:
            return Base_Url
        case .category:
            return Base_Url + Constants.category_list_api_action

        case .products:
            return Base_Url + Constants.producs_list_api_action

        case .login:
            return Base_Url + Constants.login_api_action
        case .sign_up:
            return Base_Url + Constants.signup_api_action
        case .verify:
            return Base_Url + Constants.verify_api_action
        case .addAddress:
            return Base_Url + Constants.addAddress_api
        case .saveOrder:
            return Base_Url + Constants.save_order_api
        case .default_address:
            return Base_Url + Constants.default_addresss_api
        case .updateProfile:
            return Base_Url + Constants.update_profile
        case .forgotPswd:
            return Base_Url + Constants.forgot_password
        case .socialLogin:
            return Base_Url + Constants.social_login_api
        case .orderList:
            return Base_Url + Constants.my_order_apiaction
        case .addToCart:
            return Base_Url + Constants.add_to_cart_api
        case .paymentStatus:
            return Base_Url + Constants.payment_status_api
        case .reserveTable:
            return Base_Url + Constants.reserve_table_api
        case .view_cart:
            return Base_Url + Constants.view_cart_api
        case .delete_cart_item:
            return Base_Url + Constants.delete_item_cart_api
        case .increment_item:
            return Base_Url + Constants.increment_item_cart
        case .decrement_item:
            return Base_Url + Constants.decrement_item_cart
        }
        
    }
    
    func getHeader(reqType : RequestType) -> HTTPHeaders {
        let acessToken_header : HTTPHeaders = ["Content-Type":"application/json"]
        return acessToken_header
    }
}
