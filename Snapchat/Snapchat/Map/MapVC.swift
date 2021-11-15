//
//  MapVC.swift
//  Snapchat
//
//  Created by alanood on 08/04/1443 AH.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseStorage 


class UserAnnotations : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: UIImage?

    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}

class MapScreen: UIViewController {
    
    
    var mapView = MKMapView()
    let locationManager = CLLocationManager()
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var userImage: Data?
    
    var usersLocations: [UserAnnotation] = []
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        
        navigationItem.title = "SnapChat"
        
        readUsersLocationOnDB()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIfUserAuthorizedCLLocationServices()
        
    }
    

    private func setupCLLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    
    private func checkIfUserAuthorizedCLLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupCLLocation()
            handleCLLocationAuthorization()
        }
    }
    private func handleCLLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        
        switch locationManager.authorizationStatus {
        case .restricted, .denied:
            let alert = UIAlertController(title: "Oops", message: "We need you to authorize the app to use you location for the map to function correctly", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    private func setupMap() {
        mapView.delegate = self
        mapView.mapType = .mutedStandard
        mapView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.addSubview(mapView)
    }
    
    private func showUserLocation(withLocation: CLLocation){
        let userCoordinate = CLLocationCoordinate2D(latitude: withLocation.coordinate.latitude, longitude: withLocation.coordinate.longitude)
        let zoomOnMap = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: userCoordinate, span: zoomOnMap)
        mapView.setRegion(region,
                          animated: true)
        
        showPinOnLocation(coordinate: userCoordinate)
    }
    
    private func showPinOnLocation(coordinate: CLLocationCoordinate2D) {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }
    
    
    private func addAnnotation() {
        for userNotation in usersLocations {
            
            let pin = UserAnnotations(coordinate: CLLocationCoordinate2D(latitude: Double(userNotation.location.lat)!, longitude: Double(userNotation.location.long)!), title: userNotation.name, subtitle: userNotation.email)
            
            pin.image = UIImage(data: userNotation.image)
            
            mapView.addAnnotation(pin)
        }
        
    }
}


extension MapScreen: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            locationManager.stopUpdatingLocation()
            saveUserLocationOnDB(userLocation: currentLocation)
            mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
            
           
        }
      
    }
    
}

extension MapScreen: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is UserAnnotations) {
            return nil
        }
        
        let reuseId = "userIDForAnnotationLocation"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        
        
        
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            print("nil in annotation View~~~~~ sad face")
        }else{
            anView?.annotation = annotation
        }
        
        let usersAnnotations = annotation as! UserAnnotations
        
        if usersAnnotations.image != nil {
            let pinImage = usersAnnotations.image!
            let size = CGSize(width: 50, height: 50)
                    UIGraphicsBeginImageContext(size)
                    pinImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            anView?.image = resizedImage
            anView?.canShowCallout = true
            
        }else{
            anView?.image = UIImage(systemName: "person.crop.circle.fill")
        }
        
        return anView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let currentView = view.annotation else {return}
        
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: currentView.coordinate.latitude, longitude: currentView.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(
                    minCenterCoordinateDistance: 3000, // Minimum zoom value
                    maxCenterCoordinateDistance: 1000000)
    }
}

//MARK:- DB Methods

extension MapScreen {
    
    private func saveUserLocationOnDB(userLocation: CLLocation) {
        guard let user = Auth.auth().currentUser else {return}
        do {
            try db.collection("Profiles").document(user.uid).setData(from: Location(long: String(userLocation.coordinate.longitude), lat: String(userLocation.coordinate.latitude)), merge: true) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }catch let err {
            print("something went wrong with saving userLocation \(err)")
        }
    }
    
    
    
    private func readUsersLocationOnDB() {
        
        db
            .collection("Profiles")
            .addSnapshotListener { (querySnapshot, error) in
               
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    
                    if let snapshotDocuments = querySnapshot?.documents {
                        
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            
                            if
                                let imageURL = data["userImageURL"] as? String,
                                let name     = data["name"] as? String,
                                let email    = data["email"] as? String,
                                let location = try? doc.data(as: Location.self)
                            {
                               
                                
                                                                          
                                let httpsReference = self.storage.reference(forURL: imageURL)
                                self.usersLocations.removeAll()
                                httpsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                                  if let error = error {
                                      print("ERROR GETTING DATA \(error.localizedDescription)")
                                  } else {
                                      self.userImage = data!
                                      self.usersLocations.append(UserAnnotation(name: name, email: email, image: self.userImage!, location: location))
                                      self.addAnnotation()
                                     
                                  }
                                }
                                
                            } else {
                                print("error converting data")
                               
                                
                            }
                            
                           
                        }
                    }
                }
            }
        
    }
}




