//
//  LocalDataStore.swift
//  CurrencyConversion
//
//  Created by Shashi Gupta on 26/08/24.
//

import Foundation

class LocalDataStore {
    private let currencyKey = "StoredCurrencies"
    private let lastUpdatedKey = "LastUpdated"

    func saveCurrencies(_ currencies: [String: String]) {
        UserDefaults.standard.set(currencies, forKey: currencyKey)
        UserDefaults.standard.set(Date(), forKey: lastUpdatedKey)
    }

    func loadCurrencies() -> [String: String]? {
        return UserDefaults.standard.dictionary(forKey: currencyKey) as? [String: String]
    }

    func shouldRefreshData() -> Bool {
        guard let lastUpdated = UserDefaults.standard.object(forKey: lastUpdatedKey) as? Date else {
            return true
        }
        return Date().timeIntervalSince(lastUpdated) > 1800 // 30 minutes
    }
    
    
}
