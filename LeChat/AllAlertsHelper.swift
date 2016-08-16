//
//  AllAlertsHelper.swift
//  LeChat
//
//  Created by Louis Nelson Levoride on 11/08/16.
//  Copyright © 2016 LouisNelson. All rights reserved.
//

import Foundation
import UIKit

class ShowAlert {
    
    let controller: UIViewController
    
    init(controller: UIViewController){
        self.controller = controller
    }
    
    func show(message: String, title: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let close = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alert.addAction(close)
        //alert.addAction(okay)
        controller.presentViewController(alert, animated: true, completion: nil)
    }
}


