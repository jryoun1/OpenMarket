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
    
    static let identifier = "ItemDetailViewController"
    private var itemDetailViewModel: ItemDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
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
            }
        })
    }
}
