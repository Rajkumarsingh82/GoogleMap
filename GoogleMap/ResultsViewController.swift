  //
//  ResultsViewController.swift
//  GoogleMap
//
//  Created by Futuretek on 17/07/23.
//

import UIKit
import CoreLocation

protocol ResultsViewControllerDelegate: AnyObject {
func didTapPlace (with coordinates: CLLocationCoordinate2D)
    
}

class ResultsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    weak var delegate: ResultsViewControllerDelegate?
    private let tableView:UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    private var places:[place] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        view.backgroundColor = .clear
        tableView.dataSource = self
       // view.backgroundColor = .systemBlue
    }
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    public func update(with places:[place]){
        self.tableView.isHidden = false
        self.places = places
        print(places.count) 
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.isHidden = true
        let place = places[indexPath.row]
        GooglePlacedManager.shared.resolvedLocation(for: place) { [weak self] result in
            switch result{
            case.success(let coordinate):
                DispatchQueue.main.async{
                    self?.delegate?.didTapPlace (with: coordinate)
                }
            case.failure(let error):
                print(error)
                
            }
        }
    }
     
    


}
