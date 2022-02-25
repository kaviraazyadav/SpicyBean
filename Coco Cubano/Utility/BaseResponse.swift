//
//  BaseResponse.swift
//  MileHighStore
//
//  Created by Kavi Raaz Yadav on 3/4/19.
//  Copyright © 2019 MileHighStore. All rights reserved.
//

import Foundation

struct BaseResponse<T:Decodable>: Decodable {
    //    var status : String
    //    var message : String
    //    var data : T?
}
struct BaseResponseUploadFile<T:Decodable>: Decodable {
    var error : Bool?
    var status : Int
    var message : String
    var data : String?
}
struct UploadFileResponse:Decodable {
    var error : Bool?
    var status : Int
    var message : String
    var data : String?
}

struct BaseResponseForArrays<T:Decodable>: Decodable {
    var error : Bool?
    var status : Int?
    var message : String?
    var data : [T]?
}
struct CommonResponse:Codable {
    var status : String?
    var responseCode : String?
    var message : String?
    var order_id : String?
    var outlet_id : Int?
    var customerId : String?
    var payment_status: String?
    var Name : String?
    var Email:String?
}
struct ReserveTableResponse:Codable {
    var status : String?
    var responseCode : String?
    var message : String?
    var outlet_id : String?
}
struct PaymentStatusResponse:Codable {
    var status : String?
    var responseCode : String?
    var message : String?
    var payment_code : Int?
    var payment_status : String?
    var grand_total : String?
}
struct BannerResponse:Decodable {
    var status : String?
    var responseCode : String?
    var message : String?
    var list : [BannerLists]?
}
struct BannerLists:Decodable {
    var id : String?
    var banner_code : String?
    var title_banner : String?
    var description_banner : String?
    var banner_image : String?
    var status : String?
    var company_id : String?
}
struct CategoryResponse:Decodable {
    var status : String?
    var responseCode : String?
    var message : String?
    var list : [CategoryLists]?
}
struct CategoryLists:Decodable {
    var id : String?
    var category_code : String?
    var category_name : String?
    var description : String?
    var company_id : String?
    var status : String?
    var cat_image : String?
    var cat_url_slag : String?
    var categoryImage : String?
    var categoryName : String?
}
struct ProductsResponse:Decodable {
    var status : String?
    var responseCode : String?
    var message : String?
    var list : [ProductLists]?
}
struct ProductLists:Decodable {
    var id : String?
    var item_code : String?
    var custom_barcode : String?
    var item_name : String?
    var description : String?
    var category_id : String?
    var sku : String?
    var hsn : String?
    var unit_id : String?
    var alert_qty : String?
    var brand_id : String?
    var lot_number : String?
    var expire_date : String?
    var price : String?
    var tax_id : String?
    var purchase_price : String?
    var tax_type : String?
    var profit_margin : String?
    var sales_price : String?
    var stock : String?
    var item_image : String?
    var created_date : String?
    var created_time : String?
    var created_by : String?
    var image_code : String?
    var url_slug : String?
    var modifier : String?
    var quick_food : String?
    var avl_start_time : String?
    var avl_close_time : String?
    var pro_qty : String?
    var pro_amount : String?
    var is_pro_addedTo_cart : Bool?
    var item_list : [AddonList]?
}
struct AddonList:Codable{
    var id : String?
    var modifier_code : String?
    var modifier_name : String?
    var modifier_price : String?
    var status : String?
    var items_modifier_code : String?
    var item_id : String?
    var add_on_qty : String?
    var modifier_id : String?
}

struct CartProductLists:Codable {
    var id : String?
    var item_code : String?
    var custom_barcode : String?
    var item_name : String?
    var description : String?
    var category_id : String?
    var sku : String?
    var hsn : String?
    var unit_id : String?
    var alert_qty : String?
    var brand_id : String?
    var lot_number : String?
    var expire_date : String?
    var price : String?
    var tax_id : String?
    var purchase_price : String?
    var tax_type : String?
    var profit_margin : String?
    var sales_price : String?
    var stock : String?
    var item_image : String?
    var created_date : String?
    var created_time : String?
    var created_by : String?
    var image_code : String?
    var url_slug : String?
    var modifier : String?
    var quick_food : String?
    var avl_start_time : String?
    var avl_close_time : String?
    var pro_qty : String?
    var pro_amount : String?
    var item_list : [AddonList]?
}

struct ViewCartResponse:Decodable{
    var status : String?
    var responseCode : String?
    var message : String?
    var count : String?
    var list : [ViewCarListResponse]?
}

struct ViewCarListResponse: Decodable {
    var id : String?
    var product_id : String?
    var sub_category_id : String?
    var category_id : String?
    var product_name : String?
    var product_price : String?
    var product_weight_type : String?
    var product_quantity : String?
    var lkp_city_id : String?
    var product_language_id : String?
    var created_at : String?
    var user_id : String?
    var session_cart_id : String?
    var device_id : String?
    var reward_points : String?
    var pro_amount : String?
    var sub_total : String?
    var addon_list : [ViewCartAddOnList]?
}
struct ViewCartAddOnList:Decodable{
    var id : String?
    var item_id : String?
    var addon_id : String?
    var price : String?
    var qty : String?
    var total_price : String?
    var note : String?
    var session_cart_id : String?
    var user_id : String?
    var addon_name : String?
}
struct SaveCateToLocal: Codable {
    let id : String
    let item_name : String
    let sales_price : String
    let item_image : String
    let pro_qty : String
    let pro_amount : String
    let item_list : [SaveAddonToLocal]
    
}
struct SaveAddonToLocal:Codable{
    var id : String
    var modifier_name : String
    var modifier_price : String
    var status : String
    var item_id : String
    var add_on_qty : String
    var modifier_id : String
}

struct LoginResponse:Codable{
    var status : String?
    var responseCode : String?
    var message : String?
    var list : LoginInfo?
}
struct LoginInfo:Codable{
    var id : String?
    var customer_code : String?
    var customer_name : String?
    var mobile : String?
    var phone : String?
    var email : String?
    var gstin : String?
    var tax_number : String?
    var vatin : String?
    var opening_balance : String?
    var sales_due : String?
    var sales_return_due : String?
    var country_id : String?
    var state_id : String?
    var city : String?
    var postcode : String?
    var address : String?
    var created_date : String?
    var created_time : String?
    var created_by : String?
    var company_id : String?
    var status : String?
    var user_password : String?
    var offer_id : String?
}
struct DefaultAddressResponse: Decodable {
    var status : String?
    var responseCode : String?
    var message : String?
    var addressId : String?
    var customerId : String?
    var Name : String?
    var Email : String?
    var Mobile : String?
    var Address : String?
    var makeItdefault : String?
    var createddate : String?
    var landmark : String?
    var location : String?
    var flatno : String?
    var saveas : String?
    var Lattitude : String?
    var Longitude : String?
}
struct MyorderResponse : Decodable{
    var status : String?
    var responseCode : String?
    var message : String?
    var lists : [MyorderList]?
}
struct MyorderList : Decodable{
    var id : String?
    var delivery_slot_date : String?
    var order_status : String?
    var order_type : String?
    var customer_name : String?
    var mobile : String?
    var phone : String?
    var gstin : String?
    var email : String?
    var opening_balance : String?
    var country_id : String?
    var state_id : String?
    var postcode : String?
    var address : String?
    var sales_date : String?
    var created_time : String?
    var reference_no : String?
    var sales_code : String?
    var sales_note : String?
    var paid_amount : String?
    var other_charges_input : String?
    var other_charges_tax_id : String?
    var other_charges_amt : String?
    var discount_to_all_input : String?
    var discount_to_all_type : String?
    var tot_discount_to_all_amt : String?
    var round_off : String?
    var payment_status : String?
    var item_list : [OrderProductsList]?
}

struct OrderProductsList:Decodable{
    var item_name : String?
    var sales_qty : String?
    var unit_total_cost : String?
    var price_per_unit : String?
    var tax_amt : String?
    var tax : String?
    var other_charges_amt : String?
    var total_cost : String?
}
