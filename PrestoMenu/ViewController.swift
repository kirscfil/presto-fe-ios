//
//  ViewController.swift
//  PrestoMenu
//
//  Created by Filip Kirschner on 26/09/2017.
//  Copyright © 2017 Applifting. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var menu: Menu?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MenuItemCell", bundle: nil), forCellReuseIdentifier: MenuItemCell.reuseIdentifier)
        tableView.register(UINib(nibName: "MenuTitleCell", bundle: nil), forCellReuseIdentifier: MenuTitleCell.reuseIdentifier)
        MenuProvider.instance.fetchMenu { (menu) in
            self.menu = menu
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        PushManager.instance.requestTokenIfNecessary()
        SiriManager.instance.requestSiriAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.menu?.categories.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return menu?.categories[section-1].meals.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuTitleCell.reuseIdentifier, for: indexPath) as! MenuTitleCell
            if let date = self.menu?.date {
                cell.dateLabel.text = "\(date)"
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemCell.reuseIdentifier, for: indexPath) as! MenuItemCell
            if let food = self.menu?.categories[indexPath.section - 1].meals[indexPath.row] {
                cell.nameLabel.text = food.name
                if let price = food.basePrice {
                    cell.priceLabel.text = String(price) + " CZK"
                }
            }
            return cell
        }
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}

