//
//  PostPackets.swift
//  MileHighStore
//
//  Created by Kavi Raaz Yadav on 3/5/19.
//  Copyright © 2019 MileHighStore. All rights reserved.
//

import Foundation
import UIKit
class PostPacket{
    typealias Packets = [String:Any]
    typealias StringPackets = [String:String]
    static let shared = PostPacket ()
    private init () {}
    func loginPacket(userName:String,password:String) -> Packets {
        var dict = Packets ()
        dict["username"] = userName
        dict["password"] = password
        return dict
    }
    
    func update_cart(cart_id:Int,qty:Int,trip_id:Int) -> Packets {
        var dict = Packets ()
        dict["cart_id"] = cart_id
        dict["qty"] = qty
        dict["trip_id"] = trip_id
        return dict
    }

    
    func signUpPacket(first_name:String, email:String,password:String  ,last_name:String,dob:String,action:String) -> Packets {
        var dict = Packets ()
        dict["user_fname"] = first_name
        dict["user_email"] = email
        dict["user_password"] = password
        dict["user_lname"] = last_name
        dict["user_dob"] = dob
        dict["action"] = action
//        #if targetEnvironment(simulator)
//        dict["device_token"] = "eLmQt68djiU:APA91bEsxdM8aAwq2s3HY26mbS2qUpy9z1Vw0ZkCK_ajoYNY79756k-owTWzl-oqIcPQo-imYz1e_MJRsfEkq2LYIjR6TokfQCnVbMjRLh8oFeYebW64oIbd4lpVQRglokyp5N-YiSRH"
//        #else
//        dict["device_token"] = userDefault.shared.getFcmToken(key: Constants.fcm_token)
//        #endif
        return dict
    }

    func userInfoPacket(name:String, email:String,mobile:String , gender :String , image: String,refaralCode:String,lat:String,lng:String) -> Packets {
        var dict = Packets ()
        dict["name"] = name
        dict["email"] = email
        dict["mobile"] = mobile
        dict["gender"] = gender
        dict["image"] = image
        dict ["raferal_code"] = refaralCode
        dict ["lat"] = lat
        dict ["lng"] = lng
        return dict
    }
    func updateProfile(full_name: String , mobile_no : String,email:String,gender:String,user_name:String,lat:String,longt:String,user_id:String) -> StringPackets {
        var dict = StringPackets ()
        dict["full_name"] = full_name
        dict["email"] = email
        dict["mobile_no"] = mobile_no
        dict["user_name"] = user_name
        dict["gender"] = gender
        dict["about_think"] = "My Pet is cute"
        dict["lat"] = lat
        dict["longt"] = longt
        dict["user_id"] = user_id

        return dict
    }
    
    func changePasswordPackets(current_password:String,password:String,c_password:String,user_id:String) -> Packets {
        var dict = Packets()
        dict["old_password"] = current_password
        dict["new_password"] = password
        dict["user_id"] = user_id
        return dict
    }
    
    func addPetPacket(pet_name:String, pet_dob :String, pet_about:String, pet_type:String,pet_breed:String , gender:String , is_neutered:String , other_pet_type:String ,user_id:String) -> StringPackets {
        var dict = StringPackets ()
            dict ["pet_name"] = pet_name
            dict ["pet_dob"] = pet_dob
            dict ["pet_about"] = pet_about
            dict ["pet_type"] = pet_type
            dict ["pet_breed"] = pet_breed
            dict ["gender"] = gender
            dict ["is_neutered"] = is_neutered
            dict ["other_pet_type"] = other_pet_type
            dict ["user_id"] = user_id
        return dict
    }
    func updatePetPacket(pet_name:String, pet_dob :String, pet_about:String,gender:String, pet_id:String ,user_id:String) -> StringPackets {
        var dict = StringPackets ()
        dict ["pet_name"] = pet_name
        dict ["pet_dob"] = pet_dob
        dict ["pet_about"] = pet_about
        dict ["gender"] = gender
        dict ["pet_id"] = pet_id
        dict ["user_id"] = user_id
        return dict
    }
}



