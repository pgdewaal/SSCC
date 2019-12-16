//
//  Campground.swift
//  StructionSiteCC
//
//  Created by Paul Dewaal on 12/12/19.
//  Copyright © 2019 Dekabe Studios. All rights reserved.
//

import MapKit


class Campground {
    let center: CLLocationCoordinate2D
    let name: String
    var campsites: [Campsite]
    
    required init(center: CLLocationCoordinate2D, name: String, campsites: [Campsite]) {
        self.center = center
        self.name = name
        self.campsites = campsites
    }
}

extension Campground {
    private enum MockCampgrounds: CaseIterable {
        case glacier
        
        var location: CLLocationCoordinate2D {
            switch self {
            case .glacier:
                return CLLocationCoordinate2DMake(CLLocationDegrees(floatLiteral: 48.8261335), CLLocationDegrees(floatLiteral: -113.9398217))
            }
        }
        
        var name: String {
            switch self {
            case .glacier:
                return "Glacier National Park"
            }
        }
        
        var filename: String {
            switch self {
            case .glacier:
                return "glacier"
            }
        }
    }
    
    
    static func loadMockCampgrounds() -> [Campground] {
        var camps = [Campground]()
        for camp in MockCampgrounds.allCases {
            let campsites = Campsite.loadFromLocal(filename: camp.filename)
            let ground = Campground(center: camp.location, name: camp.name, campsites: campsites)
            camps.append(ground)
        }
        
        return camps
    }
}
