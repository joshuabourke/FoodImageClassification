//
//  ImageExtension.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 30/1/22.
//

import Foundation
import SwiftUI

//This will be used to crop out any un-need image for a more accurate prediction.

extension Image {
    func centerCropped() -> some View{
        GeometryReader { geo in
            self
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                .clipped(antialiased: true)
        }
        
        
    }
}
