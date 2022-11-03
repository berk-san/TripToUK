//
//  MapVC.swift
//  TripToUK
//
//  Created by Berk on 1.11.2022.
//

import UIKit
import MapKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        
        print(PlaceModel.sharedInstance.placeName)
        print(PlaceModel.sharedInstance.placeType)
        print(PlaceModel.sharedInstance.highlights)
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(pinLocation(gestureRecognizer:)))
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)
    }
    
    @objc func pinLocation(gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModel.sharedInstance.placeName
            annotation.subtitle = PlaceModel.sharedInstance.placeType
            
            self.mapView.addAnnotation(annotation)
            
            PlaceModel.sharedInstance.placeLatitude = String(coordinates.latitude)
            PlaceModel.sharedInstance.placeLongitude = String(coordinates.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // locationManager.stopUpdatingLocation()
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
//    @objc func saveButtonTapped() {
//
//    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        // Save Pictures to Firebase Store
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("placesMedia")
        
        if let data = PlaceModel.sharedInstance.placeImage.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            let pictureReference = mediaFolder.child("\(uuid).jpeg")
            pictureReference.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    self.showAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    pictureReference.downloadURL { url, error in
                        if error == nil {
                            let pictureUrl = url?.absoluteString
                            
                            // Save Data to Firebase Firestore
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReference: DocumentReference? = nil
                            
                            let firestoreData = ["pictureUrl":pictureUrl!, "pinnedBy":Auth.auth().currentUser?.email!, "placeName":PlaceModel.sharedInstance.placeName, "placeType":PlaceModel.sharedInstance.placeType, "highlights":PlaceModel.sharedInstance.highlights, "placeLatitude":PlaceModel.sharedInstance.placeLatitude, "placeLongitude":PlaceModel.sharedInstance.placeLongitude, "date":FieldValue.serverTimestamp()] as [String:Any]
                            
                            firestoreReference = firestoreDatabase.collection("Places").addDocument(data: firestoreData, completion: { error in
                                if error != nil {
                                    self.showAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                } else {
//                                    PlaceModel.sharedInstance.placeImage = UIImage(named: "select.png")!
//                                    PlaceModel.sharedInstance.placeName = ""
//                                    PlaceModel.sharedInstance.placeType = ""
//                                    PlaceModel.sharedInstance.highlights = ""
                                    
                                    self.performSegue(withIdentifier: "fromMapVCtoMainPageVC", sender: nil)
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    func showAlert(titleInput: String, messageInput: String) {
        let ac = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        ac.addAction(okButton)
        self.present(ac, animated: true)
    }
}
