//
//  CampsiteAnnotation.swift
//  StructionSiteCC
//
//  Created by Paul Dewaal on 12/15/19.
//  Copyright © 2019 Dekabe Studios. All rights reserved.
//

import MapKit

class CampsiteAnnotation: NSObject, MKAnnotation {
    
    private(set) var site: Campsite
    
    var coordinate: CLLocationCoordinate2D {
        return site.location
    }
    var title: String? {
        return site.name
    }
    var subtitle: String? {
        return site.description
    }
    
    init(site: Campsite) {
        self.site = site
        
        super.init()
    }
    
    func toggleCampsiteAccess() {
        site.isClosed = !site.isClosed
    }
    
    func updateLocation(newCoordinate: CLLocationCoordinate2D) {
        site.location = newCoordinate
    }
}

