//
//  ShareSheet.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 25/2/22.
//

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    
    // the data you need to share...
    
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        return controller
        
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
    
}
