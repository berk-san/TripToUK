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
    var filteredNames = [String]()
    
    @IBOutlet var searchBar: UISearchBar!
    var chosenPlaceID = ""
    var chosenPlaceName = ""
    var chosenPlaceType = ""
    var chosenHighlights = ""
    var chosenPicture = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
//    lazy var searchBar: UISearchBar = UISearchBar()
//    var searchPlace = [String]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Add Place", style: .plain, target: self, action: #selector(addNewPlaceTapped))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutTapped))

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirebase()
        
//        searchBar.searchBarStyle = UISearchBar.Style.default
//        searchBar.placeholder = "Search...."
//        searchBar.sizeToFit()
//        searchBar.isTranslucent = false
        searchBar.delegate = self
//        navigationItem.titleView = searchBar
        
        filteredNames = placeNameArray
        
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
                    
                    if let placeLatitude = document.get("placeLatitude") as? String {
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
//        return filteredNames.count
        if searching {
            return filteredNames.count
        } else {
            return placeIDArray.count
        }
//        return placeIDArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        
//        content.text = filteredNames[indexPath.row]
        
        if searching {
            content.text = filteredNames[indexPath.row]
        } else {
            content.text = placeNameArray[indexPath.row]
        }
//        content.text = placeNameArray[indexPath.row]
        content.secondaryText = "Added by: \(userArray[indexPath.row])"
        content.image = UIImage(named: "select.png")
//        content.image?.draw(in: CGRect(x: 2, y: 2, width: 2, height: 2))
        content.imageProperties.maximumSize = CGSize(width: 100, height: 100)
        
        if let url = URL(string: pictureArray[indexPath.row]) {
            if let data = try? Data(contentsOf: url) {
                if let newImage = UIImage(data: data) {
                    content.image = newImage
                }
            }
        }
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { contextualAction, view, boolValue in
            
            self.chosenPlaceName = self.placeNameArray[indexPath.row]
            self.chosenPlaceType = self.placeTypeArray[indexPath.row]
            self.chosenHighlights = self.highlightsArray[indexPath.row]
            self.chosenPicture = self.pictureArray[indexPath.row]
            self.chosenLatitude = self.latitudeArray[indexPath.row]
            self.chosenLongitude = self.longitudeArray[indexPath.row]
            
            self.performSegue(withIdentifier: "editSegue", sender: nil)
            print("Edit \(self.placeNameArray[indexPath.row])")
        }
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { contextualAction, view, boolValue in
            
            Firestore.firestore().collection("Places").document(self.placeIDArray[indexPath.row]).delete { error in
                if error != nil {
                    print(error?.localizedDescription ?? "Error")
                } else {
                    self.tableView.reloadData()
                }
            }
            
//            self.deleteAlert()
//            print("Delete \(self.placeIDArray[indexPath.row])")
            
            // Add alert
            
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
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
        
        if segue.identifier == "editSegue" {
            let destinationVC = segue.destination as! AddPlaceVC
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

extension MainPageVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredNames = []
        
        if searchText == "" {
            filteredNames = placeNameArray
        }
        
        for word in placeNameArray {
            if word.lowercased().contains(searchText.lowercased()) {
                filteredNames.append(word)
            }
        }
        searching = true
        self.tableView.reloadData()
//        searchPlace = placeNameArray.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
//        searching = true
//        tableView.reloadData()
    }
    
    
//    func deleteAlert() {
//
//        let ac = UIAlertController(title: "Warning", message: "Do you want to delete this place?", preferredStyle: .alert)
//        let yesButton = UIAlertAction(title: "Yes", style: .destructive) { action in
//
//
//            Firestore.firestore().collection("Places"). document(PlaceModel.sharedInstance.idArray[indexpath.row]).delete { error in
//                if error != nil {
//                    print(error?.localizedDescription ?? "Error")
//                } else {
//                    self.tableView.reloadData()
//                }
//
//            }
//
//        }
//        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { action in
//            self.tableView.reloadData()
//        }
//
//        ac.addAction(yesButton)
//        ac.addAction(cancelButton)
//        present(ac, animated: true)
//
//
////            placeIDArray[indexpath.row].ref?.removeValue()
//
////            self.tableView.beginUpdates()
////            self.
////            placeIDArray.remove(at: indexpath.row)
////            tableView.deleteRows(at: [IndexPath]., with: .automatic)
//
//    }
    
            
            

    
}
