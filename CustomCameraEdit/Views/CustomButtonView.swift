//
//  CustomButtonView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 8/1/22.
//

import SwiftUI

struct CustomButtonView: View {
    //MARK: - PROPERTIES
    
    var buttonLabel: String
    
    //MARK: - BODY
    var body: some View {
        Image(systemName: buttonLabel)
        
    }
}
    //MARK: - PREVIEW
struct CustomButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CustomButtonView(buttonLabel: "camera")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
