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
}

