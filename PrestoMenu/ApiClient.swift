//
//  ApiClient.swift
//  PrestoMenu
//
//  Created by Filip Kirschner on 26/09/2017.
//  Copyright © 2017 Applifting. All rights reserved.
//

import Foundation

enum Endpoint: String {
    case menu = "/menu/today"
    case deviceToken = "/token"
}

class ApiClient {
    
    static var instance = ApiClient()
    
    private let baseURL = "http://prestomm.herokuapp.com"
    
    func getMenu(completion: (_ success: Bool, _ menu: Menu?) -> ()) {
        if let data = getJSON(urlToRequest: baseURL + Endpoint.menu.rawValue),
           let json = parseJSON(inputData: data),
           let array = json["menu"] as? NSArray {
            let meals = array.flatMap({ (dictionary) -> Food? in
                if let foodDictionary = dictionary as? [String: Any],
                   let name = foodDictionary["name"] as? String,
                   let category = foodDictionary["type"] as? String {
                    return Food(name: name,
                                price: foodDictionary["price"] as? Int,
                                weight: foodDictionary["weight"] as? Int,
                                category: FoodCategory(rawValue: category) ?? .daily)
                } else {
                    return nil
                }
            })
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let dateString = json["date"] as? String,
                let date = dateFormatter.date(from: dateString) {
                let menu = Menu(meals: meals, date: date)
                completion(true, menu)
            } else {
                completion(false, nil)
            }
        }
    }
    
    func sendToken(_ token: String, completion: (_ success: Bool) -> ()) {
        var request = URLRequest(url: URL(string: baseURL + Endpoint.deviceToken.rawValue)!)
        request.httpMethod = "POST"
        let postString = token
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
    }
    
    private func getJSON(urlToRequest: String) -> NSData? {
        if let url = URL(string: urlToRequest) {
            return NSData(contentsOf: url)
        } else {
            return nil
        }
    }
    
    private func parseJSON(inputData: NSData) -> [String: Any]? {
        do {
            let json = try JSONSerialization.jsonObject(with: inputData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
            return json
        } catch {
            return nil
        }
    }
    
}
