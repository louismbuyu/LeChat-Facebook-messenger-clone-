//
//  CustomTabBarController.swift
//  LeChat
//
//  Created by Louis Nelson Levoride on 29/07/16.
//  Copyright © 2016 LouisNelson. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let friendsController = FriendsController(collectionViewLayout: layout)
        let recentMessagesNavController = UINavigationController(rootViewController: friendsController)
        recentMessagesNavController.tabBarItem.title = "Chats"
        recentMessagesNavController.tabBarItem.image = UIImage(named: "messIcon@1x")
        
        
        viewControllers = [recentMessagesNavController]
    }
    
}
