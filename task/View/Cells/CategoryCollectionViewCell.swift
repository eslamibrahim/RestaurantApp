//
//  CategoryCollectionViewCell.swift
//  task
//
//  Created by islam on 9/24/20.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryName: UILabel!
    
    func configure(category : Category){
        categoryName.text = category.name
    }
}
