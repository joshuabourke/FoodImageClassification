//
//  BlankView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 17/2/22.
//

import SwiftUI

struct BlankView: View {
    //MARK: - PROPERTIES
    var backgroundColor: Color
    var backgroundOpacity: Double
    
    //MARK: - BODY
    var body: some View {
        VStack{
            Spacer()
            //Just to cover the whole screen
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(backgroundColor)
        .opacity(backgroundOpacity)
        .edgesIgnoringSafeArea(.all)
    }
}

    //MARK: - PREVIEW
struct BlankView_Previews: PreviewProvider {
    static var previews: some View {
        BlankView(backgroundColor: Color.black, backgroundOpacity: 0.3)
    }
}
