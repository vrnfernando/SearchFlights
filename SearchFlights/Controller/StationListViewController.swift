//
//  StationListViewController.swift
//  SearchFlights
//
//  Created by Vishwa Fernando on 2023-08-20.
//

import UIKit

protocol ObjectShare  {
    func share(tag: Int, station: Station)
}

class StationListViewController: UIViewController {
    
    // Protocol Delegate
    static var delegate       : ObjectShare!

    // UISearchBar
    private var searchBar: UISearchBar!
    
    // TableView
    private var tableView: UITableView!
    
    // Filtered Items
    private var filteredItemList: [Station] = []
    
    var stationList: [Station] = []{
        didSet {
            filteredItemList = stationList
        }
    }
    
    // Parameters pass from MainView
    var selectedButtonTag: Int!
    var originStation_code : String = ""
    var destinationStation_code : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Validate Stations
        validateStations()
        
        // UI Config
        setUpUi()
        
    }
    
    private func setUpUi(){
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "StationTableViewCell", bundle: nil), forCellReuseIdentifier: "stationCell")
        
        // Add SeacrhBar to the View
        view.addSubview(searchBar)
        
        // Add TableView to the View
        view.addSubview(tableView)
        
        setupConstraints()
        
    }
    
    private func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    // Validate Stations
    private func validateStations(){
        
        if originStation_code != ""{
            let index = stationList.firstIndex(where: { $0.code == originStation_code})!
            stationList.remove(at: index)
        }else if destinationStation_code != "" {
            let index = stationList.firstIndex(where: { $0.code == destinationStation_code})!
            stationList.remove(at: index)
        }
        
        filteredItemList = stationList
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: location)
        
        let selectedStationObj = filteredItemList[indexPath!.row]
        
        StationListViewController.delegate.share(tag: selectedButtonTag, station: selectedStationObj)
        
        self.dismiss(animated: true)
        
    }

}


extension StationListViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell", for: indexPath) as! StationTableViewCell
        cell.lb_stationName.text = filteredItemList[indexPath.row].name
        cell.lb_stationCode.text = filteredItemList[indexPath.row].code
        cell.lb_country.text = filteredItemList[indexPath.row].countryName
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        return cell
    }
    
    // Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredItemList.removeAll()
        filteredItemList = searchText.isEmpty ? stationList : stationList.filter { $0.name!.contains(searchText) || $0.code!.contains(searchText) }
        tableView.reloadData()
    }
    
}
