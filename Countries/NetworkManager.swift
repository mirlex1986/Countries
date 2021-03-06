//
//  NetworkManager.swift
//  Countries
//
//  Created by Алексей on 02.03.2021.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchCountriesData(from url: String, completion: @escaping ([Country]) -> Void) {
        AF.request(url)
            .validate()
            .responseJSON { responseData in
                switch responseData.result {
                case .success(let value):
                    completion(Country.getCountries(from: value))
                case .failure(_):
                    completion([])
                }
            }
    }
    
    func fetchCountryFlag(from imageUrl: String?, completion: @escaping (Data?) -> Void) {
        guard let imageUrl = imageUrl else { return }
        AF.request(imageUrl)
            .validate()
            .responseData { responseData in
                switch responseData.result {
                case .success(let value):
                    completion(value)
                case .failure(_):
                    completion(nil)
                }
            }
    }
}


