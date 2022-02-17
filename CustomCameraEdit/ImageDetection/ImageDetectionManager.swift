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
    var predictionLabel: String = ""
    var otherPossiblePredictions: [String] = []
    
    func detect(_ img: UIImage) -> (String?, [String]) {
        
        guard let pixelBuffer = img.toCVPixelBuffer() else {
                return ("", [])
            }
              let prediction = try? model.prediction(image: pixelBuffer)
        
                if let output = prediction {
                    let results = output.classLabelProbs.sorted {$0.1 > $1.1}
                    let result = results.prefix(3).map { (key, value) in
                        return "\(key)"
//                         \(String(format: "%.2f", value * 100))% Add this above to display the percentage
                    }
                    predictionLabel = result[0]
                    otherPossiblePredictions = [result[1], result[2]]
                }
            
        return (predictionLabel, otherPossiblePredictions)
    }
}
