//
//  ItemUploadViewController.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/20.
//

import UIKit

final class ItemUploadViewController: UIViewController, AlertShowable {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var stockTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var discountedPriceTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    static let identifier = "ItemUploadViewController"
    private var viewModel = ItemUploadViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImageCollectionView()
        configureCurrencyPickerView()
        configureKeyboardToolBar()
        registerNotificationForKeyboard()
        bindViewModel()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureNavigationBar(httpMethod: HTTPMethod) {
        var doneButton: UIBarButtonItem
        switch httpMethod {
        case .POST:
            self.title = ItemUploadViewString.navigationBarPostTitle
            doneButton = UIBarButtonItem(title: ItemUploadViewString.postDoneButtonTitle, style: .done, target: self, action: #selector(uploadItemToServer(_:)))
        case .PATCH:
            self.title = ItemUploadViewString.navigationBarPatchTitle
            doneButton = UIBarButtonItem(title: ItemUploadViewString.patchDoneButtonTitle, style: .done, target: self, action: #selector(uploadItemToServer(_:)))
        default:
            return
        }
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc private func uploadItemToServer(_ sender: UIBarButtonItem) {
        guard let priceText = priceTextField.text, !priceText.isEmpty else {
            viewModel.updateItemToUpload(title: titleTextField.text!,
                                                   currency: currencyTextField.text!,
                                                   price: nil,
                                                   discountedPrice: nil,
                                                   stock: nil,
                                                   password: passwordTextfield.text!,
                                                   description: descriptionTextView.text!,
                                                   imageData: viewModel.selectedImageData.value ?? [])
            checkItemToUploadInput(type: HTTPMethod(rawValue: sender.title!)!)
            return
        }
        
        guard let stockText = stockTextField.text, !stockText.isEmpty else {
            viewModel.updateItemToUpload(title: titleTextField.text!,
                                                   currency: currencyTextField.text!,
                                                   price: Int(priceText)!,
                                                   discountedPrice: nil,
                                                   stock: nil,
                                                   password: passwordTextfield.text!,
                                                   description: descriptionTextView.text!,
                                                   imageData: viewModel.selectedImageData.value ?? [])
            checkItemToUploadInput(type: HTTPMethod(rawValue: sender.title!)!)
            return
        }
        
        viewModel.updateItemToUpload(title: titleTextField.text!,
                                               currency: currencyTextField.text!,
                                               price: Int(priceText)!,
                                               discountedPrice: Int(discountedPriceTextField.text!),
                                               stock: Int(stockText)!,
                                               password: passwordTextfield.text!,
                                               description: descriptionTextView.text!,
                                               imageData: viewModel.selectedImageData.value ?? [])
        checkItemToUploadInput(type: HTTPMethod(rawValue: sender.title!)!)
    }
    
    private func checkItemToUploadInput(type: HTTPMethod) {
        switch type {
        case .POST:
            switch viewModel.checkItemToUploadInput() {
            case .Correct:
                viewModel.post()
            case .Incorrect:
                return
            }
        case .PATCH:
            switch viewModel.checkItemToUploadInput() {
            case .Correct:
                viewModel.patch()
            case .Incorrect:
                return
            }
        default:
            return
        }
    }
    
    private func configureImageCollectionView() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        let headerViewNib = UINib(nibName: ItemUploadCollectionReusableHeaderView.identifier, bundle: nil)
        imageCollectionView.register(headerViewNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ItemUploadCollectionReusableHeaderView.identifier)
        let nib = UINib(nibName: ItemUploadCollectionViewCell.identifier, bundle: nil)
        imageCollectionView.register(nib, forCellWithReuseIdentifier: ItemUploadCollectionViewCell.identifier)
    }
    
    private func bindViewModel() {
        viewModel.selectedImageData.bind({ [weak self] _ in
            DispatchQueue.main.async {
                self?.imageCollectionView.reloadData()
            }
        })
        
        viewModel.titleTextFiledtext.bind { [weak self] in
            self?.titleTextField.text = $0
        }
        
        viewModel.currencyTextFiledtext.bind { [weak self] in
            self?.currencyTextField.text = $0
        }
        
        viewModel.priceTextFiledtext.bind { [weak self] in
            self?.priceTextField.text = $0
        }
        
        viewModel.discountedPriceTextFiledtext.bind { [weak self] in
            self?.discountedPriceTextField.text = $0
        }
        
        viewModel.stockTextFieldtext.bind { [weak self] in
            self?.stockTextField.text = $0
        }
        
        viewModel.passwordTextFieldtext.bind { [weak self] in
            self?.passwordTextfield.text = $0
        }
        
        viewModel.descriptionTextViewtext.bind { [weak self] in
            if let description = $0, description.isEmpty {
                self?.descriptionTextView.text = ItemUploadViewString.descriptionPlaceholder
                self?.descriptionTextView.textColor = .systemGray3
            }
            else {
                self?.descriptionTextView.text = $0
                self?.descriptionTextView.textColor = .black
            }
        }
        
        viewModel.itemToUploadsInputErrorMessage.bind { [weak self] in
            self?.errorMessageLabel.isHidden = false
            self?.errorMessageLabel.text = $0
        }
        
        viewModel.isTitleTextFieldHighLighted.bind { [weak self] in
            if let bool = $0, bool { self?.highlightTextField((self?.titleTextField)!) }
        }
        
        viewModel.isCurrencyTextFieldHighLighted.bind { [weak self] in
            if let bool = $0, bool { self?.highlightTextField((self?.currencyTextField)!) }
        }
        
        viewModel.isPriceTextFieldHighLighted.bind { [weak self] in
            if let bool = $0, bool { self?.highlightTextField((self?.priceTextField)!) }
        }
        
        viewModel.isStockTextFieldHighLighted.bind { [weak self] in
            if let bool = $0, bool { self?.highlightTextField((self?.stockTextField)!) }
        }
        
        viewModel.isPasswordTextFieldHighLighted.bind { [weak self] in
            if let bool = $0, bool { self?.highlightTextField((self?.passwordTextfield)!) }
        }
        
        viewModel.isDescriptionTextViewHighLighted.bind { [weak self] in
            if let bool = $0, bool { self?.highlightTextView((self?.descriptionTextView)!) }
        }
        
        viewModel.networkingResult.bind { [weak self] error in
            guard let error = error else {
                return
            }
            
            DispatchQueue.main.async {
                self?.showAlert(viewController: self!, error)
            }
        }
    }
    
    //MARK:- PickerView
    private func configureCurrencyPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        currencyTextField.inputView = pickerView
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(systemItem: .flexibleSpace)
        let selectButton = UIBarButtonItem(title: ItemUploadViewString.selectButton, style: .plain, target: self, action: #selector(didSelectButtonTouchedUp(_:)))
        toolBar.setItems([flexibleSpace, selectButton], animated: true)
        currencyTextField.inputAccessoryView = toolBar
    }
    
    @objc private func didSelectButtonTouchedUp(_ sender: UIPickerView) {
        currencyTextField.resignFirstResponder()
    }
    
    //MARK:- KeyBoard
    private func configureKeyboardToolBar() {
        let keyboardToolBar = UIToolbar()
        keyboardToolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didDoneButtonTouchedUp(_:)))
        keyboardToolBar.items = [flexibleSpace, doneButton]
        
        titleTextField.inputAccessoryView = keyboardToolBar
        stockTextField.inputAccessoryView = keyboardToolBar
        priceTextField.inputAccessoryView = keyboardToolBar
        discountedPriceTextField.inputAccessoryView = keyboardToolBar
        passwordTextfield.inputAccessoryView = keyboardToolBar
        descriptionTextView.inputAccessoryView = keyboardToolBar
    }
    
    @objc private func didDoneButtonTouchedUp(_ sender: UIBarButtonItem) {
        titleTextField.resignFirstResponder()
        stockTextField.resignFirstResponder()
        priceTextField.resignFirstResponder()
        discountedPriceTextField.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
    
    //MARK:- Keyboard view up
    private func registerNotificationForKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}

//MARK:- CollectionView Delegate, DataSource, DelegateFlowLayout
extension ItemUploadViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.selectedImageData.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemUploadCollectionViewCell.identifier, for: indexPath) as? ItemUploadCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.deleteImageDelegate = self
        
        if let data = viewModel.selectedImageData.value?[indexPath.row] {
            cell.tag = indexPath.row
            cell.configure(data: data)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ItemUploadCollectionReusableHeaderView.identifier, for: indexPath) as? ItemUploadCollectionReusableHeaderView else {
                return UICollectionReusableView()
            }
            headerView.selectedImageDataUpdatableDelegate = self
            headerView.configure(data: viewModel.selectedImageData.value?.count ?? 0)
            
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

//MARK:- ImageDeletable protocol
extension ItemUploadViewController: ImageDeletable {
    func delete(index: Int) {
        _ = viewModel.selectedImageData.value?.remove(at: index)
    }
}

//MARK:- SelectedImageDataUpdatable protocol
extension ItemUploadViewController: SelectedImageDataUpdatable {
    func update(data: [Data]) {
        _ = viewModel.selectedImageData.value?.append(contentsOf: data)
    }
}

//MARK:- UploadViewConfigurable protocol
extension ItemUploadViewController: UploadViewConfigurable {
    func configure(item: ItemToUpload?, id: Int?) {
        if let _ = item, let id = id {
            self.configureNavigationBar(httpMethod: .PATCH)
            self.viewModel = ItemUploadViewModel(itemToUpload: item, id: id)
        }
        else {
            self.configureNavigationBar(httpMethod: .POST)
        }
    }
}

//MARK:- PickerView
extension ItemUploadViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CurrencyCode.list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CurrencyCode.list[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencyTextField.text = CurrencyCode.list[row].description
    }
}

//MARK:- UITextFieldDelegate
extension ItemUploadViewController: UITextFieldDelegate {
    private func highlightTextField(_ textField: UITextField) {
        textField.resignFirstResponder()
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.systemRed.cgColor
        textField.layer.cornerRadius = 3
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        errorMessageLabel.isHidden = true
        titleTextField.layer.borderWidth = 0
        currencyTextField.layer.borderWidth = 0
        priceTextField.layer.borderWidth = 0
        discountedPriceTextField.layer.borderWidth = 0
        stockTextField.layer.borderWidth = 0
        passwordTextfield.layer.borderWidth = 0
    }
}

//MARK:- UITextViewDelegate
extension ItemUploadViewController: UITextViewDelegate {
    private func highlightTextView(_ textView: UITextView) {
        textView.resignFirstResponder()
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.systemRed.cgColor
        textView.layer.cornerRadius = 3
    }
    
    private func descriptionTextViewConfigurePlaceholder() {
        if descriptionTextView.text == ItemUploadViewString.descriptionPlaceholder {
            descriptionTextView.text = ""
            descriptionTextView.textColor = .black
        }
        else if descriptionTextView.text.isEmpty {
            descriptionTextView.text = ItemUploadViewString.descriptionPlaceholder
            descriptionTextView.textColor = .systemGray3
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        errorMessageLabel.isHidden = true
        descriptionTextView.layer.borderWidth = 0
        
        descriptionTextViewConfigurePlaceholder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            descriptionTextViewConfigurePlaceholder()
        }
    }
}
