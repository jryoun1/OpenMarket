//
//  ItemDetailViewController.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/29.
//

import UIKit

final class ItemDetailViewController: UIViewController {
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    private var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.darkGray
        return pageControl
    }()
    
    static let identifier = "ItemDetailViewController"
    private var itemDetailViewModel: ItemDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImageCollectionView()
        configurePageControl()
        bindViewModel()
    }
    
    private func configureImageCollectionView() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(ItemDetailCollectionViewCell.self, forCellWithReuseIdentifier: ItemDetailCollectionViewCell.identifier)
        imageCollectionView.showsHorizontalScrollIndicator = false
        imageCollectionView.isPagingEnabled = true
    }
    
    private func configurePageControl() {
        self.view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 280)
        ])
    }
    
    private func bindViewModel() {
        itemDetailViewModel?.titleLabeltext.bind({ [weak self] text in
            DispatchQueue.main.async {
                self?.titleLabel.text = text
            }
        })
        
        itemDetailViewModel?.stockTextLabeltext.bind({ [weak self] text in
            DispatchQueue.main.async {
                if text == ItemListViewString.soldOut {
                    self?.stockLabel.textColor = .systemOrange
                }
                else {
                    self?.stockLabel.textColor = .systemGray
                }
                self?.stockLabel.text = text
            }
        })
        
        itemDetailViewModel?.priceLabeltext.bind({ [weak self] text in
            DispatchQueue.main.async {
                self?.priceLabel.attributedText = NSAttributedString(string: text ?? "")
            }
        })
        
        itemDetailViewModel?.discountedPriceLabeltext.bind({ [weak self] text in
            if let text = text, !text.isEmpty {
                DispatchQueue.main.async {
                    self?.discountedLabel.isHidden = false
                    self?.discountedLabel.text = text
                    
                    self?.priceLabel.textColor = .systemRed
                    self?.priceLabel.attributedText = self?.changeToStrikethroughStyle(string: self?.priceLabel.text! ?? "")
                }
            }
            else {
                DispatchQueue.main.async {
                    self?.discountedLabel.isHidden = true
                }
            }
        })
        
        itemDetailViewModel?.descriptionLabeltext.bind({ [weak self] text in
            DispatchQueue.main.async {
                self?.descriptionLabel.text = text
            }
        })
        
        itemDetailViewModel?.images.bind({ [weak self] images in
            DispatchQueue.main.async {
                self?.imageCollectionView.reloadData()
                self?.pageControl.numberOfPages = self?.itemDetailViewModel?.images.value?.count ?? 0
            }
        })
    }
    
    private func changeToStrikethroughStyle(string: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(.strikethroughStyle, value: 1, range: NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
}

//MARK:- DetailViewConfigurable protocol
extension ItemDetailViewController: DetailViewConfigurable {
    func configure(id: Int) {
        itemDetailViewModel = ItemDetailViewModel(id: id)
        itemDetailViewModel?.fetchItem()
    }
}

//MARK:- CollectionView Delegate, DataSource, DelegateFlowLayout
extension ItemDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return itemDetailViewModel?.numberOfSections ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemDetailViewModel?.images.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let detailViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemDetailCollectionViewCell.identifier, for: indexPath) as? ItemDetailCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let image = self.itemDetailViewModel?.images.value?[indexPath.row] {
            detailViewCell.configure(image: image)
        }
        
        return detailViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 300)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPos = scrollView.contentOffset.x / view.frame.width
        pageControl.currentPage = Int(scrollPos)
    }
}
