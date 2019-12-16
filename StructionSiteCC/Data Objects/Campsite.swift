//
//  Campsite.swift
//  StructionSiteCC
//
//  Created by Paul Dewaal on 12/12/19.
//  Copyright © 2019 Dekabe Studios. All rights reserved.
//

import MapKit


class Campsite {
    
    static func createCampsiteFrom(dict: [String: Any]) -> Campsite? {
        guard let lat = dict["latitude"] as? Double, let long = dict["longitude"] as? Double, let name = dict["name"] as? String, let description = dict["description"] as? String else {
            return nil
        }
        let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(lat), CLLocationDegrees(long))
        return Campsite(coordinate: coordinate, name: name, description: description)
    }
    
    var location: CLLocationCoordinate2D
    var name: String
    var description: String
    var isClosed: Bool = false
    
    init(coordinate: CLLocationCoordinate2D, name: String, description: String) {
        self.name = name
        self.description = description
        self.location = coordinate
    }
}

extension Campsite {
    static func loadFromLocal(filename: String) -> [Campsite] {
        guard let path = Bundle.main.path(forResource: filename, ofType: "json"), let data = FileManager.default.contents(atPath: path) else {
            return []
        }
        
        do {
            guard let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]] else {
                return []
            }
            var sites = [Campsite]()
            for tmp in array {
                if let site = Campsite.createCampsiteFrom(dict: tmp) {
                    sites.append(site)
                }
            }
            
            return sites
        }
        catch {
            return []
        }
    }
    
    func createAnnotation() -> CampsiteAnnotation {
        return CampsiteAnnotation(site: self)
    }
}
