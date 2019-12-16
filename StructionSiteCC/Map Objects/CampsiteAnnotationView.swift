//
//  CampsiteAnnotationView.swift
//  StructionSiteCC
//
//  Created by Paul Dewaal on 12/15/19.
//  Copyright © 2019 Dekabe Studios. All rights reserved.
//

import MapKit


protocol MovableCampsiteProtocol: class {
    func beganMoving(view: CampsiteAnnotationView)
    func endMoving(view: CampsiteAnnotationView)
}

private enum MoveState {
    case immovable, movable
}

class CampsiteAnnotationView: MKAnnotationView {
    
    let closedBtn: UIButton
    weak var movableDelegate: MovableCampsiteProtocol?
    
    private var sinceTouch: Timer?
    private var state: MoveState = .immovable
    private var firstTouch: CGPoint?
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        closedBtn = UIButton(type: .custom)
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = true
        self.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        
        closedBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        closedBtn.setTitleColor(UIColor.black, for: .normal)
        closedBtn.addTarget(self, action: #selector(closeOpenCampsite), for: .touchUpInside)
        updateUI()
        self.rightCalloutAccessoryView = closedBtn
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        displayPriority = .defaultHigh
        updateUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        movableDelegate = nil
        cancelMovable()
    }
    
    func updateUI() {
        guard let campsite = self.annotation as? CampsiteAnnotation else {
            //Had an error!
            return
        }
        
        self.image = UIImage(named: campsite.site.isClosed ? "campsite_closed" : "campsite")
        let center = self.center
        self.frame.size = CGSize(width: 25, height: 25)
        self.center = center
        closedBtn.setTitle(campsite.site.isClosed ? "Open" : "Close", for: .normal)
        closedBtn.sizeToFit()
    }
    
    @objc private func closeOpenCampsite() {
        guard let campsite = self.annotation as? CampsiteAnnotation else {
            //Had an error!
            return
        }
        campsite.toggleCampsiteAccess()
        updateUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        firstTouch = touches.first?.location(in: self)
        
        sinceTouch = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { (timer) in
            timer.invalidate()
            self.movableDelegate?.beganMoving(view: self)
            let orig = self.transform3D
            
            UIView.animate(withDuration: 0.2, animations: {
                self.transform3D = CATransform3DMakeRotation(.pi/8, 0, 0, 1.0)
            }) { (success) in
                UIView.animate(withDuration: 0.2) {
                    self.transform3D = orig
                    self.state = .movable
                }
            }
        })
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let prev = touches.first?.previousLocation(in: self), let cur = touches.first?.location(in: self) else {
            return
        }
        let diffx = cur.x - prev.x
        let diffy = cur.y - prev.y
        
        if let first = firstTouch {
            let distance = sqrt(pow(cur.x - first.x, 2) + pow(cur.y - first.y, 2))
            if state == .immovable, distance > 10 {
                self.cancelMovable()
            }
        }
        
        guard state == .movable else {
            return
        }
        
        self.center = CGPoint(x: self.center.x + diffx, y: self.center.y + diffy)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        self.cancelMovable()
        self.movableDelegate?.endMoving(view: self)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        self.cancelMovable()
    }
    
    private func cancelMovable() {
        sinceTouch?.invalidate()
        sinceTouch = nil
        self.state = .immovable
        firstTouch = nil
    }
}

