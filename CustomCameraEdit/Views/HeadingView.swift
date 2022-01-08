//
//  HeadingView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 23/12/21.
//

import SwiftUI

struct HeadingView: View {
    //MARK: - PROPERTIES
    var headingImage: String
    var headingTitle: String
    //MARK: - BODY
    var body: some View {
        HStack{
            Image(systemName: headingImage)
                .foregroundColor(.accentColor)
                .imageScale(.large)
            
            Text(headingTitle)
                .font(.title3)
                .fontWeight(.bold)
        }//: HSTACK
    }
}
    //MARK: PREVIEW
struct HeadingView_Previews: PreviewProvider {
    static var previews: some View {
        HeadingView(headingImage: "photo.on.rectangle.angled", headingTitle: "Food Description")
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
