//
//  DetailsVC.swift
//  TripToUK
//
//  Created by Berk on 1.11.2022.
//

import UIKit
import MapKit
import SDWebImage

class DetailsVC: UIViewController, MKMapViewDelegate {

    @IBOutlet var detailsImageView: UIImageView!
    @IBOutlet var detailsNameLabel: UILabel!
    @IBOutlet var detailsTypeLabeli: UILabel!
    @IBOutlet var detailsHiglightsLabel: UILabel!
    @IBOutlet var detailsMapView: MKMapView!
    
    var selectedPlaceID = ""
    var selectedPlaceName = ""
    var selectedPlaceType = ""
    var selectedHighlights = ""
    var selectedPicture = ""
    var selectedLatitude = Double()
    var selectedLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
        
        detailsMapView.delegate = self
        
    }
    
    func getData() {
        
        detailsNameLabel.text = selectedPlaceName
        detailsTypeLabeli.text = selectedPlaceType
        detailsHiglightsLabel.text = selectedHighlights
        detailsImageView.sd_setImage(with: URL(string: selectedPicture))
        
        // MAPS
        let location = CLLocationCoordinate2D(latitude: selectedLatitude, longitude: selectedLongitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
        let region = MKCoordinateRegion(center: location, span: span)
        self.detailsMapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = selectedPlaceName
        annotation.subtitle = selectedPlaceType
        detailsMapView.addAnnotation(annotation)
        
    }
    
    // Adding Pin and Disclosure Button
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    // NAVIGATION
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.selectedLatitude != 0.0 && self.selectedLongitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.selectedLatitude, longitude: self.selectedLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                if error != nil {
                    print(error?.localizedDescription ?? "Error")
                } else {
                    if let placemark = placemarks {
                        if placemark.count > 0 {
                            let mkPlacemark = MKPlacemark(placemark: placemark[0])
                            let mapItem = MKMapItem(placemark: mkPlacemark)
                            mapItem.name = self.selectedPlaceName
                            
                            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                            
                            mapItem.openInMaps(launchOptions: launchOptions)
                        }
                    }
                }
            }
        }
    }
}
