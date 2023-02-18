//
//  DetailCollectionViewCell.swift
//  GameWikiApp
//
//  Created by Celil Aydın on 7.02.2023.
//

import Foundation
import UIKit
import SDWebImage

class DetailCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: DetailCollectionViewCell.self)
    
    @IBOutlet weak var gameImageView: UIImageView!
    
    func configure(_ slide: ShortScreenshot) {
        gameImageView.sd_setImage(with: URL(string: slide.image))
    }
    
}
