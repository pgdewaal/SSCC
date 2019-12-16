//
//  AddCampsiteVC.swift
//  StructionSiteCC
//
//  Created by Paul Dewaal on 12/15/19.
//  Copyright © 2019 Dekabe Studios. All rights reserved.
//

import UIKit
import MapKit

class CreateCampsiteVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    public let completion: (Campsite?) -> Void
    public let coordinate: CLLocationCoordinate2D
    
    private let nameField: UITextField
    private let descField: UITextField
    private let background: UIView
    private let backBtn: UIButton
    private let saveBtn: UIButton
    private let titleLabel: UILabel
    
    init(coord: CLLocationCoordinate2D, completion: @escaping (Campsite?) -> Void) {
        self.coordinate = coord
        self.completion = completion
        
        backBtn = UIButton(type: .close)
        saveBtn = UIButton(type: .contactAdd)
        titleLabel = UILabel(frame: CGRect.zero)
        nameField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        descField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        background = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 225))
        
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        background.backgroundColor = UIColor.white
        background.layer.borderColor = UIColor.darkGray.cgColor
        background.layer.borderWidth = 1
        background.frame.origin = CGPoint(x: self.view.frame.size.width/2 - background.frame.size.width/2, y: 200)
        self.view.addSubview(background)
        
        backBtn.center = background.frame.origin
        backBtn.layer.cornerRadius = backBtn.frame.size.height/2
        backBtn.backgroundColor = UIColor.lightGray
        backBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        self.view.addSubview(backBtn)
        
        saveBtn.center = CGPoint(x: background.frame.maxX, y: background.frame.minY)
        saveBtn.layer.cornerRadius = saveBtn.frame.size.height/2
        saveBtn.backgroundColor = UIColor.lightGray
        saveBtn.addTarget(self, action: #selector(save), for: .touchUpInside)
        self.view.addSubview(saveBtn)
        
        titleLabel.text = "Enter a name and description for the new campsite."
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.numberOfLines = 2
        titleLabel.frame.size = titleLabel.sizeThatFits(CGSize(width: background.frame.size.width - 50, height: background.frame.size.height))
        titleLabel.frame.origin = CGPoint(x: background.frame.size.width/2 - titleLabel.frame.size.width/2, y: 25)
        background.addSubview(titleLabel)
        
        nameField.placeholder = "Name"
        nameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: nameField.frame.size.height))
        nameField.leftViewMode = .always
        nameField.frame.origin = CGPoint(x: background.frame.size.width/2 - nameField.frame.size.width/2, y: titleLabel.frame.maxY + 15)
        nameField.backgroundColor = UIColor.white
        nameField.layer.borderColor = UIColor.black.cgColor
        nameField.layer.borderWidth = 1
        nameField.delegate = self
        background.addSubview(nameField)
        
        descField.placeholder = "Description"
        descField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: nameField.frame.size.height))
        descField.leftViewMode = .always
        descField.frame.origin = CGPoint(x: background.frame.size.width/2 - descField.frame.size.width/2, y: nameField.frame.maxY + 25)
        descField.layer.borderColor = UIColor.black.cgColor
        descField.layer.borderWidth = 1
        descField.delegate = self
        background.addSubview(descField)
    }
    
    @objc private func cancel() {
        self.completion(nil)
        self.dismiss(animated: true)
    }
    
    @objc private func save() {
        guard let name = nameField.text, !name.isEmpty, let description = descField.text, !description.isEmpty else {
            return
        }
        let campsite = Campsite(coordinate: coordinate, name: name, description: description)
        self.completion(campsite)
        self.dismiss(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
}
