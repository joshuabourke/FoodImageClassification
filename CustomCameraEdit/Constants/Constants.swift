//
//  Constants.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 29/1/22.
//

import Foundation
import UIKit


//Default Json preview.
let testJson1: [Test] = Bundle.main.decode("TestApple.json")

//let foodJSON: [FoodJSON] = Bundle.main.decode("FILE_8252.json")

let foodJSON = Bundle.main.decodeFoodJSON([FoodJSON].self, from: "FILE_8252.json")

//MARK: - UX
let feedback = UINotificationFeedbackGenerator()


