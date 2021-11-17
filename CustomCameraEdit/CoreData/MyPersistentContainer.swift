//
//  MyPersistentContainer.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 15/11/21.
//

import CoreData

struct MyPersistentController {
    static let shared = MyPersistentController()
    
    let container: NSPersistentContainer
    
    init(){
        container = NSPersistentContainer(name: "SavedFoodDataModel")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolve Error: \(error)")
            }
        }
    }
}
