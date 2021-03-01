//
//  CountriesTableViewController.swift
//  Countries
//
//  Created by Алексей on 28.02.2021.
//

import UIKit

class CountriesTableViewController: UITableViewController {
    
    let countriesURL = "https://restcountries.eu/rest/v2/all"
    var countries: [Country] = []
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var filteredCountries = [Country]()
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCountriesList()
        setupSearchController()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCountries.count
        }
        return countries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryName", for: indexPath)
        
        var country: Country
        
        if isFiltering {
            country = filteredCountries[indexPath.row]
        } else {
            country = countries[indexPath.row]
        }
        
        var content = cell.defaultContentConfiguration()
        content.text = country.name
        content.secondaryText = country.nativeName
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let country: Country
            
            if isFiltering {
                country = filteredCountries[indexPath.row]
            } else {
                country = countries[indexPath.row]
            }
            
            let detailVC = segue.destination as! CountryDetailsViewController
            detailVC.country = country
        }
    }
}

extension CountriesTableViewController {
    private func fetchCountriesList () {
        guard let url = URL(string: countriesURL) else { return }
        
        URLSession.shared.dataTask(with: url) { [self] (data, _, _) in
            guard let data = data else { return }
            
            do {
                self.countries = try JSONDecoder().decode([Country].self, from: data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

//MARK: - Search
extension CountriesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        filteredCountries = countries.filter({ (country: Country) -> Bool in
            return (country.name?.lowercased().contains(searchText.lowercased()) ?? false)
        })
        tableView.reloadData()
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}
