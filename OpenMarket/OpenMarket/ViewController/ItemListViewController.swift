//
//  ItemListViewController.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/03.
//

import UIKit
import SkeletonView

protocol UploadViewConfigurable: AnyObject {
    func configure(item: ItemToUpload?, id: Int?)
}

protocol DetailViewConfigurable: AnyObject {
    func configure(id: Int)
}

final class ItemListViewController: UIViewController {
    static let identifier = "ItemListViewController"
    weak var uploadViewConfigurableDelegate: UploadViewConfigurable?
    weak var detailViewConfigurableDelegate: DetailViewConfigurable?
    private var viewModel = ItemListViewModel()
    
    private var itemTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isSkeletonable = true
        let nib = UINib(nibName: ItemTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ItemTableViewCell.identifier)
        tableView.register(ItemTableViewFooterView.self, forHeaderFooterViewReuseIdentifier: ItemTableViewFooterView.identifier)
        return tableView
    }()
    
    private var itemCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isSkeletonable = true
        let nib = UINib(nibName: ItemCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
        collectionView.register(ItemCollectionReusableFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ItemCollectionReusableFooterView.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    //MARK:- enum
    private enum LoadingIndicatorState {
        case start
        case stop
    }
    
    private enum SegmentControlType: Int, CustomStringConvertible {
        case LIST = 0
        case GRID = 1
        
        var description: String {
            switch self {
            case .LIST:
                return "LIST"
            case .GRID:
                return "GRID"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureItemTableView()
        configureItemCollectionView()
        configureSkeletonView()
        configureRefreshControl()
        bindViewModel()
        registerNotificationCenter()
        viewModel.fetchData(page: viewModel.currentPage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.isItemChanged {
            viewModel.currentPage = 1
            viewModel.itemList.value?.removeAll()
            viewModel.fetchData(page: viewModel.currentPage)
            viewModel.isItemChanged = false
        }
    }
    
    private func configureNavigationBar() {
        configureSegmentControl()
        configureNavigationBarRightButton()
    }
    
    //MARK:- NavigationBar Button
    private func configureNavigationBarRightButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(moveToItemUploadViewController))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.systemBlue
    }
    
    @objc private func moveToItemUploadViewController() {
        guard let itemUploadViewController = self.storyboard?.instantiateViewController(withIdentifier: ItemUploadViewController.identifier) as? ItemUploadViewController else {
            return
        }
        
        self.uploadViewConfigurableDelegate = itemUploadViewController
        self.uploadViewConfigurableDelegate?.configure(item: nil, id: nil)
        self.navigationController?.pushViewController(itemUploadViewController, animated: true)
    }
    
    //MARK:- SegmentControl
    private func configureSegmentControl() {
        let titles = ["\(SegmentControlType.LIST)", "\(SegmentControlType.GRID)"]
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
        case SegmentControlType.LIST.rawValue:
            itemCollectionView.isHidden = true
            itemTableView.isHidden = false
            itemTableView.reloadData()
        case SegmentControlType.GRID.rawValue:
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
    
    private func configureRefreshControl() {
        let refreshForTableView = UIRefreshControl()
        refreshForTableView.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshForTableView.tintColor = UIColor.systemGray
        
        let refreshForCollectionView = UIRefreshControl()
        refreshForCollectionView.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshForCollectionView.tintColor = UIColor.systemGray
        
        self.itemCollectionView.refreshControl = refreshForTableView
        self.itemTableView.refreshControl = refreshForCollectionView
    }
    
    @objc private func refreshData(_ sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            sender.endRefreshing()
            self.viewModel.currentPage = 1
            self.viewModel.fetchData(page: self.viewModel.currentPage)
        }
    }
    
    //MARK:- bindViewModel
    private func bindViewModel() {
        viewModel.itemList.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.checkIsHiddenAndReloadData()
                
                if self?.viewModel.itemList.value?.count ?? 0 > 19 {
                    self?.itemTableView.stopSkeletonAnimation()
                    self?.itemTableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
                }
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
    
    private func configureSkeletonView() {
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        self.itemTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animation: animation, transition: .crossDissolve(0.5))
    }
    
    //MARK:- NotificationCenter
    private func registerNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveItemDataChanged(_:)), name: NSNotification.Name.ItemDataChanged, object: nil)
    }
    
    @objc private func didReceiveItemDataChanged(_ notification: Notification) {
        viewModel.isItemChanged = true
    }
}

extension Notification.Name {
    static let ItemDataChanged = Notification.Name("ItemDataChanged")
}

//MARK:- Paging
extension ItemListViewController {
    private func beginPaging() {
        viewModel.isPaging = true
        
        DispatchQueue.main.async {
            self.checkIsHiddenAndControlLoadingIndicator(state: .start)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.viewModel.currentPage += 1
            self.viewModel.fetchData(page: self.viewModel.currentPage)
            self.viewModel.isPaging = false
            self.checkIsHiddenAndControlLoadingIndicator(state: .stop)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset_y = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if contentOffset_y > contentHeight - height {
            if viewModel.isPaging == false && viewModel.hasNextPage {
                beginPaging()
            }
        }
    }
}

//MARK:- TableView Delegate, Datasource
extension ItemListViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemList.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier, for: indexPath) as? ItemTableViewCell else {
            return ItemTableViewCell()
        }
        
        DispatchQueue.main.async {
            if let index: IndexPath = tableView.indexPath(for: cell) ,
               let item = self.viewModel.itemList.value?[indexPath.row] {
                if index.row == indexPath.row {
                    cell.configureCell(with: ItemListCellViewModel(item))
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier:  ItemTableViewFooterView.identifier) as? ItemTableViewFooterView else {
            return UIView()
        }
        
        footerView.contentView.backgroundColor = itemTableView.backgroundColor
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let itemDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: ItemDetailViewController.identifier) as? ItemDetailViewController else {
            return
        }
        
        guard let item = self.viewModel.itemList.value?[indexPath.row] else {
            return
        }
        
        self.detailViewConfigurableDelegate = itemDetailViewController
        self.detailViewConfigurableDelegate?.configure(id: item.id)
        self.navigationController?.pushViewController(itemDetailViewController, animated: true)
    }
    
    //MARK:- skeletonView
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return ItemTableViewCell.identifier
    }
}

//MARK:- CollectionView Delegate, DataSource, DelegateFlowLayout
extension ItemListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemList.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as? ItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let item = self.viewModel.itemList.value?[indexPath.row] {
            cell.configureCell(with: ItemListCellViewModel(item))
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let itemDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: ItemDetailViewController.identifier) as? ItemDetailViewController else {
            return
        }
        
        guard let item = self.viewModel.itemList.value?[indexPath.row] else {
            return
        }
        
        self.detailViewConfigurableDelegate = itemDetailViewController
        self.detailViewConfigurableDelegate?.configure(id: item.id)
        self.navigationController?.pushViewController(itemDetailViewController, animated: true)
    }
}
