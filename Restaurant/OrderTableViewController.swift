//
//  OrderTableViewController.swift
//  Restaurant
//
//  Created by Denis Bystruev on 05/06/2018.
//  Copyright © 2018 Denis Bystruev. All rights reserved.
//
//  View controller for the order list

import UIKit

class OrderTableViewController: UITableViewController, AddToOrderDelegate {
    
    /// The list of ordered items
    var menuItems = [MenuItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // display an Edit button in the navigation bar for this view controller.
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // fit the detail (price) labels
        fitDetailLabels()
    }
    
    override func viewWillLayoutSubviews() {
        // fit the detail (price) labels
        fitDetailLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // the number of rows is equal to the number of items in menuItems array
        return menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // reuse the order list prototype cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCellIdentifier", for: indexPath)
        
        // configure the cell with menu list data
        configure(cell: cell, forItemAt: indexPath)

        return cell
    }
    
    /// Configure the cell with order list data
    /// - parameters:
    ///     - cell: The cell to be configured
    ///     - indexPath: An index path locating a row in tableView
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        // get the needed menu item for corresponding table row
        let menuItem = menuItems[indexPath.row]
        
        // the left label of the cell should display the name of the item
        cell.textLabel?.text = menuItem.name
        
        // the right label displays the price along with currency symbol
        cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price)
    }

    // Confirm which items (all) support editing (deleting menu items) of the order table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // All items are editable (deletable)
        return true
    }

    // Support editing the order table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the item from the order list
            menuItems.remove(at: indexPath.row)
            
            // Remove the row from the table
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Update the number of items on the badge
            updateBadgeNumber()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // fit the detail (price) label in cell
        fitDetailLabel(in: cell)
    }

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
    
    /// Called when menu item is added
    func added(menuItem: MenuItem) {
        // append the menu item to the menuItems array
        menuItems.append(menuItem)
        
        // get the total number of menu items
        let count = menuItems.count
        
        // calculate index path for the last row
        let indexPath = IndexPath(row: count - 1, section: 0)
        
        // insert the menu item row to the end of the order table
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        // update the badge with the number of items in the order
        updateBadgeNumber()
    }
    
    /// Update the badge value of the order tab to match the number of items in the order
    func updateBadgeNumber() {
        // get the number of items in the order
        let badgeValue = 0 < menuItems.count ? "\(menuItems.count)" : nil
        
        // assign the badge value to the order tab
        navigationController?.tabBarItem.badgeValue = badgeValue
    }
}
