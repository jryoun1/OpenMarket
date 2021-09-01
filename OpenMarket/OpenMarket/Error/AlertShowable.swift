//
//  AlertShowable.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/30.
//

import UIKit

enum AlertString {
    static let normalTitle = "알림"
    static let okButtonTitle = "확인"
    static let passwordNotCorrectErrorMessage = "비밀번호가 일치하지 않아서 해당 상품을 삭제나 수정할 수 없습니다"
    static let passwordNotCorrectErrorAlertTitle = "비밀번호가 일치하지 않습니다"
}

protocol AlertShowable {
    func showAlert(viewController: UIViewController, _ error: OpenMarketError)
}

extension AlertShowable {
    func showAlert(viewController: UIViewController, _ error: OpenMarketError) {
        var alert: UIAlertController
        var okAction: UIAlertAction
        var isNetworkSuccess: Bool = false
        
        switch error {
        case .successPOST:
            alert = UIAlertController(title: AlertString.normalTitle, message: error.localizedDescription, preferredStyle: .alert)
            isNetworkSuccess = true
        case .successDELETE:
            alert = UIAlertController(title: AlertString.normalTitle, message: error.localizedDescription, preferredStyle: .alert)
            isNetworkSuccess = true
        case .successPATCH:
            alert = UIAlertController(title: AlertString.normalTitle, message: error.localizedDescription, preferredStyle: .alert)
            isNetworkSuccess = true
        case .notFound:
            alert = UIAlertController(title: AlertString.passwordNotCorrectErrorAlertTitle, message: AlertString.passwordNotCorrectErrorMessage, preferredStyle: .alert)
        default:
            alert = UIAlertController(title: AlertString.normalTitle, message: error.localizedDescription, preferredStyle: .alert)
        }
        
        okAction = UIAlertAction(title: AlertString.okButtonTitle, style: .default, handler: { _ in
            guard let itemListViewController = viewController.navigationController?.viewControllers.filter({$0.isKind(of: ItemListViewController.self)}).first else {
                return
            }
            if isNetworkSuccess {
                NotificationCenter.default.post(name: .ItemDataChanged, object: nil)
            }            
            viewController.navigationController?.popToViewController(itemListViewController, animated: true)
        })
        
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}
