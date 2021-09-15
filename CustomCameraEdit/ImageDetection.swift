//
//  ImageDetection.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 16/9/21.
//

import Foundation
import SwiftUI

class ImageDetection: ObservableObject {
    
    @ObservedObject var imageDetectionVM: ImageDetectionViewModel
    var imageDetectionManager: ImageDetectionManager
    
    init(){
        self.imageDetectionManager = ImageDetectionManager()
        self.imageDetectionVM = ImageDetectionViewModel(manager: imageDetectionManager)
    }
    
}
