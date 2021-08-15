//
//  HomeViewController.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/03.
//

import UIKit

final class HomeViewController: UIViewController {
    private var itemTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let nib = UINib(nibName: ItemTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ItemTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- SegmentControl
    private func configureSegmentControl() {
        let titles = ["LIST", "GRID"]
        let segmentedControl: UISegmentedControl = UISegmentedControl(items: titles)
        segmentedControl.selectedSegmentTintColor = UIColor.systemBlue
        segmentedControl.backgroundColor = UIColor.white
        segmentedControl.selectedSegmentIndex = 0
        for index in 0..<titles.count {
            segmentedControl.setWidth(80, forSegmentAt: index)
        }
        segmentedControl.layer.borderWidth = 1.0
        segmentedControl.layer.borderColor = UIColor.systemBlue.cgColor
        segmentedControl.layer.masksToBounds = true
        segmentedControl.sizeToFit()
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .normal)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segmentedControl.sendActions(for: .valueChanged)
        navigationItem.titleView = segmentedControl
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            itemTableView.reloadData()
        case 1:
            itemTableView.isHidden = true
        default:
            return
        }
    }
}
