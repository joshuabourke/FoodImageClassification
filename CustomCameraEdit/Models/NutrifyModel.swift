//
//  NutrifyModel.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 10/12/21.
//

import SwiftUI

//MARK: - Food Data Model

struct NutrifyModel: Identifiable {
    
    var id = UUID()
    var title: String
    var headline: String
    var image: UIImage
    var nutrition: [String]
    var description: String
    
}
