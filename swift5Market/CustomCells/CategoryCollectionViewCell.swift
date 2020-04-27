//
//  CategoryCollectionViewCell.swift
//  swift5Market
//
//  Created by 酒井専冴 on 2020/04/27.
//  Copyright © 2020 atsuki_sakai. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func toFields(_ category: Category) {
        
        self.contentImageView.image = category.image
        self.nameLabel.text = category.name
        
    }
    
    
}
