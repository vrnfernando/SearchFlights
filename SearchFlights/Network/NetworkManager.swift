//
//  NetworkManager.swift
//  SearchFlights
//
//  Created by Vishwa Fernando on 2023-08-20.
//

import Foundation
import Alamofire

class NetWorkManager {
    
    static let shared = NetWorkManager()
    
    var headers         : HTTPHeaders
    
    private init() {
        self.headers    = [
            "Content-Type":"application/json",
            "client" : "ios",
            "client-version":"3.999.0"]
    }
    
    
    // Get Station List
    func fetchStationsFromServer(url:String, completion: @escaping (Stations?, Error?) -> Void) {
        
        let _url = url
        
        AF.request(_url,method: .get, headers: self.headers).responseDecodable(of: Stations.self) { response in
            switch response.result {
            case .success(let stationsList):
                completion(stationsList, nil)
                
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    // Get Search Results
    func fetchSearchFlightsFromServer(url:String, completion: @escaping (FlightDetail?, Error?) -> Void) {
        
        let _url = url
        
        AF.request(_url,method: .get, headers: self.headers).responseDecodable(of: FlightDetail.self) { response in
            switch response.result {
            case .success(let flightDetail):
                completion(flightDetail, nil)
                
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
}
