//
//  ViewController.swift
//  GoogleMap
//
//  Created by Futuretek on 17/07/23.
//

import UIKit
import MapKit

class ViewController: UIViewController, UISearchResultsUpdating {
    
    let mapView = MKMapView()
    let searchVC = UISearchController (searchResultsController: ResultsViewController())
    override func viewDidLoad() {
        super.viewDidLoad()
       title = "Maps"
        view.addSubview (mapView)
        navigationItem.searchController = searchVC
        searchVC.searchResultsUpdater = self
        //gfyujhwagfygfeuwygveyfg
    }
    
    override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews ()
        mapView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.size.width,
        height: view.frame.size.height
        - view.safeAreaInsets.top)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,!query.trimmingCharacters(in: .whitespaces).isEmpty,
        let resultVc = searchController.searchResultsController as? ResultsViewController else{
            return
        }
        resultVc.delegate = self
        
        
        GooglePlacedManager.shared.findPlaces(query: query) {result in
            switch result{
            case.success(let places):
                print("find result")
                DispatchQueue.main.async {
                    resultVc.update(with:places)
                }
                
               
            case.failure(let error):
                print(error)
                
            }
            
        }
    }

}
extension ViewController: ResultsViewControllerDelegate{
    func didTapPlace (with coordinates: CLLocationCoordinate2D) {
        searchVC.searchBar.resignFirstResponder()
        searchVC.dismiss (animated: true, completion: nil)
        let annotations = mapView.annotations
        mapView.removeAnnotations (annotations)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        mapView.addAnnotation (pin)
        mapView.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)),animated: true
        )
    
    }
    
}

