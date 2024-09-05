//
//  LocationViewController.swift
//  COP
//
//  Created by Mac on 25/07/24.
//

import UIKit
import MapKit
import Alamofire

class LocationViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var MapView: MKMapView!
    
    var phoneNumber : String?
    var locationData: LocationOfUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MapView.delegate = self
        checkLocation()
    }
    
    func checkLocation(){
        if let locationData = locationData {
                   showLocationOnMap(locationData: locationData)
        }else{
            print("No Location data available!")
        }
    }
    
//    func checkPhoneNumber(){
//        if let phoneNumber = phoneNumber {
//                   fetchUserLocation(phoneNumber: phoneNumber)
//        } else{
//            print("No Location data available!")
//        }
//    }
    
//    
//    func fetchUserLocation(phoneNumber: String) {
//        
//    let url = "\(ApiKeys.baseURL)/users-location"
//         let parameters: [String: Any] = ["phoneNumber": phoneNumber]
//        showLoadingView(mapview: MapView)
//         
//         AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
//             
//             self.dismissLoadingView()
//             switch response.result {
//             case .success(let data):
//                 self.decodeLocationData(data)
//             case .failure(let error):
//                 print("Error fetching user location: \(error)")
//                 // Handle error, show alert, etc.
//             }
//         }
//     }
     
     func decodeLocationData(_ data: Data) {
         do {
             let location = try JSONDecoder().decode(LocationOfUser.self, from: data)
             self.showLocationOnMap(locationData: location)
         } catch {
             print("Failed to decode location data: \(error)")
         }
     }
     
     func showLocationOnMap(locationData: LocationOfUser) {
         let coordinate = CLLocationCoordinate2D(latitude: locationData.latitude, longitude: locationData.longitude)
         
         if CLLocationCoordinate2DIsValid(coordinate) {
             let annotation = MKPointAnnotation()
             annotation.coordinate = coordinate
             annotation.title = "User Location"
             MapView.addAnnotation(annotation)
             
             let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
             MapView.setRegion(region, animated: true)
         } else {
             print("Invalid coordinates: \(coordinate)")
         }
     }
     
     func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
         let identifier = "UserLocation"
         
         if annotation is MKPointAnnotation {
             var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
             
             if annotationView == nil {
                 annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                 annotationView?.canShowCallout = true
             } else {
                 annotationView?.annotation = annotation
             }
             
             return annotationView
         }
         
         return nil
     }
    
    }
    

