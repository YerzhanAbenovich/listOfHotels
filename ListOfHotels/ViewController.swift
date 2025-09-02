//
//  ViewController.swift
//  ListOfHotels
//
//  Created by Yerzhan Parimbay on 02.09.2025.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageHotel: UIImageView!
    @IBOutlet weak var nameHotel: UILabel!
    @IBOutlet weak var addressHotel: UILabel!
    
    var hotel = Hotel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imageHotel.image = UIImage(named: hotel.image)
        nameHotel.text = hotel.name
        addressHotel.text = hotel.address
    }


}

