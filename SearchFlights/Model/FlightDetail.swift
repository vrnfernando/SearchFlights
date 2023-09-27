//
//  Flight.swift
//  SearchFlights
//
//  Created by Vishwa Fernando on 2023-08-20.
//

import Foundation

struct TripDate: Codable {
    let dateOut: String?  // date
    let flights: [Flight]
}

struct Flight: Codable {
    let faresLeft: Int?
    let flightKey: String?
    let infantsLeft: Int?
    let regularFare: RegularFare?  //RegulF
    let operatedBy: String?
    let segments: [Segment]?
    let flightNumber: String?  // flightN
    let time: [String]?
    let timeUTC: [String]?
    let duration: String?
}

struct RegularFare: Codable {
    let fareKey: String?
    let fareClass: String?
    let fares: [Fare]?
}

struct Fare: Codable {
    let type: String?
    let amount: Double?
    let count: Int?
    let hasDiscount: Bool?
    let publishedFare: Double?
    let discountInPercent: Int?
    let hasPromoDiscount: Bool?
    let discountAmount: Double?
    let hasBogof: Bool?
}

struct Segment: Codable {
    let segmentNr: Int?
    let origin: String?
    let destination: String?
    let flightNumber: String?
    let time: [String]?
    let timeUTC: [String]?
    let duration: String?
}

struct Trip: Codable {
    let origin: String?
    let originName: String?
    let destination: String?
    let destinationName: String?
    let routeGroup: String?
    let tripType: String?
    let upgradeType: String?
    let dates: [TripDate]
}

struct FlightDetail: Codable {
    let termsOfUse: String?
    let currency: String?
    let currPrecision: Int?
    let routeGroup: String?
    let tripType: String?
    let upgradeType: String?
    let trips: [Trip]
    let serverTimeUTC: String?
}
