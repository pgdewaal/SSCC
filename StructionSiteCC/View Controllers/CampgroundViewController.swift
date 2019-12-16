//
//  CampgroundViewController.swift
//  StructionSiteCC
//
//  Created by Paul Dewaal on 12/12/19.
//  Copyright © 2019 Dekabe Studios. All rights reserved.
//

import Foundation
import MapKit

class CampgroundViewController: UIViewController, MKMapViewDelegate {
    
    private let map: TouchMKMapView
    private var camperCreator: Timer?
    private var campers: [Camper]
    
    public var currentCamp: Campground
    
    init(current: Campground) {
        self.map = TouchMKMapView()
        self.currentCamp = current
        self.campers = Camper.randomlyCreate()
        super.init(nibName: nil, bundle: nil)
        
        self.title = current.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.frame = self.view.bounds
        let region = MKCoordinateRegion(center: currentCamp.center, latitudinalMeters: CLLocationDistance(floatLiteral: 80000), longitudinalMeters: CLLocationDistance(floatLiteral: 80000))
        map.setRegion(region, animated: true)
        map.userTrackingMode = .none
        map.delegate = self
        map.touchDelegate = self
        map.showsUserLocation = false
        map.register(CampsiteAnnotationView.self, forAnnotationViewWithReuseIdentifier: "campsite")
        map.register(CamperAnnotationView.self, forAnnotationViewWithReuseIdentifier: "camper")
        map.register(GroupAnnotationView.self, forAnnotationViewWithReuseIdentifier: "group")
        self.view.addSubview(map)
        
        for tmp in currentCamp.campsites {
            map.addAnnotation(tmp.createAnnotation())
        }
        
        for tmp in campers {
            map.addAnnotation(tmp.createAnnotation())
        }
        
        camperCreator = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { (timer) in
            let camper = Camper.randomCamper(name: "Camper \(self.campers.count+1)")
            self.campers.append(camper)
            self.map.addAnnotation(camper.createAnnotation())
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        camperCreator?.invalidate()
        camperCreator = nil
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: CampsiteAnnotation.self) {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: "campsite", for: annotation) as? CampsiteAnnotationView
            view?.movableDelegate = self
            return view
        }
        else if annotation.isKind(of: CamperAnnotation.self) {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: "camper", for: annotation)
            return view
        }
        else if annotation.isKind(of: GroupAnnotation.self) {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: "group", for: annotation)
            return view
        }
        return nil
    }
    
    
    private func makeAllVisibleAnnotations(enabled: Bool, ignoring: MKAnnotation?) {
        let visible = map.annotations(in: map.visibleMapRect)
        for tmp in visible {
            if let anno = tmp as? MKAnnotation, !anno.isEqual(ignoring), let view = map.view(for: anno) {
                view.isEnabled = enabled
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
        return GroupAnnotation(memberAnnotations: memberAnnotations)
    }
}

extension CampgroundViewController: TouchMapViewDelegate {
    func didTouchAndHold(mapView: MKMapView, at: CGPoint, coord: CLLocationCoordinate2D) {
        let make = CampCreationAnnotation(coordinate: coord)
        mapView.addAnnotation(make)
        
        let vc = CreateCampsiteVC(coord: coord) { (campsite) in
            mapView.removeAnnotation(make)
            
            guard let camp = campsite else {
                return
            }
            self.currentCamp.campsites.append(camp)
            mapView.addAnnotation(camp.createAnnotation())
        }
        self.present(vc, animated: true, completion: nil)
    }
}

extension CampgroundViewController: MovableCampsiteProtocol {
    func beganMoving(view: CampsiteAnnotationView) {
        makeAllVisibleAnnotations(enabled: false, ignoring: view.annotation)
    }
    
    func endMoving(view: CampsiteAnnotationView) {
        let loc = map.convert(view.center, toCoordinateFrom: map)
        guard let annotation = view.annotation as? CampsiteAnnotation else {
            //Error
            return
        }
        annotation.updateLocation(newCoordinate: loc)
        map.removeAnnotation(annotation)
        makeAllVisibleAnnotations(enabled: true, ignoring: nil)
        map.addAnnotation(annotation)
    }
}
