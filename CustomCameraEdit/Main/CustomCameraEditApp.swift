//
//  CustomCameraEditApp.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 9/9/21.
//

import SwiftUI
import CoreData
import Firebase

@main
struct CustomCameraEditApp: App {
    let persistentContainer = MyPersistentController.shared
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
   
    var body: some Scene {
        WindowGroup {
            CustomCameraPhotoView().environmentObject(ImageAndNameFeeder(addingItemName: "Test", itemImage: UIImage(named: "placeholder")!)).environment(\.managedObjectContext, persistentContainer.container.viewContext)
            
        }
    }
}
