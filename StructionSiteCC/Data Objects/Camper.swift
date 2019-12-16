//
//  Camper.swift
//  StructionSiteCC
//
//  Created by Paul Dewaal on 12/12/19.
//  Copyright © 2019 Dekabe Studios. All rights reserved.
//

import MapKit


struct Camper {
    static func createCamperFrom(dict: [String: Any]) -> Camper? {
        guard let lat = dict["lat"] as? Double, let long = dict["long"] as? Double, let name = dict["name"] as? String, let description = dict["description"] as? String, let phone = dict["phone"] as? String else {
            return nil
        }
        let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(floatLiteral: lat), CLLocationDegrees(floatLiteral: long))
        return Camper(coordinate: coordinate, name: name, description: description, phone: phone)
    }
    
    var location: CLLocationCoordinate2D
    var name: String
    var description: String
    
    init(coordinate: CLLocationCoordinate2D, name: String, description: String, phone: String) {
        self.name = name
        self.description = "\(description) | \(phone)"
        self.location = coordinate
    }
}

extension Camper {
    static func randomlyCreate() -> [Camper] {
        var campers = [Camper]()
        
        var x = 1
        
        while x < 31 {
            campers.append(self.randomCamper(name: "Camper \(x)"))
            x = x + 1
        }
        
        return campers
    }
    
    static func randomCamper(name: String) -> Camper {
        let gender: [String] = ["male", "female"]
        //        let clothes: [String] = ["jeans and a t shirt.", "shorts and a t shirt.", "jeans and a jacket", "shorts and a jacket"]
        let height: [String] = ["tall", "average", "short"]
        let weigth: [String] = ["thin", "average", "heavy"]
        
        let ranLat = Double((arc4random()%45))/100.0
        let lat = 48.5083577 + ranLat
        
        let ranLong = Double((arc4random()%100))/100.0
        let long = -114.362525 + ranLong
        
        let coord = CLLocationCoordinate2DMake(CLLocationDegrees(floatLiteral: lat), CLLocationDegrees(floatLiteral: long))
        let description = "\(height.randomElement()!), \(weigth.randomElement()!) \(gender.randomElement()!) camper"
        let phone = "999-\(arc4random()%10)\(arc4random()%10)\(arc4random()%10)-\(arc4random()%10)\(arc4random()%10)\(arc4random()%10)\(arc4random()%10)"
        let camper = Camper(coordinate: coord, name: name, description: description, phone: phone)
        
        return camper
    }
    
    func createAnnotation() -> CamperAnnotation {
        return CamperAnnotation(person: self)
    }
}
