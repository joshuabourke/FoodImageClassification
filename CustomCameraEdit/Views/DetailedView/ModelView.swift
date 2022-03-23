//
//  ModelView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 9/1/22.
//

import SwiftUI

class ModelView: ObservableObject {
    @Published  var isBookMarkLoaded = false
    
    //Load initial Screen
    init() {
        print("Camera Loaded")
    }
    func loadBookMark(){
        print("bookmark Loaded")
        isBookMarkLoaded = true
    }
    
}
