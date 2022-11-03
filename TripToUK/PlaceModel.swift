//
//  PlaceModel.swift
//  TripToUK
//
//  Created by Berk on 1.11.2022.
//

import Foundation
import UIKit

class PlaceModel {
    static let sharedInstance = PlaceModel()
    
    var placeName = ""
    var placeType = ""
    var highlights = ""
    var placeImage = UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
    
    private init() {} 
}
