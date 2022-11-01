//
//  DetailsVC.swift
//  TripToUK
//
//  Created by Berk on 1.11.2022.
//

import UIKit
import MapKit

class DetailsVC: UIViewController {

    @IBOutlet var detailsImageView: UIImageView!
    @IBOutlet var detailsNameLabel: UILabel!
    @IBOutlet var detailsTypeLabeli: UILabel!
    @IBOutlet var detailsHiglightsLabel: UILabel!
    @IBOutlet var detailsMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
