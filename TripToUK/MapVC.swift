//
//  MapVC.swift
//  TripToUK
//
//  Created by Berk on 1.11.2022.
//

import UIKit
 import MapKit

class MapVC: UIViewController {

    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
    }
    
//    @objc func saveButtonTapped() {
//
//    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
}
