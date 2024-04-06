//
//  ViewController.swift
//  CoffeeApp
//
//  Created by Chingiz on 01.04.24.
//

import UIKit
import MapKit

class MainViewController: UIViewController {
    
    var locationManager: CLLocationManager?
    private var places: [PlaceAnnotation] = []
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    lazy var searchTextField: UITextField = {
        let tf = UITextField()
        tf.layer.cornerRadius = 10
        tf.clipsToBounds = true
        tf.backgroundColor = .systemBackground
        tf.returnKeyType = .go
        tf.placeholder = "Search"
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        tf.leftViewMode = .always
        tf.delegate = self
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
        mapView.showsCompass = false
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
        
        layoutUI()
    }
    
    
    private func layoutUI(){
        
        view.addSubviews(mapView, searchTextField)
        view.bringSubviewToFront(searchTextField)
        
        NSLayoutConstraint.activate([
            mapView.widthAnchor.constraint(equalTo: view.widthAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor),
            mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTextField.widthAnchor.constraint(equalToConstant: view.bounds.size.width/1.3),
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 60)
        ])
    }
    
    private func checkLocationAuthorization(){
        guard let locationManager = locationManager,
              let location = locationManager.location else {return}
        
        switch locationManager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 7500, longitudinalMeters: 7500)
                mapView.setRegion(region, animated: true)
            case .denied:
                print("")
            case .notDetermined, .restricted:
                print("")
            default:
                print("")
        }
    }
    
    private func presentListVC(places: [PlaceAnnotation]){
        
        guard let locationManager = locationManager,
              let userLocation = locationManager.location else {return}
        
        let vc = ListTableViewController(userLocation: userLocation, places: places)
        vc.modalPresentationStyle = .pageSheet
        
        if let sheet = vc.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            present(vc, animated: true)
        }
    }

    
    private func findNearbyPlaces(by query: String){
        mapView.removeAnnotations(mapView.annotations)
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let self else {return}
            guard let response = response, error == nil else {return}
            
            self.places = response.mapItems.map(PlaceAnnotation.init)
            self.places.forEach{ place in
                self.mapView.addAnnotation(place)
            }
            
            if !places.isEmpty {
                presentListVC(places: places)
            }
            
        }
    }
    
    }

extension MainViewController: CLLocationManagerDelegate {
 
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

extension MainViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text ?? ""
        if !text.isEmpty {
            textField.resignFirstResponder()
            findNearbyPlaces(by: text)
        }
        return true
    }
}

extension MainViewController: MKMapViewDelegate {
    
    private func clearAllSelections(){
        self.places = self.places.map({ place in
            place.isSelected = false
            return place
        })
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        
        clearAllSelections()
        
        guard let selectedAnnotation =  annotation as? PlaceAnnotation else {return}
        
        let placeAnnotation = self.places.first(where: { $0.id == selectedAnnotation.id})
        placeAnnotation?.isSelected = true
        
        presentListVC(places: self.places)
    }
}
