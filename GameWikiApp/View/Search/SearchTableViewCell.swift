//
//  SearchTableViewCell.swift
//  GameApp
//
//  Created by Celil Aydın on 5.02.2023.
//

import UIKit
import SDWebImage

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var searchNameLabel: UILabel!
    @IBOutlet weak var searchImageView: UIImageView!
    
    static var identifier = "searchCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(with model: SearchData){
        DispatchQueue.main.async {
            self.searchNameLabel.text = model.name
            self.searchImageView.sd_setImage(with: URL(string: model.backgroundImage))
        }
    }
    
}
