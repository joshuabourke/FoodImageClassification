//
//  FoodJSON.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 15/3/22.
//

import SwiftUI

struct FoodJSON: Codable {
    //MARK: - PROPERTIES
    //Declaring the properties for the JSON
    var fdc_id: Int
    var food: String
    var description: String
    var food_category_id: Int?
    var food_category_name: String?
    var nitrogen: Double?
    var protein: Double?
    var total_lipid_fat: Double?
    var carbohydrate_by_difference: Double?
    var ash: Double?
    var energy: Double?
    var starch: Double?
    var surcose: Double?
    var glucose_dextrose: Double?
    var fructose: Double?
    var caffeine: Double?
    var fiber_total_dietary: Double?
    
    
    //Now to define the coding keys
//    enum CodingKeys: String, CodingKey {
//        case id = "fdc_id"
//        case food = "food"
//        case description = "description"
//        case food_category_id = "food_category_id"
//        case food_category_name = "food_category_name"
//        case nitrogen = "nitrogen"
//        case protein = "protein"
//        case total_lipid_fat = "total_lipid_fat"
//        case carbohydrate_by_difference = "carbohydrate_by_difference"
//        case ash = "ash"
//        case energy = "energy"
//        case starch = "starch"
//        case surcose = "surcose"
//        case glucose_dextrose = "glucose_dextrose"
//        case fructose = "fructose"
//        case caffeine = "caffeine"
//        case fiber_total_dietary = "fiber_total_dietary"
//    }

}

extension FoodJSON: Identifiable {
    var id: Int {return fdc_id }
}

//func nullToNil(value: AnyObject?) -> AnyObject? {
//    if value is NSNull {
//        return nil
//    } else {
//        return value
//    }
//}

//The Init function from decodable
//    init(from decoder: Decoder) throws {
//        //1. Container
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//
//
//        //2. Normal Decoding
//        id = try values.decode(Int.self, forKey: .id)
//        food = try values.decode(String.self, forKey: .food)
//        description = try values.decode(String.self, forKey: .description)
//        food_category_id = try values.decode(Int.self, forKey: .food_category_id)
//        food_category_name = try values.decode(String.self, forKey: .food_category_name)
//
//
//
//        if let nitrogen = try values.decodeIfPresent(Int.self, forKey: .nitrogen) {
//            self.nitrogen = nitrogen
//        } else {
//            self.nitrogen = 0
//        }
//
//        if let protein = try values.decodeIfPresent(Int.self, forKey: .protein) {
//            self.protein = protein
//        } else {
//            self.protein = 0
//        }
//
//        if let total_lipid_fat = try values.decodeIfPresent(Int.self, forKey: .total_lipid_fat) {
//            self.total_lipid_fat = total_lipid_fat
//        } else {
//            self.total_lipid_fat = 0
//        }
//
//        if let carbohydrate_by_difference = try values.decodeIfPresent(Int.self, forKey: .carbohydrate_by_difference) {
//            self.carbohydrate_by_difference = carbohydrate_by_difference
//        } else {
//            self.carbohydrate_by_difference = 0
//        }
//
//        if let ash = try values.decodeIfPresent(Int.self, forKey: .ash) {
//            self.ash = ash
//        } else {
//            self.ash = 0
//        }
//
//        if let energy = try values.decodeIfPresent(Int.self, forKey: .energy) {
//            self.energy = energy
//        } else {
//            self.energy = 0
//        }
//
//        if let starch = try values.decodeIfPresent(Int.self, forKey: .starch) {
//            self.starch = starch
//        } else {
//            self.starch = 0
//        }
//
//        if let surcose = try values.decodeIfPresent(Int.self, forKey: .surcose) {
//            self.surcose = surcose
//        } else {
//            self.surcose = 0
//        }
//
//        if let glucose_dextrose = try values.decodeIfPresent(Int.self, forKey: .glucose_dextrose) {
//            self.glucose_dextrose = glucose_dextrose
//        } else {
//            self.glucose_dextrose = 0
//        }
//
//        if let fructose = try values.decodeIfPresent(Int.self, forKey: .fructose) {
//            self.fructose = fructose
//        } else {
//            self.fructose = 0
//        }
//
//        if let caffeine = try values.decodeIfPresent(Int.self, forKey: .caffeine) {
//            self.caffeine = caffeine
//        } else {
//            self.caffeine = 0
//        }
//
//        if let fiber_total_dietary = try values.decodeIfPresent(Int.self, forKey: .fiber_total_dietary) {
//            self.fiber_total_dietary = fiber_total_dietary
//        } else {
//            self.fiber_total_dietary = 0
//        }
//
//    }




