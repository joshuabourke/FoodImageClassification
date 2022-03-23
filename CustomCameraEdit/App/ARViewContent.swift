//
//  ARView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 15/3/22.
//

import SwiftUI
import RealityKit
import ARKit

struct ARContentView: View {
    //MARK: - PROPERTIES
    
    //MARK: - BODY
    var body: some View {
        
        ZStack {
            ARViewContainer()
            
            Crosshair()
            
        }//: ZSTACK
        
        
    }
}
struct ARViewContainer: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = ARView
    
    func makeUIViewController(context: Context) -> ARView {
        return ARView()
    }
    
    func updateUIViewController(_ uiViewController: ARView, context: Context) {
        
    }
}
    //MARK: - PREVIEW
struct ARView_Previews: PreviewProvider {
    static var previews: some View {
        ARContentView()
    }
}
