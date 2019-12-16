//
//  MainViewController.swift
//  StructionSiteCC
//
//  Created by Paul Dewaal on 12/12/19.
//  Copyright © 2019 Dekabe Studios. All rights reserved.
//

import UIKit
import MapKit

class BaseNavigationController: UINavigationController {

    init() {
        let vc = MainViewController()
        super.init(rootViewController: vc)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let campgroundTable: UITableView
    var campgrounds: [Campground]
    
    init() {
        campgroundTable = UITableView(frame: CGRect.zero, style: .grouped)
        campgrounds = Campground.loadMockCampgrounds()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        campgroundTable.delegate = self
        campgroundTable.dataSource = self
        campgroundTable.frame = self.view.bounds
        self.view.addSubview(campgroundTable)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        campgrounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basic") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "basic")
        let campground = campgrounds[indexPath.row]
        let closed = campground.campsites.filter { (campsite) -> Bool in
            return campsite.isClosed
        }.count
        
        cell.textLabel?.text = "\(campground.name)"
        cell.detailTextLabel?.text = "\(campground.campsites.count - closed) campsites open, \(closed) closed"
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let campground = campgrounds[indexPath.row]
        let vc = CampgroundViewController(current: campground)
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        campgroundTable.reloadData()
    }
}
