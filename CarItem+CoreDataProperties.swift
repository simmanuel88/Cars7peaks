//
//  CarItem+CoreDataProperties.swift
//  
//
//  Created by Roche on 19/05/21.
//
//

import Foundation
import CoreData


extension CarItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CarItem> {
        return NSFetchRequest<CarItem>(entityName: "CarItem")
    }

    @NSManaged public var title: NSObject?
    @NSManaged public var dateTime: NSObject?
    @NSManaged public var ingress: NSObject?
    @NSManaged public var image: NSObject?
    @NSManaged public var thumbnail: NSObject?

}
