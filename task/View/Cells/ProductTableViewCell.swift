//
//  ProductTableViewCell.swift
//  task
//
//  Created by islam on 9/24/20.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(product : Product)  {
        self.productImage.downloadImageWithCaching(with: product.image ?? "", placeholderImage: UIImage(named: "placeholder-image"))
        self.productName.text = product.name
        self.productPrice.text = String(product.price ?? 0) + " USD"
        
    }

}
