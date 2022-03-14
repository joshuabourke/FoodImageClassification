//
//  ReverseScalingAnimation.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 11/3/22.
//

import SwiftUI

struct ReversingScale: AnimatableModifier {
    
    var value: CGFloat
    
    private var target: CGFloat
    private var onEnd: () -> ()
    
    init(to value: CGFloat, onEnd: @escaping () -> () = {}) {
        self.target = value
        self.onEnd = onEnd
        self.value = value
    }
    
    var animatableData: CGFloat {
        get { value }
        set { value = newValue
        //newValue here is interpolating by engine, so changing from previous to  initially set, so when they got equal animation ended
        if newValue == target {
            onEnd()
            }
        }
    }
    func body(content: Content) -> some View {
        content.scaleEffect(value)
    }
}

