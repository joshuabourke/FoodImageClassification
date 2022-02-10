//
//  ViewExtension.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 29/1/22.
//

import SwiftUI

extension View {
    
    func pageLabel()-> some View {
        //Just Filling all empty Spacer...
        self.frame(maxWidth: .infinity, alignment: .center)
    }
    //Modifications for safeArea ignoring...
    //Same PageView
    func pageView(ignoresSafeArea: Bool = false, edges: Edge.Set = []) -> some View {
        
        //Just filling all the empty space...
        
        self
            .frame(width: getScreenBounds().width, height: getScreenBounds().height, alignment: .center)
            .ignoresSafeArea(ignoresSafeArea ? .container : .init(), edges: edges)
    }
    //Getting Screen Bounds...
    func getScreenBounds()-> CGRect {
        return UIScreen.main.bounds
    }
}
