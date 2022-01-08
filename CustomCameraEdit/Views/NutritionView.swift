//
//  NutritionView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 23/12/21.
//

import SwiftUI

struct NutritionView: View {
    //MARK: - PROPERTIES
    
    var food: Test
    
    let nutrients: [String] = ["Energy", "Sugar", "Fat", "Protein", "Vitamins", "Minerals"]
    //MARK: - BODY
    var body: some View {
        GroupBox() {
            DisclosureGroup("Nutritional value per 100g"){
                ForEach(0..<nutrients.count, id:\.self) { item in
                    Divider().padding(.vertical, 2)
                    HStack{
                        Group{
                            Image(systemName: "info.circle")
                            Text(nutrients[item])
                        }
                        .foregroundColor(Color("green2"))
                        .font(.system(.body).bold())
                        
                        Spacer(minLength: 25)
                        
                        Text(food.nutrition[item])
                            .multilineTextAlignment(.trailing)
                    }//: HSTACK
                }
            }//: DISCLOSUREGROUP
        }//: GROUP
        .padding()
        
    }
}
    //MARK: - PREVIEW
struct NutritionView_Previews: PreviewProvider {
    static var previews: some View {
        let foods: [Test] = Bundle.main.decode("TestApple.json")
        
        NutritionView(food: foods[0])
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 375, height: 480))
            .padding()
    }
}
