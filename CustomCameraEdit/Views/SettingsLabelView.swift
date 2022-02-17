//
//  SettingsLabelView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 10/2/22.
//

import SwiftUI

struct SettingsLabelView: View {
    //MARK: - PROPERTIES
    var labelText: String
    var labelImage: String
    
    
    //MARK: - BODY
    var body: some View {
        HStack {
            Text(labelText.uppercased()).fontWeight(.bold)
            Spacer()
            Image(systemName: labelImage)
                .foregroundColor(Color("yellow1"))
        }//: HSTACK
    }
}

    //MARK: - PREVIEW
struct SettingsLabelView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsLabelView(labelText: "Nutrify", labelImage: "info.circle")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
