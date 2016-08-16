//
//  FriendControllerHelper.swift
//  LeChat
//
//  Created by Louis Nelson Levoride on 26/07/16.
//  Copyright © 2016 LouisNelson. All rights reserved.
//

import UIKit
import CoreData

extension FriendsController{
    
    /*This function clears all the data before retrieving it again*/
    func clearData(){
        
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext
        {
            do {
                
                let entityNames = ["Friend","Message"]
                
                for entityName in entityNames {
                    
                    let fetchRequest = NSFetchRequest(entityName: entityName)
                    
                    let objects = try context.executeFetchRequest(fetchRequest) as? [NSManagedObject]
                    
                    for object in objects!
                    {
                        context.deleteObject(object)
                    }
                }
                
                try context.save()
                
            }catch let err{
                ShowAlert(controller: self).show("\(err)", title: "Error")
            }
        }
        
    }
    
    /*using dummy data and saving it into coreData*/
    func setupData()
    {
        clearData()
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext
        {
            let mark = NSEntityDescription.insertNewObjectForEntityForName("Friend", inManagedObjectContext: context) as! Friend
            mark.name = "Mark Zuckerberg"
            mark.profileImageName = "mark"
            
            let messageMark = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: context) as! Message
            messageMark.friend = mark
            messageMark.text = "Hello my name is Mark. Nice to meet you"
            messageMark.date = NSDate()
            
            createSteveMessagesWithContext(context)
            
            let donald = NSEntityDescription.insertNewObjectForEntityForName("Friend", inManagedObjectContext: context) as! Friend
            donald.name = "Donald trump"
            donald.profileImageName = "donald_profile"
            
            FriendsController.createMessageText("You're fired", friend: donald, mintuesAgo: 5, context: context)
            
            let gandhi = NSEntityDescription.insertNewObjectForEntityForName("Friend", inManagedObjectContext: context) as! Friend
            gandhi.name = "Mahatma Gandhi"
            gandhi.profileImageName = "gandhi_profile"
            
            FriendsController.createMessageText("Love, Peace, and Joy", friend: gandhi, mintuesAgo: 60*24, context: context)
            
            let hillary = NSEntityDescription.insertNewObjectForEntityForName("Friend", inManagedObjectContext: context) as! Friend
            hillary.name = "Hillary Clinton"
            hillary.profileImageName = "hillary_profile"
            
            FriendsController.createMessageText("Me for her", friend: hillary, mintuesAgo: 8*60*24, context: context)
            
            do
            {
                try context.save()
            } catch let err{
                ShowAlert(controller: self).show("\(err)", title: "Error")
            }
        }
        loadData()
    }
    
    private func createSteveMessagesWithContext(context: NSManagedObjectContext)
    {
        let steve = NSEntityDescription.insertNewObjectForEntityForName("Friend", inManagedObjectContext: context) as! Friend
        steve.name = "Steve Jobs"
        steve.profileImageName = "steve"
        
        FriendsController.createMessageText("Good morning..", friend: steve, mintuesAgo: 3, context: context)
        FriendsController.createMessageText("hello, how are you? Hope you are having a good morning", friend: steve, mintuesAgo: 2, context: context)
        FriendsController.createMessageText("Are you interested in buying an Apple device? We have a wide variety of Apple device that will suit your needs. Please make your purchase with us", friend: steve, mintuesAgo: 1, context: context)
        FriendsController.createMessageText("Yes totally looking foward to buying an iPhone 7 plus sxs. ;) ", friend: steve, mintuesAgo: 1, context: context, isSender: true)
        FriendsController.createMessageText("I totally understand that you want the new iPhone 7 but you will have to wait till september", friend: steve, mintuesAgo: 1, context: context)
        FriendsController.createMessageText("Okay fine ", friend: steve, mintuesAgo: 1, context: context, isSender: true)
        
    }
    
    static func createMessageText(text: String, friend: Friend, mintuesAgo: Double, context: NSManagedObjectContext, isSender: Bool = false) -> Message
    {
        let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: context) as! Message
        message.friend = friend
        message.text = text
        message.date = NSDate().dateByAddingTimeInterval(-mintuesAgo*60)
        message.isSender = NSNumber(bool: isSender)
        return message
    }
    
    func loadData()
    {
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext
        {
            if let friends = fetchFriends()
            {
                messages = [Message]()
                for friend in friends
                {
                    let fetchRequest = NSFetchRequest(entityName: "Message")
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                    fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                    fetchRequest.fetchLimit = 1
                    
                    do {
                        let fetchMessages = try(context.executeFetchRequest(fetchRequest)) as? [Message]
                        messages?.appendContentsOf(fetchMessages!)
                    }catch let err{
                        print(err)
                    }
                }
                messages = messages?.sort({$0.date!.compare($1.date!) == .OrderedDescending})
            }
        }
    }
    
    private func fetchFriends() -> [Friend]?
    {
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        if let context = delegate?.managedObjectContext
        {
            let request = NSFetchRequest(entityName: "Friend")
            
            do {
                return try context.executeFetchRequest(request) as? [Friend]
                
            }catch let err{
                ShowAlert(controller: self).show("\(err)", title: "Error")
            }
        }
        return nil
    }
}
