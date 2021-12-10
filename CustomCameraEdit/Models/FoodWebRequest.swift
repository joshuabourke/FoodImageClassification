//
//  FoodWebRequest.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 18/11/21.
//

import Foundation
import SwiftUI

struct ApiResponse: Decodable {
    var text: String = ""
    let parsed: [Parsed]
}

struct Parsed: Decodable {
    let nutrient: Nutrients
}

struct Nutrients: Decodable {
    let ENERC_KCAL: String
    let PROCNT: String
    let FAT: String
    let CHOCDF: String
    let FIBTG: String

}

//
//    func foodSearch(_ foodName: String) {
//        guard let url = URL(string: "https://api.edamam.com/api/food-database/v2/parser?app_id=0ec6a263&app_key=4ed1b4351b462ceb2762f0242ca0b0fc&ingr=" + foodName) else {return}
//
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            do {
//                if let d = data {
//                    let decodedLists = try JSONDecoder().decode(response.self, from: d)
//                }
//            }
//
//        }
//    }
//
//}
