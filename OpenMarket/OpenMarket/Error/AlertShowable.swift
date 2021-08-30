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
