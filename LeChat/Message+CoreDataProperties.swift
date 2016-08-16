//
//  Message+CoreDataProperties.swift
//  LeChat
//
//  Created by Louis Nelson Levoride on 29/07/16.
//  Copyright © 2016 LouisNelson. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Message {

    @NSManaged var date: NSDate?
    @NSManaged var text: String?
    @NSManaged var isSender: NSNumber?
    @NSManaged var friend: Friend?

}
