//
//  CoutryDetailsViewController.swift
//  Countries
//
//  Created by Алексей on 01.03.2021.
//

import UIKit
import SVGKit

class CountryDetailsViewController: UIViewController {
    
    @IBOutlet var countryFlag: UIImageView!
    @IBOutlet var coutryName: UILabel!
    @IBOutlet var countryInfoTable: UITableView!
    
    
    var country: Country!
    var tableData: [(title: String, data: Any?)] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        countryInfoTable.delegate = self
        countryInfoTable.dataSource = self
        
        tableData = prepareData(country: country)
        countryInfoTable.reloadData()
        
    }
}

extension CountryDetailsViewController {
    private func configureView() {
        coutryName.text = country.nativeName
        navigationItem.title = country.name
        
        fetchCoutryFlag()
    }
    
    private func fetchCoutryFlag() {
        guard let flag = country.flag else { return }
        guard let imageURL = URL(string: flag) else { return }
        guard let imageData = try? Data(contentsOf: imageURL) else { return }
        DispatchQueue.main.async {
            self.countryFlag.image = SVGKImage(data: imageData).uiImage
        }
    }
}

//MARK: - TableView
extension CountryDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tableData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        tableData[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tableData = tableData[section].data as? [String] {
            return tableData.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let tableData = tableData[indexPath.section].data as? [String] {
            var content = cell.defaultContentConfiguration()
            content.text = "   \(tableData[indexPath.row])"
            cell.contentConfiguration = content
            
        } else {
            var content = cell.defaultContentConfiguration()
            content.text = "   \(tableData[indexPath.section].data ?? "")"
            cell.contentConfiguration = content
        }
        return cell
        
    }
    
    private func prepareData(country: Country?) -> [(title: String, data: Any?)] {
        guard let country = country else { return [] }
        return [
            (title: "Capital", data: country.capital),
            (title: "Region", data: country.region),
            (title: "Subregion", data: country.subregion),
            (title: "alpha3Code", data: country.alpha3Code),
            (title: "Population", data: country.population),
            (title: "Alternative Spellings", data: country.altSpellings),
            (title: "Timezones", data: country.timezones)
        ]
    }
}

