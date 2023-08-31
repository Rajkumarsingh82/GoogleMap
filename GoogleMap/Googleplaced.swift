//
//  Googleplaced.swift
//  GoogleMap
//
//  Created by Futuretek on 26/07/23.
//

import Foundation
import GooglePlaces
import CoreLocation
struct place {
    let name:String
    let identifier:String
}


final class GooglePlacedManager{
    static let shared = GooglePlacedManager()
    private let client = GMSPlacesClient.shared()
    private init(){}
    
    enum PlacesError:Error{
        case faildToFind
        case faildToGetCoordinate
    }
    
    
    public func findPlaces (query: String, completion: @escaping (Result<[place ], Error>) -> Void){
        let filter = GMSAutocompleteFilter()
        filter.type = .geocode
        client.findAutocompletePredictions ( fromQuery: query, filter: filter, sessionToken: nil
        ) {results, error in
            guard let results = results, error == nil else {
                completion(.failure(PlacesError.faildToFind))
                return
            }
            let places: [place] = results.compactMap({
                place(name:$0.attributedFullText.string, identifier: $0.placeID)
                
            })
            completion(.success(places))
        }
    }
    
    
    
    public func resolvedLocation(for place:place,completion: @escaping(Result<CLLocationCoordinate2D,Error>)->Void)
    {
        client.fetchPlace(fromPlaceID: place.identifier, placeFields: .coordinate, sessionToken: nil)
        { googlePlace, error in
            guard let googlePlace = googlePlace, error == nil else {
                completion( .failure (PlacesError.faildToGetCoordinate))
                return
            }
            let coordinate = CLLocationCoordinate2D(latitude: googlePlace.coordinate.latitude, longitude: googlePlace.coordinate.longitude)
            
            completion(.success(coordinate))
            
        }
    }
    
}






//public func resolvedLocation{
//    for place: place,
//        completion: @escaping(Result<CLLocationCoordinate2D,Error ->Void
//        )
//    {
//        {
//            client.fetchPlace(
//            fromPlaceID: place.identifier,
//            placeFields:.coordinate,
//            sessionToken: nil
//            ) { googlePlace, error in
//                guard let googlePlace = googlePlace, error == nil else {
//
//                    return
//                }
//                let coordinate = CLLocationCoordinate2D(latitude: googlePlace.coordinate.latitude, longitude: googlePlace.coordinate.longitude)
////            }
//            completion(.success(coordinate))
//        }
//    }
//}




