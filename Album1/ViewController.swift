//
//  ViewController.swift
//  Album1
//
//  Created by MM on 7/13/20.
//  Copyright © 2020 MM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startBtnPressed(_ sender: UIButton) {
        let albumLocalVC = AlbumViewController(nibName: "AlbumViewController", bundle: nil)
        albumLocalVC.tabBarItem = UITabBarItem(title: "Local", image: UIImage(systemName: "person.2.square.stack"), selectedImage: UIImage(systemName: "person.2.square.stack"))
        let albumInternetVC = AlbumViewController(nibName: "AlbumViewController", bundle: nil)
        albumInternetVC.isFromInternet = true
        albumInternetVC.tabBarItem = UITabBarItem(title: "Internet", image: UIImage(systemName: "person.2.square.stack"), selectedImage: UIImage(systemName: "person.2.square.stack"))
        let tabBarVC = UITabBarController()
        tabBarVC.viewControllers = [albumLocalVC, albumInternetVC]
        navigationController?.pushViewController(tabBarVC, animated: true)
    }
    
}

