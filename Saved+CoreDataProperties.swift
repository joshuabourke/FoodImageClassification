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

    @NSManaged public var dataFoodName: String?
    @NSManaged public var dataFoodDescription: String?
    @NSManaged public var dataFoodImage: Data?
    @NSManaged public var dataPredicPercent: String?
    @NSManaged public var dataFoodID: UUID
    @NSManaged public var dataDate: Date
    @NSManaged public var dataIsSaved: Bool
}

extension Saved : Identifiable {

}
