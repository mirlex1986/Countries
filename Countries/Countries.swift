//
//  Countries.swift
//  Countries
//
//  Created by Алексей on 28.02.2021.
//

import Foundation

struct Country: Decodable  {
    let name: String?
    let nativeName: String?
    let flag: String?
    let capital: String?
    let region: String?
    let subregion: String?
    let alpha3Code: String?
    let population: Int?
    let altSpellings: [String]?
    let timezones: [String]?
    
    init(coutryData: [String: Any]) {
        name = coutryData["name"] as? String
        nativeName = coutryData["nativeName"] as? String
        flag = coutryData["flag"] as? String
        capital = coutryData["capital"] as? String
        region = coutryData["region"] as? String
        subregion = coutryData["subregion"] as? String
        alpha3Code = coutryData["alpha3Code"] as? String
        population = coutryData["population"] as? Int
        altSpellings = coutryData["altSpellings"] as? [String]
        timezones = coutryData["timezones"] as? [String]
        
    }
    
    static func getCountries(from value: Any) -> [Country] {
        guard let coutryData = value as? [[String: Any]] else { return [] }
        return coutryData.compactMap { Country(coutryData: $0) }
    }
}
