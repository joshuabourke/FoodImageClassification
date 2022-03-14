//
//  ARViewSwitchButton.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 14/3/22.
//

import SwiftUI

struct ARViewSwitchButton: View {
    //MARK: - PROPERTIES
    
    @Binding var didTapMe: Bool
    
    //MARK: - BODY
    var body: some View {
        Image(systemName: "cube")
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
struct ARViewSwitchButton_Previews: PreviewProvider {
    static var previews: some View {
        ARViewSwitchButton(didTapMe: .constant(false))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
