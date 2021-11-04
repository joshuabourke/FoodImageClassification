//
//  ImageDetectionViewModel.swift
//  Nutrify
//
//  Created by Josh Bourke on 14/6/21.
//

import Foundation
import SwiftUI
import Combine

class ImageDetectionViewModel: ObservableObject{
    
    var name: String = ""
    var manager: ImageDetectionManager
  @Published  var predictionLabel: String = ""
    
    init(manager: ImageDetectionManager) {
        self.manager = manager
    }
    
    func detect(_ image: UIImage?) {
        
        let sourceImage = image
        
        guard let resizedImage = sourceImage?.resizeImage(targetSize: CGSize(width: 299, height: 299)) else {
            fatalError("Unable to resize the image!")
        }
        
        if let label = self.manager.detect(resizedImage) {
            self.predictionLabel = label
        }
        
        //update prediction label with the image prediction
        
    }
}
