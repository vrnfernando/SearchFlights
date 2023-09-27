//
//  StationModel.swift
//  SearchFlights
//
//  Created by Vishwa Fernando on 2023-08-20.
//

import Foundation

struct Stations: Codable{
    let stations: [Station]
}

struct Station: Codable {
    let code: String?
    let name: String?
    let alternateName: String?
    let alias: [String]?
    let countryCode: String?
    let countryName: String?
    let countryAlias: String?
    let countryGroupCode: String?
    let countryGroupName: String?
    let timeZoneCode: String?
    let latitude: String?
    let longitude: String?
    let mobileBoardingPass: Bool
    let markets: [Market]?
    let notices: String?
    let tripCardImageUrl: String?
}

struct Market: Codable {
    let code: String?
    let group: String?
}
