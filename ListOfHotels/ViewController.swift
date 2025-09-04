//
//  ViewController.swift
//  ListOfHotels
//
//  Created by Yerzhan Parimbay on 02.09.2025.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageHotel: UIImageView!
    @IBOutlet weak var nameHotel: UILabel!
    @IBOutlet weak var addressHotel: UILabel!
    
    
    @IBOutlet weak var mapButton: MKMapView!
    
    var hotelCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var hotel = Hotel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imageHotel.image = UIImage(named: hotel.image)
        nameHotel.text = hotel.name
        addressHotel.text = hotel.address
        hotelCoordinate = hotel.hotelCoordinate
        
        setupMiniMap()
    }
    
    func setupMiniMap() {
            // Убираем старые метки, если они были
            mapButton.removeAnnotations(mapButton.annotations)
            
            // Создаем аннотацию (метку)
            let annotation = MKPointAnnotation()
            annotation.coordinate = hotelCoordinate
            annotation.title = hotel.name
            annotation.subtitle = hotel.address
            
            // Добавляем на карту
            mapButton.addAnnotation(annotation)
            
            // Приближаем карту к отелю
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: hotelCoordinate, span: span)
            mapButton.setRegion(region, animated: true)
        }
    

    @IBAction func openMap(_ sender: Any) {
        // Загружаем MapViewController из storyboard
           if let mapVC = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController {
               mapVC.hotel = hotel   // передаём данные
               navigationController?.pushViewController(mapVC, animated: true)
           }
    }
    
    
    
    

}

