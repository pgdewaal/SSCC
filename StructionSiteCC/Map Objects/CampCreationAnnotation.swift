//
//  CampCreationAnnotation.swift
//  StructionSiteCC
//
//  Created by Paul Dewaal on 12/15/19.
//  Copyright © 2019 Dekabe Studios. All rights reserved.
//

import MapKit


class CampCreationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        
        super.init()
    }
    
}
