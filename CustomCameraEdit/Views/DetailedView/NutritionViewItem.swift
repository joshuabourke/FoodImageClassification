//
//  NutritionViewItem.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 20/3/22.
//

import SwiftUI

struct NutritionViewItem: View {
    //MARK: - PROPERTIES
    @State var nutrientType: String
    
    @State var nutritionalValue: String
    
    
    //MARK: - BODY
    var body: some View {
        HStack {
            Group{
                Image(systemName: "info.circle")
                Text(nutrientType)
            }
            .foregroundColor(Color("yellow1"))
            .font(.system(.body).bold())
            
            Spacer(minLength: 25)
            
            Text("\(nutritionalValue)")
                .multilineTextAlignment(.trailing)
        }//: HSTACK
        
    }
}

    //MARK: - PREVIEW
struct NutritionViewItem_Previews: PreviewProvider {
    static var previews: some View {
        NutritionViewItem(nutrientType: "Protein", nutritionalValue: "0.12423")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
