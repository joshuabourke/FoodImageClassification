//
//  FoodRequestViewModel.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 19/11/21.
//

import Foundation

@MainActor
class FoodListViewModel: ObservableObject {
    
    @Published var results: [FoodRequestViewModel] = []
    
    @available(iOS 15.0.0, *)
    func search(name: String) async {
        do{
       let results = try await FoodInfoRequest().getFoodInfo(foodSearch: name)
            self.results = results.map(FoodRequestViewModel.init)
        } catch {
            print(error)
        }
    }
}


struct FoodRequestViewModel {
    
    let foodInfo : Parsed
    
    var energy: String {
        foodInfo.nutrient.ENERC_KCAL
    }
    
    var protein: String {
        foodInfo.nutrient.PROCNT
    }
    
    var carbs: String{
        foodInfo.nutrient.CHOCDF
    }
    
    var fiber: String {
        foodInfo.nutrient.FIBTG
    }
    
    var fat: String {
        foodInfo.nutrient.FAT
    }
}
