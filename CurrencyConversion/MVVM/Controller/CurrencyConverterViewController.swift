//
//  CurrencyConverterViewController.swift
//  CurrencyConversion
//
//  Created by Shashi Gupta on 14/08/24.
//

import UIKit

class CurrencyConverterViewController: UIViewController {
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var btnConvert: UIButton!
    @IBOutlet weak var textFieldInput: UITextField!
    @IBOutlet weak var collectionViewCurrency: UICollectionView!
    @IBOutlet weak var btnSelectCurrency: UIButton!
    
    //MARK: - PRIVATE VARAIBLES
    private let currencyViewModel = CurrencyViewModel()
    private var selectedCurrency:String?
    
    //MARK: - INTERNAL FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedCurrency = "USD"
        
        self.collectionInitials()
        
        self.bindCurrenyViewModelToController()
        
        self.configureTextField()
        
        self.convert(UIButton())
        
    }
    
    //MARK: - PRIVATE FUNCTIONS
    private func bindCurrenyViewModelToController(){
        
        currencyViewModel.bindAvailableCurrencyToController = { [weak self] in
            
            DispatchQueue.main.async {
                self?.collectionViewCurrency.reloadData()
                self?.setButtonData()
            }
            
        }
        
        currencyViewModel.bindErrorMessage = { [weak self] message in
            
            DispatchQueue.main.async {
                self?.currencyViewModel.resetData()
                self?.presentAlertWithTitle(title: "Error", message: message, options: "Ok", completion: { value in
                })
            }
            
        }
        
        currencyViewModel.fetchAvailableCurrency()
    }
    
    private func setButtonData(){
        
        self.btnSelectCurrency.setTitle(self.selectedCurrency ?? "Select Currency", for: .normal)
    }
    
    private func showAllAvailableCurrency(currencies:[String]){
        
        let alertController = UIAlertController(title: "Select Currency", message: nil, preferredStyle: .actionSheet)
        
        // Loop through the array and create an action for each element
        for currency in currencies {
            let action = UIAlertAction(title: currency, style: .default) { [weak self] _ in
                print("Selected Currency: \(currency)")
                self?.selectedCurrency = currency
                
                DispatchQueue.main.async {
                    self?.setButtonData()
                }
            }
            alertController.addAction(action)
        }
        
        // Add a cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Present the action sheet
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK: - ACTION FUNCTIONS
    @IBAction func selectCurrency(_ sender: UIButton) {
        
        if !self.currencyViewModel.currencies.isEmpty{
            
            let currency = self.currencyViewModel.currencies.map({$0.key}).sorted()
            self.showAllAvailableCurrency(currencies: currency)
            
        }
        
    }
    
    @IBAction func convert(_ sender: UIButton) {
        
        if let curr = self.selectedCurrency{
            
            let input = Double(self.textFieldInput.text ?? "0") ?? 1
            self.currencyViewModel.fetchLatesRates(from: curr, input: input)
            
        }
        else{
            self.presentAlertWithTitle(title: "Error", message: "Please select currecny first", options: "Ok") { _ in}
        }
        
    }
    
}

extension CurrencyConverterViewController : UITextFieldDelegate{
    
    func configureTextField(){
        
        self.textFieldInput.text = "1"
        self.textFieldInput.delegate = self
        
    }
    
    // UITextFieldDelegate method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Get the current text and the new text
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // Filter out non-numeric characters
        let filteredText = updatedText.filter { "0123456789".contains($0) }
        
        // Limit the text length to 10 digits
        if filteredText.count > 10 {
            return false // Reject the change if it exceeds 10 digits
        } else {
            textField.text = filteredText
            return false // Prevent the default change and manually update the text field
        }
    }
}

//MARK: - Collection View Methods
extension CurrencyConverterViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionInitials(){
        
        self.collectionViewCurrency.delegate = self
        self.collectionViewCurrency.dataSource = self
        
        self.collectionViewCurrency.register(UINib(nibName: CurrencyCollectionViewCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: CurrencyCollectionViewCell.reusableIdentifier)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currencyViewModel.currencies.filter({$0.amount != 0}).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrencyCollectionViewCell.reusableIdentifier, for: indexPath) as? CurrencyCollectionViewCell{
            
            let currency = self.currencyViewModel.currencies.filter({$0.amount != 0})[indexPath.row]
            cell.setData(currency: currency)
            
            return cell
            
        }
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width
        return CGSize(width: width, height: 50)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
