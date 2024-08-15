//
//  CurrencyViewModel.swift
//  CurrencyConversion
//
//  Created by Shashi Gupta on 14/08/24.
//

import Foundation

class CurrencyViewModel{
    
    //MARK: - VARIABLES
    private(set) var currencies : [CurrecnyModel] = [CurrecnyModel]() {
        didSet {
            self.bindAvailableCurrencyToController()
        }
    }
    
    //MARK: - Clousers
    var bindAvailableCurrencyToController : (() -> ()) = {}
    var bindErrorMessage : ((_ message:String) -> ()) = {message in }
    
    //MARK: - FUNCTIONS
    /// Fetched from the open exchange rates service.
    func fetchAvailableCurrency(){
        
        if LocalDataStore().shouldRefreshData(){
            
            CurrencyService().fetchCurrencies {[weak self] result in
                
                switch result{
                case .success(let data):
                    print(data)
                    var temp = [CurrecnyModel]()
                    for (key, value) in data{
                        temp.append(CurrecnyModel(key: key, value: value, amount: 0))
                    }
                    
                    LocalDataStore().saveCurrencies(data)
                    self?.currencies = temp.sorted(by: {$0.key < $1.key})
                    
                case .failure(let error):
                    print(error)
                    self?.bindErrorMessage(error.localizedDescription)
                }
            }
        }
        else{
            
            if let currencies = LocalDataStore().loadCurrencies(){
                var temp = [CurrecnyModel]()
                for (key, value) in currencies{
                    temp.append(CurrecnyModel(key: key, value: value, amount: 0))
                }
                self.currencies = temp.sorted(by: {$0.key < $1.key})
            }
            
        }
        
    }
    
    /// from require the currency like USD from currency need conversion
    ///  input require to multiply the rates with the amount
    func fetchLatesRates(from:String, input:Double){
        
        let keys = self.currencies.map({$0.key})
        let to = keys.joined(separator: ",")
        
        CurrencyService().fetchLatestRates(from: from, to: to) {[weak self] result in
            
            switch result{
            case .success(let rates):
                print(rates)
                var temp = self?.currencies ?? []
                for (key, value) in rates{
                    
                    if let firstIndex = temp.firstIndex(where: {$0.key == key}){
                        temp[firstIndex].amount = value * input
                    }
                }
                
                self?.currencies = temp
                
            case .failure(let error):
                print(error)
                self?.bindErrorMessage(error.localizedDescription)
            }
        }
    }
    
    /// Reset the all
    func resetData(){
        self.currencies = self.currencies.map(self.resetAmount(cur:))
    }
    
    /// Map Function to reset data
    private func resetAmount(cur:CurrecnyModel) -> CurrecnyModel{
        var temp = cur
        temp.amount = 0
        return temp
    }
}
