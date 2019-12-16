//
//  TouchMKMapView.swift
//  StructionSiteCC
//
//  Created by Paul Dewaal on 12/15/19.
//  Copyright © 2019 Dekabe Studios. All rights reserved.
//

import MapKit


protocol TouchMapViewDelegate: class {
    func didTouchAndHold(mapView: MKMapView, at: CGPoint, coord: CLLocationCoordinate2D)
}

class TouchMKMapView: MKMapView {
    
    weak var touchDelegate: TouchMapViewDelegate?
    
    private var sinceTouch: Timer?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let point = touches.first?.location(in: self) else {
            return
        }
        
        var touchedEmpty = true
        
        for tmp in self.annotations(in: self.visibleMapRect) {
            
            if let view = self.view(for: tmp as! MKAnnotation), view.frame.contains(point) {
                touchedEmpty = false
                break
            }
        }
        
        guard touchedEmpty else {
            return
        }
        
        sinceTouch = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { (timer) in
            timer.invalidate()
            let location = self.convert(point, toCoordinateFrom: self)

            DispatchQueue.main.async {
                self.touchDelegate?.didTouchAndHold(mapView: self, at: point, coord: location)
            }
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        sinceTouch?.invalidate()
        sinceTouch = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        sinceTouch?.invalidate()
        sinceTouch = nil
    }
}
