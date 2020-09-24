//
//  ProductDetailsPopUpViewController.swift
//  task
//
//  Created by islam on 9/24/20.
//

import UIKit

class ProductDetailsPopUpViewController: UIViewController {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    var product : Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    func setupUI()  {
        self.productImage.downloadImageWithCaching(with: product.image ?? "", placeholderImage: UIImage(named: "placeholder-image"))
        self.productName.text = product.name
        self.productPrice.text = String(product.price ?? 0) + " USD"
    }
}
