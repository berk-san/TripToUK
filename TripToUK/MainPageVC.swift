//
//  MainPageVC.swift
//  TripToUK
//
//  Created by Berk on 1.11.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SDWebImage
import CoreLocation
import MapKit

class MainPageVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var placeNameArray = [String]()
    var placeIDArray = [String]()
    var userArray = [String]()
    var pictureArray = [String]()
    var placeTypeArray = [String]()
    var highlightsArray = [String]()
    var latitudeArray = [Double]()
    var longitudeArray = [Double]()
    
    var chosenPlaceID = ""
    var chosenPlaceName = ""
    var chosenPlaceType = ""
    var chosenHighlights = ""
    var chosenPicture = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Add Place", style: .plain, target: self, action: #selector(addNewPlaceTapped))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutTapped))

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirebase()
        
    }
    
    func getDataFromFirebase() {
        
        let firestoreDatabe = Firestore.firestore()
        firestoreDatabe.collection("Places").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription ?? "Error")
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    self.placeIDArray.removeAll(keepingCapacity: false)
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    self.userArray.removeAll(keepingCapacity: false)
                    self.pictureArray.removeAll(keepingCapacity: false)
                    self.placeTypeArray.removeAll(keepingCapacity: false)
                    self.highlightsArray.removeAll(keepingCapacity: false)
                    self.latitudeArray.removeAll(keepingCapacity: false)
                    self.longitudeArray.removeAll(keepingCapacity: false)
                }
                
                for document in snapshot!.documents {
                    
                    // OBJECTS
                    let placeID = document.documentID
                    self.placeIDArray.append(placeID)
                    
                    if let placeName = document.get("placeName") as? String {
                        self.placeNameArray.append(placeName)
                    }
                    
                    if let user = document.get("pinnedBy") as? String {
                        self.userArray.append(user)
                    }
                    
                    if let pictureUrl = document.get("pictureUrl") as? String {
                        self.pictureArray.append(pictureUrl)
                    }
                    
                    if let placeType = document.get("placeType") as? String {
                        self.placeTypeArray.append(placeType)
                    }
                    
                    if let highlights = document.get("highlights") as? String {
                        self.highlightsArray.append(highlights)
                    }
                    
                    if let placeLatitude = document.get("placeLatitude ") as? String {
                        if let placeLatitudeDouble = Double(placeLatitude) {
                            self.latitudeArray.append(placeLatitudeDouble)
                        }
                    }
                    
                    if let placeLongitude = document.get("placeLongitude") as? String {
                        if let placeLongitudeDouble = Double(placeLongitude) {
                            self.longitudeArray.append(placeLongitudeDouble)
                        }
                    }
                }
                self.tableView.reloadData()
                print(1111)
                print(self.latitudeArray)
                print(4444)
                
                print("AAAA")
                print(self.longitudeArray)
                print("BBBB")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeIDArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = placeNameArray[indexPath.row]
        content.secondaryText = "Added by: \(userArray[indexPath.row])"
        content.image = UIImage(named: "select.png")
        content.imageProperties.cornerRadius = 10
        content.imageToTextPadding = 20
        content.prefersSideBySideTextAndSecondaryText = false
        content.textToSecondaryTextVerticalPadding = 6
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }

    @objc func addNewPlaceTapped() {
        performSegue(withIdentifier: "toNewPlaceVC", sender: nil)
        
    }
    
    @objc func logOutTapped() {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "logOut", sender: nil)
        } catch {
            print("Error")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.selectedPlaceID = chosenPlaceID
            destinationVC.selectedPlaceName = chosenPlaceName
            destinationVC.selectedPlaceType = chosenPlaceType
            destinationVC.selectedHighlights = chosenHighlights
            destinationVC.selectedPicture = chosenPicture
            destinationVC.selectedLatitude = chosenLatitude
            destinationVC.selectedLongitude = chosenLongitude
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenPlaceID = placeIDArray[indexPath.row]
        chosenPlaceName = placeNameArray[indexPath.row]
        chosenPlaceType = placeTypeArray[indexPath.row]
        chosenHighlights = highlightsArray[indexPath.row]
        chosenPicture = pictureArray[indexPath.row]
        chosenLatitude = latitudeArray[indexPath.row]
        chosenLongitude = longitudeArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }

}
