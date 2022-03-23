//
//  ImageSliderView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 23/12/21.
//

import SwiftUI

struct ImageSliderView: View {
    //MARK: - PROPERTIES
    
    let testJson: Test
    
    //MARK: - BODY
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 15){
                ForEach(testJson.images, id:\.self) { item in
                    Image(item)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(12)
                }
            }//: HSTACK
        }//: SCROLL
        
    }
}
    //MARK: - PREVIEW
struct ImageSliderView_Previews: PreviewProvider {
    
    static let foods: [Test] = Bundle.main.decode("TestApple.json")
    
    
    static var previews: some View {
        
        ImageSliderView(testJson: foods[0])
            .previewLayout(.sizeThatFits)
            .padding()
            .preferredColorScheme(.dark)
    }
}
