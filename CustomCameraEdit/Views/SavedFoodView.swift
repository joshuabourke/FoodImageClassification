//
//  SavedFoodView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 19/9/21.
//

import SwiftUI

struct SavedFoodView: View {
    
    @EnvironmentObject var imageAndFoodNameFeeder: ImageAndNameFeeder
    
    var body: some View {
        NavigationView{
            List{
                ForEach(imageAndFoodNameFeeder.foodList) { index in
                    HStack{
                        Image(uiImage: index.itemImage)
                            .resizable()
                            .frame(width: 125, height: 125)
                            .cornerRadius(12)
                            .padding()
                        Text(index.addingItemName)
                            .font(.bold(.title2)())
                    }

                }
                .onDelete(perform: imageAndFoodNameFeeder.delete)
            }
            
                .navigationTitle("Saved")
        }
    }
}

struct SavedFoodView_Previews: PreviewProvider {
    static var previews: some View {
        SavedFoodView()
    }
}
