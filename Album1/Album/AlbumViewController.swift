//
//  AlbumViewController.swift
//  Album1
//
//  Created by MM on 7/13/20.
//  Copyright © 2020 MM. All rights reserved.
//

import UIKit
import Photos

class AlbumViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var albumList: PHFetchResult<PHAssetCollection>?
    
    var albums: [Album] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AlbumCell", bundle: nil), forCellReuseIdentifier: "AlbumCell")
        getAccess()
        getAlbums()
    }
    
    func getAccess() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.authorized) {
            // Access has been granted.
            albumList = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        }
        else if (status == PHAuthorizationStatus.denied) {
            // Access has been denied.
            self.navigationController?.popViewController(animated: true)
        }
        else if (status == PHAuthorizationStatus.notDetermined) {
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    self.albumList = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
                }
                else {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
        else if (status == PHAuthorizationStatus.restricted) {
            // Restricted access - normally won't happen.
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func getAlbums() {
        albums.removeAll()
        albumList = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        albumList!.enumerateObjects { (coll, _, _) in
            let result = self.getAssets(fromCollection: coll)
            self.albums.append(Album(title: coll.localizedTitle!, number: result.count))
        }
    }
    
    func getAssets(fromCollection collection: PHAssetCollection) -> PHFetchResult<PHAsset> {
        let photosOptions = PHFetchOptions()
        photosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        photosOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        return PHAsset.fetchAssets(in: collection, options: photosOptions)
    }
}

extension AlbumViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        cell.configWithAlbum(albums[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let galleryVC = GalleryViewController(nibName: "GalleryViewController", bundle: nil)
        let result = getAssets(fromCollection: albumList!.object(at: indexPath.row))
        galleryVC.images = result
        navigationController?.pushViewController(galleryVC, animated: true)
    }
}
