//
//  HomeCollectionViewCell.swift
//  GameApp
//
//  Created by Celil Aydın on 5.02.2023.
//

import UIKit
import SDWebImage

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with model: SearchData){
        DispatchQueue.main.async {
            self.gameNameLabel.text = model.name
            self.gameImageView.sd_setImage(with: URL(string: model.backgroundImage))
        }
    }

}
