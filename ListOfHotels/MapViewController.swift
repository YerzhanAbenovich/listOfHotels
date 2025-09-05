//
//  MapViewController.swift
//  ListOfHotels
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapview: MKMapView!
    
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    var hotel: Hotel?   // Отель, который передаем из предыдущего VC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapview.delegate = self
        mapview.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Ставим пин на отель
        if let hotel = hotel {
            let annotation = MKPointAnnotation()
            annotation.coordinate = hotel.hotelCoordinate
            annotation.title = hotel.name
            annotation.subtitle = hotel.address
            mapview.addAnnotation(annotation)
        }
    }
    
    // Когда обновились координаты пользователя
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.first
        
        // Как только получили userLocation и знаем координаты отеля — строим маршрут
        if let hotel = hotel {
            buildRoute(to: hotel.hotelCoordinate)
        }
    }
    
    // Метод для построения маршрута
    func buildRoute(to destination: CLLocationCoordinate2D) {
        guard let userLocation = userLocation else { return }
        
        let sourcePlacemark = MKPlacemark(coordinate: userLocation.coordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: sourcePlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            if let error = error {
                print("Ошибка маршрута: \(error.localizedDescription)")
                return
            }
            
            guard let route = response?.routes.first else { return }
            
            self?.mapview.removeOverlays(self?.mapview.overlays ?? [])
            self?.mapview.addOverlay(route.polyline, level: .aboveRoads)
            
            self?.mapview.setVisibleMapRect(
                route.polyline.boundingMapRect,
                edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50),
                animated: true
            )
        }
    }
    
    // Отрисовка линии маршрута
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .red
        renderer.lineWidth = 3
        return renderer
    }
}
