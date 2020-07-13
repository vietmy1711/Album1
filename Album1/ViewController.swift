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
        let albumVC = AlbumViewController(nibName: "AlbumViewController", bundle: nil)
        albumVC.navigationItem.title = "Album"
        navigationController?.pushViewController(albumVC, animated: true)
    }
    
}

