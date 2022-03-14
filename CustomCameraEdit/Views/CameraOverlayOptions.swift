//
//  CameraOverlayOptions.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 17/2/22.
//

import SwiftUI

struct CameraOverlayOptions: View {
    //MARK: - PROPERTIES
    
    @Binding var didTapMe: Bool
    
    //MARK: - BODY
    var body: some View {
        Image(systemName: "person")
            .foregroundColor(Color.accentColor)
            .font(.title3)
            .frame(width: 30, height: 30, alignment: .center)
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .onTapGesture {
                didTapMe = true
            }
    }
}


    //MARK: - PREVIEW
struct CameraOverlayOptions_Previews: PreviewProvider {
    static var previews: some View {
        CameraOverlayOptions(didTapMe: .constant(false))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
