//
//  Notification.swift
//  Foodini
//
//  Created by Zach Nafziger on 3/14/16.
//  Copyright © 2016 Gooey. All rights reserved.
//

import Foundation
import Parse

//used for push notifications
class Notification {
    var message: String = ""
    var sendToID: String? = ""
    
    func push() {
        let pushQuery = PFInstallation.query()!
        do {
            let user = try PFQuery.getUserObjectWithId(sendToID!)
            pushQuery.whereKey("user", equalTo: user)
            let push = PFPush()
            let pushData = ["alert" : message, "badge" : "Increment"]
            push.setQuery(pushQuery)
            push.setData(pushData)
            push.sendPushInBackground()
        } catch {
            NSLog("could not find user with id " + sendToID!)
            
        }
        
    }
    
    init(content: String, sendToID: String) {
        self.message = content
        self.sendToID = sendToID
    }
}