//
//  FavoriteTableViewCell.swift
//  GameWikiApp
//
//  Created by Celil Aydın on 7.02.2023.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favoriteNameLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
