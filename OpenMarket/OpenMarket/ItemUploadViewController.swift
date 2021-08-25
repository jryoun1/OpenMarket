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
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
