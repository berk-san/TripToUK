//
//  MainPageVC.swift
//  TripToUK
//
//  Created by Berk on 1.11.2022.
//

import UIKit
import FirebaseAuth

class MainPageVC: UIViewController {

    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "New Place", style: .plain, target: self, action: #selector(addNewPlaceTapped))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutTapped))

        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
