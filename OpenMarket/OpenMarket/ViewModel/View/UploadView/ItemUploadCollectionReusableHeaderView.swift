//
//  ItemUploadCollectionReusableHeaderView.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/25.
//

import UIKit
import Photos
import BSImagePicker

final class ItemUploadCollectionReusableHeaderView: UICollectionReusableView {
    static let identifier = "ItemUploadCollectionReusableHeaderView"
    @IBOutlet private var imageAddButton: UIButton!
    @IBOutlet private var imageCountLabel: UILabel!
    private var selectedAssets: [PHAsset] = []
    private var userSelectedImages: [UIImage] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }
    
    private func configureLayout() {
        imageAddButton.layer.borderWidth = 1.0
        imageAddButton.layer.cornerRadius = 10.0
        imageAddButton.layer.borderColor = UIColor.black.cgColor
    }
}

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.filter{ $0.isKeyWindow }.first
        }
        else {
            return UIApplication.shared.keyWindow
        }
    }
    
    public func getCurrentViewController(from viewController: UIViewController?) -> UIViewController? {
        if let navigationController = viewController as? UINavigationController {
            return self.getCurrentViewController(from: navigationController.visibleViewController)
        }
        else if let tabBarController = viewController as? UITabBarController {
            return self.getCurrentViewController(from: tabBarController.selectedViewController)
        }
        else {
            guard let currentViewController = viewController?.presentedViewController else {
                return viewController
            }
            return self.getCurrentViewController(from: currentViewController)
        }
    }
}
