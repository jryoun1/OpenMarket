//
//  ItemUploadViewController.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/20.
//

import UIKit

final class ItemUploadViewController: UIViewController {
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var verticalStackView: UIStackView!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var stockTextView: UITextView!
    @IBOutlet weak var priceTextView: UITextView!
    @IBOutlet weak var discountedPriceTextView: UITextView!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var passwordCheckTextfield: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    static let identifier = "ItemUploadViewController"
    private var itemUploadViewModel = ItemUploadViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImageCollectionView()
        bindViewModel()
    }
    
    private func configureImageCollectionView() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        let headerViewNib = UINib(nibName: ItemUploadCollectionReusableHeaderView.identifier, bundle: nil)
        imageCollectionView.register(headerViewNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ItemUploadCollectionReusableHeaderView.identifier)
        let nib = UINib(nibName: ItemUploadCollectionViewCell.identifier, bundle: nil)
        imageCollectionView.register(nib, forCellWithReuseIdentifier: ItemUploadCollectionViewCell.identifier)
    }
    
    private func bindViewModel() {
        itemUploadViewModel.selectedImages.bind({ [weak self] _ in
            DispatchQueue.main.async {
                self?.imageCollectionView.reloadData()
            }
        })
    }
}

//MARK:- CollectionView Delegate, DataSource, DelegateFlowLayout
extension ItemUploadViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return itemUploadViewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemUploadViewModel.selectedImages.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemUploadCollectionViewCell.identifier, for: indexPath) as? ItemUploadCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.deleteImageDelegate = self
        
        if let image = itemUploadViewModel.selectedImages.value?[indexPath.row] {
            cell.tag = indexPath.row
            cell.configure(image: image)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ItemUploadCollectionReusableHeaderView.identifier, for: indexPath) as? ItemUploadCollectionReusableHeaderView else {
                return UICollectionReusableView()
            }
            headerView.updateSelectedImagesDelegate = self
            headerView.configure(data: itemUploadViewModel.selectedImages.value?.count ?? 0)
            
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

//MARK:- DeleteImage protocol
extension ItemUploadViewController: DeleteImage {
    func delete(index: Int) {
        _ = itemUploadViewModel.selectedImages.value?.remove(at: index)
    }
}

//MARK:- UpdateSelectedImages protocol
extension ItemUploadViewController: UpdateSelectedImages {
    func update(images: [UIImage]) {
        _ = itemUploadViewModel.selectedImages.value?.append(contentsOf: images)
    }
}
