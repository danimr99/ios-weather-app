//
//  SearchCityViewController.swift
//  WeatherApp
//
//  Created by Daniel Muelle on 20/11/2022.
//

import UIKit
import MapKit

class SearchCityViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var searchCityInput: UITextField!
    
    // MARK: - Properties
    
    var searchRequest = MKLocalSearch.Request()
    var searchCityCallback: (_ location: String) -> Void = {
        arg in
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Methods
    private func showAlert(title: String, message: String) {
        // Create an alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // Add an action button
        alert.addAction(UIAlertAction(title: "Accept", style: UIAlertAction.Style.default, handler: nil))

        // Show alert
        self.present(alert, animated: true, completion: nil)
    }
    
    private func searchLocation(locationQuery: String) {
        var results: [MKMapItem] = []
        
        self.searchRequest.naturalLanguageQuery = locationQuery
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            // Check if an error has occurred
            guard let response = response else {
                self.showAlert(title: "Location not found", message: "No results were found for the location \(locationQuery)")
                return
            }
            
            // Add each result to the list
            for item in response.mapItems {
                results.append(item)
            }
            
            // Get first result from the list of results
            guard let location = results.first else { return }
            
            // Pass result to callback
            self.searchCityCallback(location.placemark.title!)
        }
    }
    
    // MARK: - Handlers
    @IBAction func searchButtonHandler(_ sender: Any) {
        let input = self.searchCityInput.text
        
        if !input!.isEmpty {
            self.searchLocation(locationQuery: input!)
        } else {
            self.showAlert(title: "Incompleted information", message: "Type a city to search")
        }
    }
}
