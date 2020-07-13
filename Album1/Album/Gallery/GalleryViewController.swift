//
//  GalleryViewController.swift
//  Album1
//
//  Created by MM on 7/13/20.
//  Copyright © 2020 MM. All rights reserved.
//

import UIKit
import Photos

class GalleryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var images: PHFetchResult<PHAsset>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "GalleryCell", bundle: nil), forCellWithReuseIdentifier: "GalleryCell")
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = 10
        collectionViewFlowLayout.minimumInteritemSpacing = 10
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let size = CGSize(width:(collectionView!.bounds.width-50)/4, height: (collectionView!.bounds.width-50)/4)
        collectionViewFlowLayout.itemSize = size
    }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as! GalleryCell
        let asset = images!.object(at: indexPath.row)
        PHCachingImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: nil) { (image, _) in
            cell.configWithImage(image)
           }
        cell.backgroundColor = .systemTeal
        return cell
    }
    
}
