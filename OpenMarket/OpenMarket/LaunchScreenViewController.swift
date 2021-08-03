//
//  LaunchScreenViewController.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/03.
//

import UIKit

final class LaunchScreenViewController: UIViewController {
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo")
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
