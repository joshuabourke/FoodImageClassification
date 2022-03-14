//
//  TestingImageSharing.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 25/2/22.
//

import SwiftUI

struct TestingImageSharing: View {
    var image: UIImage?
    var title: String
    
    
    //MARK: - PROPERTIES
    
    //MARK: - BODY
    var body: some View {
        //HERO IMAGE
        VStack {
            ZStack(alignment: .bottomTrailing) {
                Image(uiImage: image ?? UIImage(named: "placeholder")!)
                    .centerCropped()
                    .frame(width: 299, height: 299, alignment: .center)
                .cornerRadius(8)
                
                Image("AppleGray Logo Water Mark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 55, height: 55, alignment: .center)
                    .padding(.trailing, 2)
                    .padding(.bottom, 2)
                    
            }//: ZSTACK
        //TITLE
        Text(title)
            .font(.largeTitle)
            .fontWeight(.heavy)
            .multilineTextAlignment(.center)
            .padding(.vertical, 16)
            .foregroundColor(.primary)
            .background(Color.accentColor
                            .frame(height: 6)
                            .offset(y: 24))
        }//: VSTACK
        .padding(.bottom, 14)
    }
}
    //MARK: - PREVIEW
struct TestingImageSharing_Previews: PreviewProvider {
    static var previews: some View {
        TestingImageSharing(title: "Apple")
            .previewLayout(.sizeThatFits)
    }
}
