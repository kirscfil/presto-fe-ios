//
//  MenuProvider.swift
//  PrestoMenu
//
//  Created by Filip Kirschner on 26/09/2017.
//  Copyright © 2017 Applifting. All rights reserved.
//

import Foundation

enum FoodCategory: String {
    case daily = "daily"
    case soup = "soup"
    case burger = "burger"
    case salad = "salad"
    case special = "special"
    case steak = "steak"
    case vegetarian = "vegetarian"
    
    var isWeekly: Bool {
        get {
            return self != .daily && self != .soup
        }
    }
}

struct Food {
    let name: String
    let price: Int?
    let weight: Int?
    let category: FoodCategory
    
    var typedName: String {
        get {
            switch category {
            case .burger:
                return "Burger: "+name
            case .steak:
                return "Steak: "+name
            case .salad:
                return "Salát: "+name
            case .special:
                return "Specialita: "+name
            case .vegetarian:
                return "Žádné maso: "+name
            default:
                return name
            }
        }
    }
}

struct Menu {
    
    let meals: [Food]
    let date: Date?
    
}

class MenuProvider {
    
    static let instance = MenuProvider()
    
    private(set) var menu: Menu?
    var soups: [Food]? {
        get {
            return menu?.meals.filter({ (food) -> Bool in
                food.category == .soup
            })
        }
    }
    var dailies: [Food]? {
        get {
            return menu?.meals.filter({ (food) -> Bool in
                food.category == .daily
            })
        }
    }
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


