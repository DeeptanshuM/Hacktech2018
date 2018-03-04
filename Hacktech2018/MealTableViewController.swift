//
//  MealTableViewController.swift
//  Hacktech2018
//
//  Created by Ram Goli on 3/4/18.
//  Copyright © 2018 Deeptanshu. All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController {
  
    var meals = [Meal]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMeals()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MealTableViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }

        // Configure the cell...
        let meal = meals[indexPath.row]
        cell.nameLabel?.text = meal.name

        return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToCamera", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! ARViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationViewController.sceneName = meals[indexPath.row].name
          
          //////
          //Sending get requets to server
            
          let query = meals[indexPath.row].name.replacingOccurrences(of: " ", with: "_")
          let url = URL(string: "http://1917a9e6.ngrok.io/foodtype?food=" + query)
          
          var request = URLRequest(url: url!)
          
          let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
              print(error!)
              return
            }
          }
          
          //////
          
        }
    }
    
    func loadMeals() {
        guard let chicken = Meal(name: "Chicken") else {
            fatalError("could not create a chicken!")
        }
        
        guard let bagel = Meal(name: "Bagel") else {
            fatalError("could not create a bagel")
        }
        
        guard let fruitBar = Meal(name: "Fruit Bar") else {
            fatalError("could not create a fruitbar")
        }
        
        guard let dessert = Meal(name: "Dessert") else {
            fatalError("could not create a cookie")
        }
        
        meals += [chicken, bagel, fruitBar, dessert]
    }
    
}
