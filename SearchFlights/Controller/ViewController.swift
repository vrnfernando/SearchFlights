//
//  ViewController.swift
//  SearchFlights
//
//  Created by Vishwa Fernando on 2023-08-19.
//

import UIKit

class ViewController: UIViewController, ObjectShare {
    
    // Get selected Station from StationList
    func share(tag: Int, station: Station) {
        switch tag {
        case 1:
            origin_station = station
            break
        case 2:
            destination_station = station
            break
        default:
            break
        }
    }
    
    
    // UIStepper
    let adultCountStepper = UIStepper()
    let teensCountStepper = UIStepper()
    let childCountStepper = UIStepper()
    
    // Middle Count Label
    let lb_adultsCount_number = UILabel()
    let lb_teensCount_number = UILabel()
    let lb_childrenCount_number = UILabel()
    
    // Contain View
    let containerView = UIView()
    
    // Card View
    let cardView = UIView()
    
    // UIButton: Origin
    var originButton: UIButton!
    
    // UIButton: Destination
    var destinationButton: UIButton!
    
    // Date Picker
    let selectedDatePicker = UIDatePicker()
    
    // TableView
    var tableView:UITableView!
    
    // Selected Origin station
    var origin_station: Station? = nil {
        didSet{
            
            // Set selected Origin Station for Button.
            originButton.setTitle(origin_station?.name, for: .normal)
            
        }
    }
    
    // Selected Destination station
    var destination_station: Station? = nil {
        didSet{
            
            // Set selected Destination Station for Button.
            destinationButton.setTitle(destination_station?.name, for: .normal)
        }
    }
    
    // Adult Count
    var adultsCount: Int   = 1 {
        didSet {
            lb_adultsCount_number.text = String(adultsCount)
        }
    }
    
    // Teen Count
    var teensCount: Int    = 0 {
        didSet{
            lb_teensCount_number.text = String(teensCount)
        }
    }
    
    // Child Count
    var childrenCount: Int = 0 {
        didSet{
            lb_childrenCount_number.text = String(childrenCount)
        }
    }
    
    // Selected Date
    var _selectedDate: String = ""
    
    // Station List
    var stationList: [Station] = []
    
    // FiltedFlights
    var filtedFlightList:[FiltedFlights] = []
    
    //Flight Details
    var flightDetail : FlightDetail! {
        didSet{
            
            if flightDetail != nil {
                
                filtedFlightList.removeAll()
                
                for trip in flightDetail.trips{
                    
                    for date in trip.dates{
                        
                        let dateOut = date.dateOut
                        
                        for flight in date.flights{
                            
                            let regularFare = flight.regularFare
                            let flightNumber = flight.flightNumber
                            
                            let filtedFlight = FiltedFlights.init(dateOut: dateOut, flightNumber: flightNumber, regularFare: regularFare)
                            filtedFlightList.append(filtedFlight)
                            
                        }
                    }
                }
                // Relaod Table View
                tableView.reloadData()
                
                // Show message if there haven't any flights
                if filtedFlightList.isEmpty {
                    showAlert(alertText: "Message", alertMessage: "Flights Not Availble For Selected Date!")
                }
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
   
        // UI Config
        setUpUI()
        
        // StationList Protocol Delegate
        StationListViewController.delegate = self
        
        //show BlurLoader
        view.showBlurLoader()
        
        //Network Request
        getStationList()
        
    }

    private func setUpUI(){
        view.backgroundColor = .gray
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the containerView to the view
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1.8/4.0)
        ])
        
        // Card View
        cardView.backgroundColor = .lightGray.withAlphaComponent(0.5)
        cardView.layer.cornerRadius = 10
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the cardView to the view
        containerView.addSubview(cardView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            cardView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            cardView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            cardView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.45)
        ])
        
        // Button Configuration
        var configuration = UIButton.Configuration.filled()
        configuration.titlePadding = 10
        
        // Origin Button
        originButton = UIButton(configuration: configuration)
        originButton.setTitle("From", for: .normal)
        originButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        originButton.tintColor = UIColor.black.withAlphaComponent(0.7)
        originButton.tag = 1
        originButton.addTarget(self, action: #selector(movePopUpSelectStation(_:)), for: .touchUpInside)
        
        // Destination Button
        destinationButton = UIButton(configuration: configuration)
        destinationButton.setTitle("To", for: .normal)
        destinationButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        destinationButton.tintColor = UIColor.black.withAlphaComponent(0.7)
        destinationButton.tag = 2
        destinationButton.addTarget(self, action: #selector(movePopUpSelectStation(_:)), for: .touchUpInside)
        
        // Aircraft Icon
        let aircraftIcon = UIImageView(image: UIImage(systemName: "airplane"))
        aircraftIcon.tintColor = UIColor.white
        aircraftIcon.contentMode = .scaleAspectFit
        
        // Top Stack View
        let buttonStackView = UIStackView(arrangedSubviews: [originButton, aircraftIcon, destinationButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 10
        buttonStackView.alignment = .center
        buttonStackView.distribution = .fillProportionally
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.layer.backgroundColor = UIColor.white.withAlphaComponent(0.1).cgColor
        
        // Add the buttonStackView to the view
        cardView.addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            buttonStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            buttonStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10)
        ])
        
        // Date Picker Config
        selectedDatePicker.backgroundColor = UIColor.darkGray
        selectedDatePicker.datePickerMode = .date
        selectedDatePicker.setValue(UIColor.white, forKeyPath: "textColor")

        // Disable past days by setting the minimumDate to today's date
        selectedDatePicker.minimumDate = Date()
        
        // Add the datePicker to the view
        view.addSubview(selectedDatePicker)
        selectedDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        // Add a target to capture date selection
        selectedDatePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        // Set Calnder Icon
        let calendarIcon = UIImageView(image: UIImage(systemName: "calendar"))
        calendarIcon.tintColor = .black.withAlphaComponent(0.5)
        calendarIcon.contentMode = .scaleAspectFit
        
        let dateStackView = UIStackView(arrangedSubviews: [selectedDatePicker, calendarIcon])
        dateStackView.axis = .horizontal
        dateStackView.spacing = 10
        dateStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the dateStack to the view
        cardView.addSubview(dateStackView)
        
        NSLayoutConstraint.activate([
            dateStackView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            dateStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20)
        ])
        
        // Label Adult
        let adultsCountLabel = UILabel()
        adultsCountLabel.text = "Adults"
        adultsCountLabel.textColor = .white
        
        // Label Teen
        let teensCountLabel = UILabel()
        teensCountLabel.text = "Teens"
        teensCountLabel.textColor = .white
        
        // Label Child
        let childrenCountLabel = UILabel()
        childrenCountLabel.text = "Children"
        childrenCountLabel.textColor = .white
        
        // Middle Count Label
        lb_teensCount_number.text    = "0"
        lb_adultsCount_number.text   = "1"
        lb_childrenCount_number.text = "0"
        
        // StackView Adults
        let adultStackView = UIStackView(arrangedSubviews: [
            adultsCountLabel, lb_adultsCount_number, adultCountStepper
        ])
        adultStackView.axis = .vertical
        adultStackView.spacing = 2
        adultStackView.alignment = .center
        adultStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // StackView Teens
        let teensStackView = UIStackView(arrangedSubviews: [
            teensCountLabel, lb_teensCount_number, teensCountStepper
        ])
        teensStackView.axis = .vertical
        teensStackView.spacing = 2
        teensStackView.alignment = .center
        teensStackView.translatesAutoresizingMaskIntoConstraints = false

        // StackView Child
        let childStackView = UIStackView(arrangedSubviews: [
            childrenCountLabel, lb_childrenCount_number, childCountStepper
        ])
        childStackView.axis = .vertical
        childStackView.spacing = 2
        childStackView.alignment = .center
        childStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let countsStackView = UIStackView(arrangedSubviews: [
            adultStackView,
            teensStackView,
            childStackView
        ])
        
        countsStackView.axis = .horizontal
        countsStackView.spacing = 20
        countsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the countsStackView to the view
        containerView.addSubview(countsStackView)
        
        NSLayoutConstraint.activate([
            countsStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            countsStackView.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 10)
        ])
        
        // Search Button
        let searchButton = UIButton(type: .system)
        searchButton.setTitle("Search", for: .normal)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        searchButton.tintColor = UIColor.white
        searchButton.layer.cornerRadius = 8
        searchButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        searchButton.addTarget(self, action: #selector(actionGetSearchResult(_:)), for: .touchUpInside)
        
        // Add the searchButton to the view
        containerView.addSubview(searchButton)
        
        NSLayoutConstraint.activate([
            searchButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            searchButton.topAnchor.constraint(equalTo: countsStackView.bottomAnchor, constant: 10),
            searchButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            searchButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
        
        // TableView
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the tableView to the view
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FlightInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "flightInfoCell")
        
        // Adult steppr config
        adultCountStepper.minimumValue = 1
        adultCountStepper.maximumValue = 6
        adultCountStepper.value = Double(adultsCount)
        adultCountStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        
        // Teen steppr config
        teensCountStepper.minimumValue = 0
        teensCountStepper.maximumValue = 6
        teensCountStepper.value = Double(teensCount)
        teensCountStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        
        // Child steppr config
        childCountStepper.minimumValue = 0
        childCountStepper.maximumValue = 6
        childCountStepper.value = Double(childrenCount)
        childCountStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
    }
    
    // Action Select Station
    @objc func movePopUpSelectStation(_ sender: UIButton) {
        
        let stationListController = StationListViewController()
    
        stationListController.modalTransitionStyle = .crossDissolve
        stationListController.modalPresentationStyle = .popover
        stationListController.stationList = stationList
        stationListController.selectedButtonTag = sender.tag
        stationListController.originStation_code = origin_station?.code ?? ""
        stationListController.destinationStation_code = destination_station?.code ?? ""
        self.present(stationListController, animated: true, completion: nil)
    }
    
    
    //  Date selection
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        
        let selectedDate = sender.date
        _selectedDate = getStringDate(date: selectedDate)
        
    }
    
    // Stepper set value
    @objc func stepperValueChanged(_ sender: UIStepper) {
        if sender == adultCountStepper {
            adultsCount = Int(sender.value)
        } else if sender == teensCountStepper {
            teensCount = Int(sender.value)
        } else if sender == childCountStepper {
            childrenCount = Int(sender.value)
        }
    }
    
    // Search Button Action:  Search result
    @objc func actionGetSearchResult(_ sender: UITapGestureRecognizer) {
        
        // Check Origin station and Destination stations Selected or NOT
        if origin_station != nil && destination_station != nil {
            
            let origin_code = (origin_station?.code)! as String
            let destination_code = (destination_station?.code)! as String
            
            if _selectedDate == "" {
                
                let selectedDate = selectedDatePicker.date
                _selectedDate = getStringDate(date: selectedDate)
                
            }
            
            // Query Parameters set into Main URL
            let url:String = "https://nativeapps.ryanair.com/api/v4/Availability?origin=\(origin_code)&destination=\(destination_code)&dateout=\(_selectedDate)&datein=&flexdaysbeforeout=3&flexdaysout=3&flexdaysbeforein=3&flexdaysin=3&adt=\(adultsCount)&teen=\(teensCount)&chd=\(childrenCount)&roundtrip=false&ToUs=AGREED&Disc=0"
            
            //show BlurLoader
            view.showBlurLoader()
            
            // Call Network Request
            getSearchResults(url: url)
            
        }else{
            
            // Show Message
            showAlert(alertText: "Message", alertMessage: "Please Select \("Origin/Destination") and try again!")
            
        }
    }
    
    // Get String date for selected date
    func getStringDate(date: Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    // Format String Date
    func formatStringDate(date: String)-> String {
        
        // Date formatter for the input format
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        if let inputDate = inputFormatter.date(from: date) {
            // Date formatter for the output format
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd"
            
            // Convert the date to the desired output format
            let outputDateString = outputFormatter.string(from: inputDate)
            
            return outputDateString
        } else {
            print("Invalid date format")
        }
        
        return ""
    }
    
    
    // Get Station List
    private func getStationList(){
        
        let url: String = "https://mobile-testassets-dev.s3.eu-west-1.amazonaws.com/stations.json"
        
        NetWorkManager.shared.fetchStationsFromServer(url: url) { (stations, error) in
            
            //Remove BlurLoader
            self.view.removeBluerLoader()
            
            if let error = error {
                let erroMessage = "Error fetching data: \(error.localizedDescription)"
                self.showAlert(alertText: "Error", alertMessage: erroMessage)
                return
            }
            
            if let stations = stations?.stations {
                self.stationList = stations
            }
        }
    }
    
    // Get Flight Detail Search Results
    func getSearchResults(url: String){
        
        NetWorkManager.shared.fetchSearchFlightsFromServer(url: url) { (flightInfo, error) in
            
            //Remove BlurLoader
            self.view.removeBluerLoader()
            
            if let error = error {
                let erroMessage = "Error fetching data: \(error.localizedDescription)"
                self.showAlert(alertText: "Error", alertMessage: erroMessage)
                return
            }
            
            if let _flightInfo = flightInfo {
                self.flightDetail = _flightInfo
            }
        }
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtedFlightList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flightInfoCell", for: indexPath) as! FlightInfoTableViewCell
        cell.lb_date.text = formatStringDate(date: filtedFlightList[indexPath.row].dateOut!)
        cell.lb_flightNumber.text = filtedFlightList[indexPath.row].flightNumber
        
        if filtedFlightList[indexPath.row].regularFare != nil {
            cell.lb_regularFair.text = filtedFlightList[indexPath.row].regularFare!.fares!.isEmpty  ?  "" : String(filtedFlightList[indexPath.row].regularFare!.fares![0].amount!)
        }
        return cell
    }
}
