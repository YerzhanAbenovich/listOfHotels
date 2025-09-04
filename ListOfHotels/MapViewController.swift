//
//  MapViewController.swift
//  ListOfHotels
//
//  Created by Yerzhan Parimbay on 03.09.2025.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapview: MKMapView!
    
    let locationManager = CLLocationManager()
    var userLocation = CLLocation()
    var followMe = false
    
    var hotel: Hotel? //Принимаем отель
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Запрашиваем разрешение на использование местоположения пользователя
        locationManager.requestWhenInUseAuthorization()
        
        // delegate нужен для функции didUpdateLocations, которая вызывается при обновлении местоположения (для этого прописали CLLocationManagerDelegate выше)
        locationManager.delegate = self
        
        // Запускаем слежку за пользователем
        locationManager.startUpdatingLocation()
        
        // Настраиваем отслеживания жестов - когда двигается карта вызывается didDragMap
        let mapDragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.didDragMap))
        
        // UIGestureRecognizerDelegate - чтоб мы могли слушать нажатия пользователя по экрану и отслеживать конкретные жесты
        mapDragRecognizer.delegate = self
        
        // Добавляем наши настройки жестов на карту
        mapview.addGestureRecognizer(mapDragRecognizer)
        
        mapview.delegate = self
        mapview.showsUserLocation = true
        
        let anotation = MKPointAnnotation()
        
        // Задаем коортинаты метке
        anotation.coordinate = hotel.hotelCoordinate
        // Задаем название метке
        anotation.title = hotel.name
        // Задаем описание метке
        anotation.subtitle = hotel.address
        
        // Добавляем метку на карту
        mapview.addAnnotation(anotation)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        userLocation = locations[0]
        
        print(userLocation)
        
        // Дельта - насколько отдалиться от координат пользователя по долготе и широте
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01
        
        // Создаем область шириной и высотой по дельте
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        // Создаем регион на карте с моими координатоми в центре
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
        
        // Приближаем карту с анимацией в данный регион
        mapview.setRegion(region, animated: true)
    }
    
    @objc func didDragMap(gestureRecognizer: UIGestureRecognizer) {
        // Как только начали двигать карту
        if (gestureRecognizer.state == UIGestureRecognizer.State.changed) {
            
            // Говорим не следовать за пользователем
            followMe = false
            
            print("Map drag changed")
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation else { return }
        
        // 1. Начальная точка (пользователь)
        let sourceLocation = CLLocationCoordinate2D(
            latitude: userLocation.coordinate.latitude,
            longitude: userLocation.coordinate.longitude
        )
        
        // 2. Конечная точка (отель)
        let destinationLocation = annotation.coordinate
        
        // 3. Упаковка в Placemark
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation)
        
        // 4. Упаковка в MapItem
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // 5. Запрос на построение маршрута
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // 6. Построение маршрута
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            if let error = error {
                print("Ошибка при построении маршрута: \(error.localizedDescription)")
                return
            }
            
            guard let response = response, let route = response.routes.first else {
                print("Маршрут не найден")
                return
            }
            
            // Убираем старые маршруты (чтобы не дублировались)
            self.mapview.removeOverlays(self.mapview.overlays)
            
            // Добавляем новый маршрут
            self.mapview.addOverlay(route.polyline, level: .aboveRoads)
            
            // Масштабируем карту под весь маршрут
            self.mapview.setVisibleMapRect(
                route.polyline.boundingMapRect,
                edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50),
                animated: true
            )
        }
    
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Настраиваем линию
        let renderer = MKPolylineRenderer(overlay: overlay)
        // Цвет красный
        renderer.strokeColor = UIColor.red
        // Ширина линии
        renderer.lineWidth = 2.0
        
        return renderer
    }
    
}
