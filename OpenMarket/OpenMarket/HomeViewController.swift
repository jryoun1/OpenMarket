//
//  HomeViewController.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/03.
//

import UIKit

final class HomeViewController: UIViewController {
    private var currentPage: Int = 1
    private var isPaging: Bool = false
    private var hasNextPage: Bool = false
    private var apiRequestLoader: APIRequestLoader<GetItemListAPIRequest>!
    private var itemListViewModel = ItemListViewModel()
    
    private var itemTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let nib = UINib(nibName: ItemTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ItemTableViewCell.identifier)
        tableView.register(ItemTableViewFooterView.self, forHeaderFooterViewReuseIdentifier: ItemTableViewFooterView.identifier)
        return tableView
    }()
    
    private var itemCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        let nib = UINib(nibName: ItemCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
        collectionView.register(ItemCollectionReusableFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ItemCollectionReusableFooterView.identifier)
        return collectionView
    }()
    
    //MARK:- enum
    private enum LoadingIndicatorState {
        case start
        case stop
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureItemTableView()
        configureItemCollectionView()
        bindViewModel()
        fetchData(page: currentPage)
    }
    
    private func configureNavigationBar() {
        configureSegmentControl()
        configureNavigationBarRightButton()
    }
    
    //MARK:- NavigationBar Button
    private func configureNavigationBarRightButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(moveToItemUploadViewController))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.systemBlue
    }
    
    @objc private func moveToItemUploadViewController() {
        guard let itemUploadViewController = self.storyboard?.instantiateViewController(withIdentifier: ItemUploadViewController.identifier) as? ItemUploadViewController else {
            return
        }
        
        self.navigationController?.pushViewController(itemUploadViewController, animated: true)
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
            itemCollectionView.isHidden = true
            itemTableView.isHidden = false
            itemTableView.reloadData()
        case 1:
            itemTableView.isHidden = true
            itemCollectionView.isHidden = false
            itemCollectionView.reloadData()
        default:
            return
        }
    }
    
    //MARK:- Configure TableView, CollectionView
    private func configureItemTableView() {
        view.addSubview(itemTableView)
        itemTableView.delegate = self
        itemTableView.dataSource = self
        
        NSLayoutConstraint.activate([
            itemTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            itemTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            itemTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            itemTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureItemCollectionView() {
        view.addSubview(itemCollectionView)
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            itemCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            itemCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            itemCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            itemCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK:- bindViewModel
    private func bindViewModel() {
        itemListViewModel.itemList.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.checkIsHiddenAndReloadData()
            }
        }
    }
    
    private func checkIsHiddenAndReloadData() {
        if self.itemTableView.isHidden == false {
            self.itemTableView.reloadData()
        }
        
        if self.itemCollectionView.isHidden == false {
            self.itemCollectionView.reloadData()
        }
    }
    
    private func checkIsHiddenAndControlLoadingIndicator(state: LoadingIndicatorState) {
        if self.itemTableView.isHidden == false,
           let footerView = self.itemTableView.footerView(forSection: 0) as? ItemTableViewFooterView {
            switch state {
            case .start:
                footerView.startLoading()
            case .stop:
                footerView.stopLoading()
            }
        }
        
        if self.itemCollectionView.isHidden == false,
           let footerView = self.itemCollectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionFooter).first as? ItemCollectionReusableFooterView {
            switch state {
            case .start:
                footerView.startLoading()
            case .stop:
                footerView.stopLoading()
            }
        }
    }
    
    //MARK:- FetchData
    private func fetchData(page: Int) {
        let getItemListAPIRequest = GetItemListAPIRequest()
        apiRequestLoader = APIRequestLoader(apiReqeust: getItemListAPIRequest)
        
        apiRequestLoader.loadAPIReqeust(requestData: page) { [self] itemList, error in
            guard let itemList = itemList, itemList.items.count > 0 else {
                self.hasNextPage = false
                DispatchQueue.main.async {
                    checkIsHiddenAndControlLoadingIndicator(state: .stop)
                }
                return
            }
            
            self.hasNextPage = true
            _ = itemList.items.compactMap({ item in
                self.itemListViewModel.itemList.value?.append(ItemListCellViewModel(item))
            })
            
            DispatchQueue.main.async {
                checkIsHiddenAndControlLoadingIndicator(state: .stop)
                checkIsHiddenAndReloadData()
            }
        }
    }
}

//MARK:- Paging
extension HomeViewController {
    private func beginPaging() {
        isPaging = true
        
        DispatchQueue.main.async {
            self.checkIsHiddenAndControlLoadingIndicator(state: .start)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.currentPage += 1
            self.fetchData(page: self.currentPage)
            self.isPaging = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset_y = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if contentOffset_y > contentHeight - height {
            if isPaging == false && hasNextPage {
                beginPaging()
            }
        }
    }
}

//MARK:- TableView Delegate, Datasource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemListViewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemListViewModel.itemList.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier, for: indexPath) as? ItemTableViewCell else {
            return ItemTableViewCell()
        }
        
        if let item = self.itemListViewModel.itemList.value?[indexPath.row] {
            cell.configureCell(with: item)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier:  ItemTableViewFooterView.identifier) as? ItemTableViewFooterView else {
            return UIView()
        }
        
        footerView.contentView.backgroundColor = .white
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

//MARK:- CollectionView Delegate, DataSource, DelegateFlowLayout
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return itemListViewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemListViewModel.itemList.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as? ItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let item = self.itemListViewModel.itemList.value?[indexPath.row] {
            cell.configureCell(with: item)
        }
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.systemGray.cgColor
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        
        let itemsPerRow: CGFloat = 2
        let widthPadding = 10 * (itemsPerRow + 1)
        let itemsPerColumn: CGFloat = 3
        let heightPadding = 10 * (itemsPerRow + 1)
        
        let itemWidth = (width - widthPadding) / itemsPerRow
        let itemHeight = (height - heightPadding) / itemsPerColumn
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ItemCollectionReusableFooterView.identifier, for: indexPath) as? ItemCollectionReusableFooterView else {
                return UICollectionReusableView()
            }
            
            return footer
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: view.frame.size.height / 25)
    }
}
