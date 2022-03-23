//
//  NutritionView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 23/12/21.
//

import SwiftUI

struct NutritionView: View {
    //MARK: - PROPERTIES
    

    var foodJSON: FoodJSON?
    @Binding var foodMultiplyer: Double
    @Binding var foodMultiplyerTitle: String
    @Binding var isNutrientsExpanded: Bool
//    var newFood: FoodJSON
    
    let nutrients: [String] = ["Protein", "Carbs", "Fat"]
    //MARK: - BODY
    var body: some View {
        GroupBox() {
            
            HStack(alignment: .top) {
                    Image(systemName:"info.circle")
                        .foregroundColor(Color.accentColor)
                        .padding(.top, 6)
                
                DisclosureGroup("Nutritional value per \(foodMultiplyerTitle)", isExpanded: $isNutrientsExpanded){
                    
                    VStack(alignment:.leading){
                    Divider().padding(.vertical, 2)
                    NutritionViewItem(nutrientType: nutrients[0], nutritionalValue: "\((foodJSON?.protein ?? 0) * foodMultiplyer)g")
                    
                    Divider().padding(.vertical, 2)
                        NutritionViewItem(nutrientType: nutrients[1], nutritionalValue: "\((foodJSON?.carbohydrate_by_difference ?? 0) * foodMultiplyer)g")
                    
                    Divider().padding(.vertical, 2)
                        NutritionViewItem(nutrientType: nutrients[2], nutritionalValue: "\((foodJSON?.total_lipid_fat ?? 0) * foodMultiplyer)g")
                    
                    }//: VSTACK
                }//: DISCLOSUREGROUP
                .foregroundColor(Color.primary)
            }//: HSTACK
        }//: GROUP
        .padding()
        
    }
}



////MARK: - PROPERTIES
//
//var food: Test
//
////    var newFood: FoodJSON
//
//let nutrients: [String] = ["Energy", "Sugar", "Fat", "Protein", "Vitamins", "Minerals"]
////MARK: - BODY
//var body: some View {
//    GroupBox() {
//
//        HStack(alignment: .top) {
//                Image(systemName:"info.circle")
//                    .foregroundColor(Color.accentColor)
//                    .padding(.top, 6)
//
//            DisclosureGroup("Nutritional value per 100g"){
//                ForEach(0..<nutrients.count, id:\.self) { item in
//                    Divider().padding(.vertical, 2)
//                    HStack{
//                        Group{
//                            Image(systemName: "info.circle")
//                            Text(nutrients[item])
//                        }
//                        .foregroundColor(Color("yellow1"))
//                        .font(.system(.body).bold())
//
//                        Spacer(minLength: 25)
//
//                        Text(food.nutrition[item])
//                            .multilineTextAlignment(.trailing)
//                    }//: HSTACK
//                }
//            }//: DISCLOSUREGROUP
//            .foregroundColor(Color.primary)
//        }//: HSTACK
//    }//: GROUP
//    .padding()
//
//}
//}

    //MARK: - PREVIEW
struct NutritionView_Previews: PreviewProvider {
    static var previews: some View {
//        let foods: [Test] = Bundle.main.decode("TestApple.json")
        
        
        NutritionView(foodJSON: foodJSON?[0], foodMultiplyer: .constant(1), foodMultiplyerTitle: .constant("100g"), isNutrientsExpanded: .constant(true))
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 375, height: 480))
            .padding()
    }
}
