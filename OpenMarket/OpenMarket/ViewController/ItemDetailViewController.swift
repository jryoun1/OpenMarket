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
    private var viewModel: ItemDetailViewModel?
    weak var uploadViewConfigurableDelegate: UploadViewConfigurable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureImageCollectionView()
        configurePageControl()
        bindViewModel()
    }
    
    private func configureNavigationBar() {
        self.title = ItemDetailViewString.openMarketAppTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(showActionSheetAlert(_:)))
    }
    
    @objc private func showActionSheetAlert(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: ItemDetailViewString.cancelButtonTitle, style: .cancel, handler: nil)
        let fix = UIAlertAction(title: ItemDetailViewString.patchButtonTitle, style: .default) { [weak self] _ in
            let result = self?.viewModel?.prepareItemToUpload(password: "")
            guard let itemUploadViewController = self?.storyboard?.instantiateViewController(withIdentifier: ItemUploadViewController.identifier) as? ItemUploadViewController else {
                return
            }
            
            self?.uploadViewConfigurableDelegate = itemUploadViewController
            self?.uploadViewConfigurableDelegate?.configure(item: result?.item, id: result?.id)
            self?.navigationController?.pushViewController(itemUploadViewController, animated: true)
        }
        let delete = UIAlertAction(title: ItemDetailViewString.deleteButtonTitle, style: .destructive) { [weak self] _ in
            self?.showPasswordRequestAlert()
        }
        
        alert.addAction(fix)
        alert.addAction(delete)
        alert.addAction(cancel)
        
        if traitCollection.userInterfaceIdiom == .phone {
            self.present(alert, animated: true, completion: nil)
        }
        else {
            alert.popoverPresentationController?.barButtonItem = sender
            self.present(alert, animated: true, completion: nil)
        }
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
            pageControl.centerXAnchor.constraint(equalTo: self.imageCollectionView.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: self.imageCollectionView.safeAreaLayoutGuide.topAnchor, constant: 280)
        ])
    }
    
    private func bindViewModel() {
        viewModel?.titleLabeltext.bind({ [weak self] text in
            DispatchQueue.main.async {
                self?.titleLabel.text = text
            }
        })
        
        viewModel?.stockTextLabeltext.bind({ [weak self] text in
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
        
        viewModel?.priceLabeltext.bind({ [weak self] text in
            DispatchQueue.main.async {
                self?.priceLabel.attributedText = NSAttributedString(string: text ?? "")
            }
        })
        
        viewModel?.discountedPriceLabeltext.bind({ [weak self] text in
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
        
        viewModel?.descriptionLabeltext.bind({ [weak self] text in
            DispatchQueue.main.async {
                self?.descriptionLabel.text = text
            }
        })
        
        viewModel?.images.bind({ [weak self] images in
            DispatchQueue.main.async {
                self?.imageCollectionView.reloadData()
                self?.pageControl.numberOfPages = self?.viewModel?.images.value?.count ?? 0
            }
        })
        
        viewModel?.networkingResult.bind({ [weak self] error in
            guard let error = error else {
                return
            }
            
            DispatchQueue.main.async {
                self?.showAlert(viewController: self!, error)
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
        viewModel = ItemDetailViewModel(id: id)
        viewModel?.fetch()
    }
}

//MARK:- CollectionView Delegate, DataSource, DelegateFlowLayout
extension ItemDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.numberOfSections ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.images.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let detailViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemDetailCollectionViewCell.identifier, for: indexPath) as? ItemDetailCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let image = self.viewModel?.images.value?[indexPath.row] {
            detailViewCell.configure(image: image)
        }
        
        return detailViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPos = scrollView.contentOffset.x / view.frame.width
        pageControl.currentPage = Int(scrollPos)
    }
}

extension ItemDetailViewController: AlertShowable {
    private func showPasswordRequestAlert() {
        let alert = UIAlertController(title: ItemDetailViewString.deletAlertTitle, message: ItemDetailViewString.deleteAlertMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: ItemDetailViewString.okButtonTitle, style: .destructive) { (ok) in
            if let inputPassword = alert.textFields?.first?.text {
                self.viewModel?.delete(password: inputPassword)
            }
            return
        }
        let cancel = UIAlertAction(title: ItemDetailViewString.cancelButtonTitle, style: .cancel, handler: nil)
        
        alert.addTextField { textfield in
            textfield.placeholder = ItemDetailViewString.deleteAlertTextFieldPlaceholder
            textfield.isSecureTextEntry = true
            textfield.textContentType = .password
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}
