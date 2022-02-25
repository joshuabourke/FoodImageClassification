//
//  FoodTagView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 12/2/22.
//

import SwiftUI
import CoreMedia

struct FoodTagView: View {
    //MARK: - PROPERTIES
    var testingArray = [String]()
    
    
    //MARK: - BODY
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
                            
//            ScrollView(.horizontal ,showsIndicators: false) {
                HStack(alignment: .center, spacing: 2) {
                    ForEach(testingArray, id: \.self) { item in
                        FoodTagButton(tagTitle: item)
                            .padding(.horizontal)
                        }
                    }//: LOOP
                    .padding(.horizontal, 16)
                    .padding(.vertical, 4)

                }//: HSTACK
//            }//: SCROLL VIEW
//            .padding(.vertical, 2)
        }
    }

    //MARK: - PREVIEW
struct FoodTagView_Previews: PreviewProvider {
    static var previews: some View {
        FoodTagView(testingArray: ["Hello", "Apple"])
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
