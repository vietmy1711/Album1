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
    
    var isFromInternet = false
    
    var imagesFromInternet: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AlbumCell", bundle: nil), forCellReuseIdentifier: "AlbumCell")
        if isFromInternet == true {
            getImagesFromInternet()
        } else {
            getAccess()
            getAlbums()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.title = "Local"
        if isFromInternet == true {
            tabBarController?.navigationItem.title = "Internet"
        }
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
            self.albums.append(Album(title: coll.localizedTitle!, number: result.count, images: []))
        }
    }
    
    func getAssets(fromCollection collection: PHAssetCollection) -> PHFetchResult<PHAsset> {
        let photosOptions = PHFetchOptions()
        photosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        photosOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        return PHAsset.fetchAssets(in: collection, options: photosOptions)
    }
    
    func getImagesFromInternet() {
        for i in 1...10 {
            var album = Album(title: "Album \(i)", number: 100, images: [])
            for j in 1...100 {
                album.images.append("https://picsum.photos/id/\(i)\(j)/1000")
            }
            albums.append(album)
        }
    }
}

extension AlbumViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        cell.configWithAlbum(albums[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let galleryVC = GalleryViewController(nibName: "GalleryViewController", bundle: nil)
        if isFromInternet == true {
            galleryVC.isFromInternet = true
            galleryVC.imagesFromInternet = albums[indexPath.row].images
            galleryVC.navigationItem.title = albums[indexPath.row].title
        } else {
            let result = getAssets(fromCollection: albumList!.object(at: indexPath.row))
            galleryVC.imagesFromLocal = result
            galleryVC.navigationItem.title = albumList!.object(at: indexPath.row).localizedTitle
        }
        navigationController?.pushViewController(galleryVC, animated: true)
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
