//
//  ContentView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 9/1/22.
//

import SwiftUI

struct ContentView: View {
    //MARK: - PROPERTIES
    
    @State var currentSelection: Int = 0
    @State var isCurrentlySelected: Bool = true
    
    //MARK: - BODY
    var body: some View {
        
        PagerTabView(selection: $currentSelection, isSelected: $isCurrentlySelected) {
            
            VStack(spacing: 0) {
                Image(systemName: "camera")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
//                    .padding(.vertical, 10)
                    .foregroundColor(isCurrentlySelected ? Color.accentColor : Color.gray)
                    .opacity(isCurrentlySelected ? 1 : 0.3)
                .pageLabel()
            
                Text("Camera")
                    .fontWeight(.medium)
                    .font(.system(size: 10))
                    .foregroundColor(isCurrentlySelected ? Color.accentColor : Color.gray)
                    .opacity(isCurrentlySelected ? 1 : 0.3)
//                    .padding(0)
            }//: VSTACK
            
                
                
            
            VStack(spacing: 0) {
                Image(systemName: "bookmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
//                    .padding(.vertical, 10)
                    .foregroundColor(isCurrentlySelected ? Color.gray : Color.accentColor)
                    .opacity(isCurrentlySelected ? 0.3 : 1)
                .pageLabel()
                
                Text("Saved")
                    .fontWeight(.medium)
                    .font(.system(size: 10))
                    .foregroundColor(isCurrentlySelected ? Color.gray : Color.accentColor)
                    .opacity(isCurrentlySelected ? 0.3 : 1)
//                    .padding(0)
            }//: VSTACK
           
                
                
                
            
        } content: {
            //Tab 1.
            CustomCameraPhotoView()
                .pageView(ignoresSafeArea: false, edges: .top)
            
            //Tab 2.
            SavedFoodListView(testJson: testJson1[0])
                .pageView(ignoresSafeArea: false, edges: .top)
            
        }
        

    }
}
    //MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
