//
//  MenuProvider.swift
//  PrestoMenu
//
//  Created by Filip Kirschner on 26/09/2017.
//  Copyright © 2017 Applifting. All rights reserved.
//

import Foundation

class MenuProvider {
    
    static let instance = MenuProvider()
    
    private(set) var menu: Menu?
    
    

    /*
    var soupsString: String {
        get {
            let count = self.soups?.count ?? 0
            return count == 1 ? "polévka" : (String(describing: count) + " polévky")
        }
    }
    var dailiesString: String {
        get {
            let count = self.dailies?.count ?? 0
            return count == 1 ? "hlavní jídlo" : (String(describing: count) + " hlavní jídla")
        }
    }
    */
    
    init(){
        fetchMenu(callback: nil)
    }
    
    func fetchMenu(callback: ((Menu?) -> ())?) {
        ApiClient.instance.getMenu { (success, menu) in
            self.menu = menu
            callback?(menu)
        }
    }
    
}


