//
//  GoogleDistanceService.swift
//  NavigateMe
//
//  Created by mahbub on 3/7/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import Foundation
import CoreLocation

class GoogleDistanceService: RESTService {
    
    static private let networkProtocol = "https"
    static private let host = "maps.googleapis.com"
    
    init() {
        
        super.init(with: GoogleDistanceService.networkProtocol, host: GoogleDistanceService.host)
    }
    
    override func callbackAfterCompletion(data: Data?, response: URLResponse?, error: Error?) {
        
        if error != nil {
            
            print("Response Error [GoogleDistanceService.swift]: \(error!.localizedDescription)")
            self.delegate?.dataDidFail(reason: "Invalid Response from Google Map API.")
            return
        }
        
        guard let data = data else {
            
            print("Response Error [GoogleDistanceService.swift]: No Data is Found.")
            self.delegate?.dataDidFail(reason: "Invalid Response from Google Map API.")
            return
        }
        
        do {
            
            let googleDistance = try JSONDecoder().decode(GoogleDistance.self, from: data)
            self.delegate?.dataDidReceive(data: googleDistance)
            
        } catch let jsonError {
            
            print("JSON Error [GoogleDistanceService.swift]: \(jsonError)")
            self.delegate?.dataDidFail(reason: "Unable to decode JSON message from Google Map API.")
        }
    }
    
    func get(origins: [CLLocationCoordinate2D], destinations: [CLLocationCoordinate2D]) {
        
        var query = [String : String?]()

        query["origins"] = origins.map({ "\($0.latitude),\($0.longitude)" }).joined(separator: "|")
        query["destinations"] = destinations.map({ "\($0.latitude),\($0.longitude)" }).joined(separator: "|")
        query["key"] = "AIzaSyA5WKLZCTreqWGGVNdeucTzqCgsLfEf8CU"
        query["mode"] = "walking"
        
        let requestUrl = "/maps/api/distancematrix/json"
        let url = self.generateURL(using: requestUrl, query: query)
        
        self.processGET(for: url)
    }
    
}