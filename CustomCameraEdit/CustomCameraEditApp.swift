//
//  CustomCameraEditApp.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 9/9/21.
//

import SwiftUI
import Firebase

@main
struct CustomCameraEditApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            CustomCameraPhotoView().environmentObject(ImageAndNameFeeder(addingItemName: "Test", itemImage: UIImage(named: "placeholder")!))
            
        }
    }
}
