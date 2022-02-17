//
//  FoodTagButton.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 12/2/22.
//

import SwiftUI

struct FoodTagButton: View {
    
    var tagTitle: String
    
    var body: some View {
        Button {
            
        } label: {
            Text(tagTitle)

                .foregroundColor(Color.primary)
                .font(.caption)
                .fontWeight(.bold)
                .padding(.horizontal)
                .padding(.vertical, 2)
                
        }
        .border(Color.accentColor, width: 2, cornerRadius: 25)

    }
}

struct FoodTagButton_Previews: PreviewProvider {
    static var previews: some View {
        FoodTagButton(tagTitle: "Item1")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
