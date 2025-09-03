//
//  TableViewController.swift
//  ListOfHotels
//
//  Created by Yerzhan Parimbay on 02.09.2025.
//

import UIKit
import CoreLocation

class TableViewController: UITableViewController, CLLocationManagerDelegate {
    
    var hotelArray = [Hotel(name: "SureStay Plus by Best Western Santa Clara Silicon Valley", address: "859 El Camino Real, Santa Clara, CA 95050", image: "SureStay", coordinate: CLLocationCoordinate2D(latitude: 37.355468, longitude: -121.945257)),
                      Hotel(name: "AC Hotel San Jose Sunnyvale Cupertino", address: "597 East El Camino Real, Sunnyvale, CA 94087", image: "AC Hotel", coordinate: CLLocationCoordinate2DMake(37.362515, -122.025110)),
                      Hotel(name: "Ramada by Wyndham Sunnyvale/Silicon Valley", address: "1217 Wildwood Ave, Sunnyvale, CA, 94089", image: "Ramada", coordinate: CLLocationCoordinate2DMake(37.390947, -121.992788))]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return hotelArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        
        let hotelName = cell.viewWithTag(1002) as! UILabel
        hotelName.text = hotelArray[indexPath.row].name
        
        let address = cell.viewWithTag(1003) as! UILabel
        address.text = hotelArray[indexPath.row].address
        
        let image = cell.viewWithTag(1001) as! UIImageView
        image.image = UIImage(named: hotelArray[indexPath.row].image)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! ViewController
        
        vc.hotel = hotelArray[indexPath.row]
        
        navigationController?.show(vc, sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
