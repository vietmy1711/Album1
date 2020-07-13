//
//  AlbumCell.swift
//  Album1
//
//  Created by MM on 7/13/20.
//  Copyright © 2020 MM. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configWithAlbum(_ album: Album) {
        lblName.text = album.title
        lblNumber.text = String(album.number)
    }
}
