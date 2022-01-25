//
//  ImageDetectionManager.swift
//  Nutrify
//
//  Created by Josh Bourke on 14/6/21.
//

import Foundation
import CoreML
import UIKit

class ImageDetectionManager {
    
    let model = _0_0_2_FoodVisionV2_100_foods_manually_cleaned()
    
    
    func detect(_ img: UIImage) -> String? {
        
        guard let pixelBuffer = img.toCVPixelBuffer(),
              let prediction = try? model.prediction(image: pixelBuffer) else {
            return nil
        }
        return prediction.classLabel
    }
    
}
