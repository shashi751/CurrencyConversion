//
//  CurrencyService.swift
//  CurrencyConversion
//
//  Created by Shashi Gupta on 26/08/24.
//

import Foundation

private let baseURL = "https://openexchangerates.org/api"
private let appID = "5562c8903a96495685cedbfa2211782b"

class CurrencyService {

    func fetchCurrencies(completion: @escaping (Result<[String: String], Error>) -> Void) {
        
        let url = "\(baseURL)/currencies.json?prettyprint=false&show_alternative=false&show_inactive=false&app_id=\(appID)"
        guard var urlComponents = URLComponents(string: url) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "prettyprint", value: "false"),
            URLQueryItem(name: "show_alternative", value: "false"),
            URLQueryItem(name: "show_inactive", value: "false"),
            URLQueryItem(name: "app_id", value: appID)
        ]

        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let currencies = try JSONDecoder().decode([String: String].self, from: data)
                completion(.success(currencies))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
    
    func fetchLatestRates(from:String, to:String, completion: @escaping (Result<[String: Double], Error>) -> Void) {
        
        let apiURL = "\(baseURL)/latest.json?app_id=5562c8903a96495685cedbfa2211782b&base=\(from)&symbols=\(to)&prettyprint=true&show_alternative=flase"
        
        print(apiURL)
        
        // Create the URL from the string
        guard let url = URL(string: apiURL) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        // Create the URL session data task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                // Parse the JSON data
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                   {
                    if let rates = json["rates"] as? [String: Double]{
                        // Call completion with the rates dictionary
                        completion(.success(rates))
                    }
                    else if let description = json["description"] as? String{
                        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: description])))
                    }
                    else{
                        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
                    }
                    
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
                }
            } catch {
                completion(.failure(error))
            }
        }

        // Start the task
        task.resume()
    }
}
