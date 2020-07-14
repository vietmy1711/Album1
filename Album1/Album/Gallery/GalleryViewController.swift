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
    
    var imagesFromLocal: PHFetchResult<PHAsset>?
    var imagesFromInternet: [String?] = []

    var isFromInternet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "GalleryCell", bundle: nil), forCellWithReuseIdentifier: "GalleryCell")
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFromInternet == false {
            scrollToBottom()
        }
    }
    
    func setupCollectionView() {
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = 10
        collectionViewFlowLayout.minimumInteritemSpacing = 10
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let size = CGSize(width:(collectionView!.bounds.width-50)/4, height: (collectionView!.bounds.width-50)/4)
        collectionViewFlowLayout.itemSize = size
    }
    
    func scrollToBottom() {
        if isFromInternet == true {
            if imagesFromInternet.count != 0 {
                collectionView.scrollToItem(at: IndexPath(row: imagesFromInternet.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
        else if imagesFromLocal!.count != 0 {
            collectionView.scrollToItem(at: IndexPath(row: imagesFromLocal!.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFromInternet == true {
            return imagesFromInternet.count
        }
        return imagesFromLocal!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as! GalleryCell
        if isFromInternet == true {
            cell.imvImage.downloaded(from: imagesFromInternet[indexPath.row]!)
            print(imagesFromInternet[indexPath.row]!)
            return cell
        }
        let asset = imagesFromLocal!.object(at: indexPath.row)
        PHCachingImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: nil) { (image, _) in
            cell.configWithImage(image)
           }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController(nibName: "DetailViewController", bundle: nil)
        if isFromInternet == true {
           // detailVC.imvImage.downloaded(from: imagesFromInternet[indexPath.row]!)
        } else {
            
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
