//
//  FilteredFlights.swift
//  SearchFlights
//
//  Created by Vishwa Fernando on 2023-08-20.
//

import Foundation

struct FiltedFlights: Codable {
    let dateOut: String?
    let flightNumber: String?
    let regularFare: RegularFare?
}
