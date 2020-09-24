//
//  CategoriesListViewController.swift
//  task
//
//  Created by islam on 9/24/20.
//

import UIKit
import RxSwift
import RxCocoa

class CategoriesListViewController: BaseViewController {

    var viewModel :CategoryListViewModel!

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.getCategories()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func previous(_ sender: Any) {
        
    }
    
    @IBAction func next(_ sender: Any) {
        
    }
    
}
//MARK: - Setup Methods
extension CategoriesListViewController {
    
    private func setup(){
        self.setupUI()
        self.setupBinding(with: self.viewModel)
    }
    
    private func setupUI() {
        self.configureNavigationWithAction(NSLocalizedString("Categories List", comment: ""), leftImage: nil, actionForLeft: nil, rightImage: nil, actionForRight: nil)
        let flowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        let cellWidth = (width - 10) / 2
        flowLayout.itemSize = CGSize(width: cellWidth, height: 140 )
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
    
    private func setupBinding(with viewModel: CategoryListViewModel){
        
        self.viewModel.categoriesTableData.asObservable()
            .bind(to: collectionView.rx.items) { (collectionView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell" , for: indexPath) as! CategoryCollectionViewCell
                cell.configure(category: element)
                return cell
            }
            .disposed(by: disposeBag)
        
        collectionView.rx
            .willDisplayCell
            .filter({[weak self] (cell, indexPath) in
                guard let `self` = self else { return false }
                return (indexPath.row + 1) == self.collectionView.numberOfItems(inSection: indexPath.section) - 3
            })
            .throttle(1.0, scheduler: MainScheduler.instance)
            .map({ event -> Void in
                return Void()
            })
            .bind(to: viewModel.callNextPage)
            .disposed(by: disposeBag)
        
        self.collectionView
            .rx
            .modelSelected(Category.self)
            .bind(to: viewModel.selectedCategory)
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
