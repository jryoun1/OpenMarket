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
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .systemRed
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        moveToHomeViewController()
    }
    
    private func configureView() {
        view.addSubview(logoImageView)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            
            activityIndicator.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 25),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.widthAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: 0.2),
            activityIndicator.heightAnchor.constraint(equalTo: activityIndicator.widthAnchor)
        ])
    }
    
    private func moveToHomeViewController() {
        guard let itemListViewController = self.storyboard?.instantiateViewController(identifier: ItemListViewController.identifier) else {
            return
        }
        
        let navigationController = UINavigationController(rootViewController: itemListViewController)
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
            navigationController.modalTransitionStyle = .crossDissolve
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        activityIndicator.stopAnimating()
    }
}
