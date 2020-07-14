//
//  GalleryCell.swift
//  Album1
//
//  Created by MM on 7/13/20.
//  Copyright © 2020 MM. All rights reserved.
//

import UIKit

class GalleryCell: UICollectionViewCell {

    @IBOutlet weak var imvImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configWithImage(_ image: UIImage?) {
//        DispatchQueue.main.async {
            self.imvImage.image = image

//        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imvImage.image = nil
    }
}
