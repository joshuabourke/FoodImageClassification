//
//  TabButtonView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 9/1/22.
//

import SwiftUI

//Tab Button
struct TabButtonView: View {
    //MARK: - PROPERTIES
    var title: String
    @Binding var selectedTab: String
    var animation: Namespace.ID
    
    //MARK: - BODY
    var body: some View {
        Button {
            withAnimation{selectedTab = title}
        } label: {
            VStack(spacing: 4){


                Image(systemName: title)
//                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(selectedTab == title ? Color.accentColor : Color.primary.opacity(0.2))
                    .frame(width: 23, height: 23, alignment: .center)
                Text(title.capitalized)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Color.primary.opacity(selectedTab == title ? 1 : 0.2))
                
                //Bottom Indicator...
                //Custom shape...
                
//                CustomShape()
//                        .fill(Color("tint").opacity(selectedTab == title ? 1 : 0))
//                        .frame(width: 45, height: 6)
//                        .padding(.bottom, 10)
                
            //Custom Shape with Animation
                ZStack {
                    CustomShape()
                        .fill(Color.clear)
                        .frame(width: 45, height: 4)
                    
                    if selectedTab == title {
                        CustomShape()
                            .fill(Color.accentColor)
                            .frame(width: 45, height: 4)
                            .matchedGeometryEffect(id: "Tab_Change", in: animation)
                    }
                }//: ZSTACK
            }//: VSTACK
            .padding(.bottom, 10)
        }//: BUTTON
    }
}


