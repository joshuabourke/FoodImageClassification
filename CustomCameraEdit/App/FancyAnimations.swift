//
//  FancyAnimations.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 8/11/21.
//

import Foundation
import SwiftUI

struct FancyAnimations : View {
    //MARK: - Public Properties
    
    let numberOfPages: Int
    let currentIndex: Int
    
    //MARK: - Drawing Constants
    
    private let circleSize: CGFloat = 16
    private let circleSpacing: CGFloat = 12
    
    private let primaryColour = Color.white
    private let secondaryColour = Color.white.opacity(0.6)
    
    private let smallScale: CGFloat = 0.6

    
    //MARK: - Body
    
    var body: some View{
        Spacer()
        VStack {
            Spacer()
            HStack(spacing: circleSpacing){
                ForEach(0..<numberOfPages) {index in // 1
                    if shouldShowIndex(index) {
                        Circle()
                            .fill(currentIndex == index ? primaryColour : secondaryColour) // 2
                            .scaleEffect(currentIndex == index ? 1 : smallScale)
                            
                            .frame(width: circleSize, height: circleSize)
                        
                            .transition(AnyTransition.opacity.combined(with: .scale)) // 3
                        
                            .id(index) // 4
                    }
                }
            }
        }
    }
    
    func shouldShowIndex(_ index:Int) -> Bool {
        ((currentIndex - 1)...(currentIndex + 1)).contains(index)
    
    }
}
