//
//  CategoryDetailsViewController.swift
//  task
//
//  Created by islam on 9/24/20.
//

import UIKit
import RxSwift
import RxCocoa

class ProductsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel : ProductsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        viewModel.getProducts()
        
    }
    

}
//MARK: - Setup Methods
extension ProductsViewController {
    
    private func setup(){
        self.setupUI()
        self.setupBinding(with: self.viewModel)
    }
    
    private func setupUI() {
        self.configureNavigationWithAction(NSLocalizedString("Product List", comment: ""), leftImage: UIImage(named: "backArrow"), actionForLeft: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
            
        }, rightImage: nil, actionForRight: nil)
    }
    
    private func setupBinding(with viewModel: ProductsViewModel){
        
        self.viewModel.productsTableData.asObservable()
            .bind(to: tableView.rx.items) { (table, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = table.dequeueReusableCell(withIdentifier: "ProductTableViewCell" , for: indexPath) as! ProductTableViewCell
                cell.configure(product: element)
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .willDisplayCell
            .filter({[weak self] (cell, indexPath) in
                guard let `self` = self else { return false }
                return (indexPath.row + 1) == self.tableView.numberOfRows(inSection: indexPath.section) - 3
            })
            .throttle(1.0, scheduler: MainScheduler.instance)
            .map({ event -> Void in
                return Void()
            })
            .bind(to: viewModel.callNextPage)
            .disposed(by: disposeBag)
        
        self.tableView
            .rx
            .modelSelected(Product.self)
            .bind(to: viewModel.selectedProduct)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .distinctUntilChanged()
            .drive(onNext: { [weak self] (isLoading) in
                guard let `self` = self else { return }
                self.hideActivityIndicator()
                if isLoading {
                    self.showActivityIndicator()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.alertDialog.observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] (title, message) in
                guard let `self` = self else {return}
            self.showAlertDialogue(title: title, message: message)
            }).disposed(by: disposeBag)
    }
    
}
