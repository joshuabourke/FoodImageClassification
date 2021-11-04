//
//  Saved+CoreDataProperties.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 4/11/21.
//
//

import Foundation
import CoreData


extension Saved {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Saved> {
        return NSFetchRequest<Saved>(entityName: "Saved")
    }

    @NSManaged public var foodname: String?
    @NSManaged public var foodImage: Data?
    @NSManaged public var predictionPercent: String?

}

extension Saved : Identifiable {

}
