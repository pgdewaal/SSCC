//
//  GroupAnnotationView.swift
//  StructionSiteCC
//
//  Created by Paul Dewaal on 12/15/19.
//  Copyright © 2019 Dekabe Studios. All rights reserved.
//

import MapKit


class GroupAnnotationView: MKAnnotationView {

     
     private let countLbl: UILabel
     
     override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        countLbl = UILabel(frame: CGRect.zero)
        countLbl.font = UIFont.boldSystemFont(ofSize: 10)
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.image = UIImage(named: "camper_group")
        self.canShowCallout = false
        self.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        self.addSubview(countLbl)
     }
    
     required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
     }
    
     override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultLow
        
        guard let group = annotation as? MKClusterAnnotation else {
            return
        }
        countLbl.text = "\(group.memberAnnotations.count)"
        countLbl.sizeToFit()
        countLbl.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height)
     }
        
     override func prepareForReuse() {
        super.prepareForReuse()
        
        countLbl.text = ""
    }
}

