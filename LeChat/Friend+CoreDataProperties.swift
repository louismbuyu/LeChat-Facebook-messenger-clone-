//
//  Friend+CoreDataProperties.swift
//  LeChat
//
//  Created by Louis Nelson Levoride on 26/07/16.
//  Copyright © 2016 LouisNelson. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Friend {

    @NSManaged var name: String?
    @NSManaged var profileImageName: String?
    @NSManaged var message: NSSet?

}
