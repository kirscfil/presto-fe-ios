//
//  TodayViewController.swift
//  PrestoMenu Widget
//
//  Created by Filip Kirschner on 26/09/2017.
//  Copyright © 2017 Applifting. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var menu: Menu?
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MenuProvider.instance.fetchMenu { (menu) in
            self.menu = menu
            self.collectionView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        MenuProvider.instance.fetchMenu { (menu) in
            self.menu = menu
            self.collectionView.reloadData()
        }
        completionHandler(NCUpdateResult.newData)
    }
    
    @IBAction func nextButtonPressed() {
        scrollBy(1)
    }
    
    @IBAction func previousButtonPressed() {
        scrollBy(-1)
    }
    
    var currentIndex = 0;
    
    private func scrollBy(_ amount: Int){
        if let menu = menu, menu.meals.count != 0 {
            var targetIndex = (currentIndex + amount) % menu.meals.count
            if targetIndex < 0 {
                targetIndex = menu.meals.count - 1
            }
            scrollTo(targetIndex)
        }
    }
    
    private func scrollTo(_ index: Int){
        currentIndex = index
        collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: UICollectionViewScrollPosition.left, animated: true)
    }
    
    @IBOutlet weak var reloadButton: UIButton!
    
    @IBAction func reloadPressed() {
        UIView.animate(withDuration: 0.5, animations: {
            self.reloadButton?.imageView?.transform = self.reloadButton!.imageView!.transform.rotated(by: CGFloat(Double.pi*2))
        })
        MenuProvider.instance.fetchMenu { (menu) in
            self.menu = menu
            self.collectionView.reloadData()
            self.scrollTo(0)
        }
    }
}

extension TodayViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let menu = menu else {
            return 0
        }
        return menu.meals.count == 0 ? 0 : menu.meals.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == menu?.meals.count {
            let view = collectionView.dequeueReusableCell(withReuseIdentifier: "logoCell", for: indexPath)
            return view
        } else {
            let view = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuReusableCell
            let food = menu!.meals[indexPath.row]
            view.nameLabel?.text = food.typedName
            view.priceLabel?.text = food.price == nil ? nil : String(describing: food.price!) + " Kč"
            view.weightLabel?.text = food.weight == nil ? nil : String(describing: food.weight!) + "g  "
            return view
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == menu!.meals.count {
            return CGSize(width: 64, height: self.view.frame.height - 30)
        } else {
            return CGSize(width: self.view.frame.width - 64, height: self.view.frame.height - 30)
        }
    }
    
}
