//
//  CamperAnnotation.swift
//  StructionSiteCC
//
//  Created by Paul Dewaal on 12/15/19.
//  Copyright © 2019 Dekabe Studios. All rights reserved.
//

import MapKit


class CamperAnnotation: NSObject, MKAnnotation {
    
    let person: Camper
    
    var coordinate: CLLocationCoordinate2D {
        return person.location
    }
    var title: String? {
        return person.name
    }
    var subtitle: String? {
        return person.description
    }
    
    init(person: Camper) {
        self.person = person
        
        super.init()
    }
}
