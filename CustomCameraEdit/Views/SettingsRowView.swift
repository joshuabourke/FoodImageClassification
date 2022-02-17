//
//  SettingsRowView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 10/2/22.
//

import SwiftUI

struct SettingsRowView: View {
    //MARK: - PROPERTIES
    
    var name: String
    var content: String? = nil
    var linkLabel: String? = nil
    var linkDestination: String? = nil
    
    //MARK: - BODY
    var body: some View {
        VStack {
            Divider().padding(.vertical, 4)
            HStack {
                Text(name).foregroundColor(Color("grey1"))
                Spacer()
                if (content != nil) {
                    Text(content!)
                } else if (linkLabel != nil && linkDestination != nil) {
                  Link(linkLabel!, destination: URL(string: "https://\(linkDestination!)")!)
                        .foregroundColor(Color("yellow1"))
                    Image(systemName: "arrow.up.right.square").foregroundColor(Color("yellow1"))
                } else {
                    EmptyView()
                }
            }//: HSTACK
        }//: VSTACK
    }
}


    //MARK: - PREVIEW
struct SettingsRowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRowView(name: "Developer" ,content: " John / Jane")
            .previewLayout(.fixed(width: 375, height: 60))
            .padding()
        SettingsRowView(name: "Website", linkLabel: "Nutrify", linkDestination: "nutrify.app")
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 375, height: 60))
            .padding()
    }
}
