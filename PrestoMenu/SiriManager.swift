//
//  SiriManager.swift
//  PrestoMenu
//
//  Created by Filip Kirschner on 03/10/2017.
//  Copyright © 2017 Applifting. All rights reserved.
//

import Foundation
import Intents

class SiriManager {
    
    public static var instance = SiriManager()
    
    public func requestSiriAuthorization() {
        INPreferences.requestSiriAuthorization { (status) in
            print(status == INSiriAuthorizationStatus.authorized)
        }
    }
    
}
