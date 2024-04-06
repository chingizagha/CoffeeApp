//
//  ListTableViewController.swift
//  CoffeeApp
//
//  Created by Chingiz on 01.04.24.
//

import UIKit
import MapKit

class ListTableViewController: UITableViewController {
    
    var userLocation: CLLocation
    var places: [PlaceAnnotation]
    
    private var indexForSelectedRow: Int? {
        self.places.firstIndex(where: { $0.isSelected == true})
    }
    
    init(userLocation: CLLocation, places: [PlaceAnnotation]) {
        self.userLocation = userLocation
        self.places = places
        super.init(nibName: nil, bundle: nil)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.places.swapAt(indexForSelectedRow ?? 0, 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func calculateDistance(from: CLLocation, to: CLLocation) -> CLLocationDistance{
        from.distance(from: to)
    }
    
    private func formatDistanceForDisplay(distance: CLLocationDistance) -> String{
        let meters = Measurement(value: distance, unit: UnitLength.meters)
        return meters.converted(to: .meters).formatted()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let place = places[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = place.name
        content.secondaryText = formatDistanceForDisplay(distance: calculateDistance(from: userLocation, to: place.location))
        
        cell.contentConfiguration = content
        cell.backgroundColor = place.isSelected ? .lightGray : .clear
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let place = places[indexPath.row]
        let detailVC = DetailViewController(place: place)
        
        detailVC.modalPresentationStyle = .pageSheet
        
        if let sheet = detailVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium()]
            present(detailVC, animated: true)
        }
        
    }


}
