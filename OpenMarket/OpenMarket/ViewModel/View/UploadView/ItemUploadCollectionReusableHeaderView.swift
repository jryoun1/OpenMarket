//
//  ItemUploadCollectionReusableHeaderView.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/25.
//

import UIKit
import Photos
import BSImagePicker

protocol SelectImagesForUpload: AnyObject {
    func didPickupImage(images: [UIImage])
}

protocol UpdateSelectedImages: AnyObject {
    func update(images: [UIImage])
}

final class ItemUploadCollectionReusableHeaderView: UICollectionReusableView {
    static let identifier = "ItemUploadCollectionReusableHeaderView"
    @IBOutlet private var imageAddButton: UIButton!
    @IBOutlet private var imageCountLabel: UILabel!
    private var selectedAssets: [PHAsset] = []
    private var userSelectedImages: [UIImage] = []
    private let limitNumberOfImages: Int = 5
    weak var selectImagesForUploadDelegate: SelectImagesForUpload?
    weak var updateSelectedImagesDelegate: UpdateSelectedImages?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
        selectImagesForUploadDelegate = self
    }
    
    private func configureLayout() {
        imageAddButton.layer.borderWidth = 1.0
        imageAddButton.layer.cornerRadius = 10.0
        imageAddButton.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction private func touchUpImageAddButton(_ sender: UIButton) {
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = limitNumberOfImages
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        
        let currentViewController = UIWindow.key?.currentViewController
        currentViewController?.presentImagePicker(imagePicker,
                                                  select: { (asset) in
                                                  }, deselect: { (asset) in
                                                  }, cancel: { (assets) in
                                                  }, finish: { (assets) in
                                                    for i in 0..<assets.count {
                                                        self.selectedAssets.append(assets[i])
                                                    }
                                                    self.convertAssetToImages()
                                                    self.selectImagesForUploadDelegate?.didPickupImage(images: self.userSelectedImages)
                                                  })
    }
    
    private func convertAssetToImages() {
        if selectedAssets.count != 0 {
            for i in 0..<selectedAssets.count {
                let imageManager = PHImageManager.default()
                let option = PHImageRequestOptions()
                option.isSynchronous = true
                var thumbnail = UIImage()
                
                imageManager.requestImage(for: selectedAssets[i],
                                          targetSize: CGSize(width: UIScreen.main.bounds.width, height: 200),
                                          contentMode: .aspectFit,
                                          options: option) { (result, info) in
                    thumbnail = result!
                }
                
                let data = thumbnail.jpegData(compressionQuality: 1)
                let newImage = UIImage(data: data!)
                
                self.userSelectedImages.append(newImage! as UIImage)
            }
        }
    }
    
    func configure(data: Int) {
        imageCountLabel.textColor = .black
        if data > limitNumberOfImages {
            imageCountLabel.textColor = .systemRed
        }
        imageCountLabel.text = "(\(data)/\(limitNumberOfImages))"
    }
}

//MARK:- SelectedImageForUpload protocol
extension ItemUploadCollectionReusableHeaderView: SelectImagesForUpload {
    func didPickupImage(images: [UIImage]) {
        self.updateSelectedImagesDelegate?.update(images: images)
    }
}

//MARK:- UIWindow extension
extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.filter{ $0.isKeyWindow }.first
        }
        else {
            return UIApplication.shared.keyWindow
        }
    }
    
    public var currentViewController: UIViewController? {
        return self.getCurrentViewController(from: self.rootViewController)
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
