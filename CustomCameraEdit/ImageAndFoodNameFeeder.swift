//
//  ImageAndFoodNameFeeder.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 27/9/21.
//

import Foundation
import SwiftUI
import Combine

class ImageAndNameFeeder: ObservableObject, Identifiable {
    
    @Published var foodList: [Item]

    init(addingItemName: String, itemImage: UIImage){
        self.foodList = [Item(addingItemName: "Test", itemImage: UIImage(named: "placeholder")!)]
    }
    
    struct Item: Identifiable {
         var id = UUID()
         var addingItemName: String = ""
         var itemImage: UIImage = UIImage()
        
        init(addingItemName: String, itemImage: UIImage){
            self.addingItemName = addingItemName
            self.itemImage = itemImage
        }
    }
    
    func delete(at offsets: IndexSet){
        foodList.remove(atOffsets: offsets)
    }
    
}
