//
//  ImageButtonView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 24/12/21.
//

import SwiftUI

struct ImageButtonView: View {
    //MARK: - PROPERTIES
    var buttonImage: String
    //MARK: - BODY
    var body: some View {
       Image(systemName: buttonImage)
            .foregroundColor(.accentColor)
            .imageScale(.large)
    }
}
    //MARK: - PREVIEW
struct ImageButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ImageButtonView(buttonImage: "bookmark")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
