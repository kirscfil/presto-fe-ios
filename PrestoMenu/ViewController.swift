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
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return MenuProvider.instance.soups?.count ?? 0
        case 2:
            return MenuProvider.instance.dailies?.count ?? 0
        case 3:
            return menu?.meals.filter({ $0.category.isWeekly }).count ?? 0
        default:
            return 0
        }
        if section == 0 {
            return 1
        } else {
            guard let menu = menu else {
                return 0
            }
            return section == 0 ? 1 : menu.meals.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuTitleCell.reuseIdentifier, for: indexPath) as! MenuTitleCell
            if let date = self.menu?.date {
                cell.dateLabel.text = "\(date)"
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemCell.reuseIdentifier, for: indexPath) as! MenuItemCell
            if let food = MenuProvider.instance.soups?[indexPath.row] {
                cell.nameLabel.text = food.name
                if let price = food.price {
                    cell.priceLabel.text = String(price) + " CZK"
                }
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemCell.reuseIdentifier, for: indexPath) as! MenuItemCell
            if let food = MenuProvider.instance.dailies?[indexPath.row] {
                cell.nameLabel.text = food.name
                if let price = food.price {
                    cell.priceLabel.text = String(price) + " CZK"
                }
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemCell.reuseIdentifier, for: indexPath) as! MenuItemCell
            if let food = menu?.meals.filter({ $0.category.isWeekly })[indexPath.row] {
                cell.nameLabel.text = food.name
                if let price = food.price {
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

