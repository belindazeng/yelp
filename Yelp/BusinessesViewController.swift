//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FiltersViewControllerDelegate {
    
    var businesses: [Business]!
    var allBusiness: [Business]!
    var searchBar: UISearchBar?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        // for the scrollbar
        tableView.estimatedRowHeight = 120
        
        Business.searchWithTerm(term: "Restaurants", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.allBusiness = businesses
            self.businesses = businesses
            self.tableView.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            
            }
        )
        
        // create the search bar programatically since you won't be
        // able to drag one onto the navigation bar
        searchBar = UISearchBar()
        searchBar?.sizeToFit()
        searchBar?.delegate = self
        
        // the UIViewController comes with a navigationItem property
        // this will automatically be initialized for you if when the
        // view controller is added to a navigation controller's stack
        // you just need to set the titleView to be the search bar
        navigationItem.titleView = searchBar
        
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
        
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        let categories = filters["categories"] as? [String]
        let deals = filters["deals"] as? Bool
        let distance = filters["distance"] as? String
        print("distance: \(distance)")
        
        let sortIndexString = filters["sort"] as? String
        let sortIndex = Int(sortIndexString ?? "0") ?? 0
        let sortModes = [YelpSortMode.bestMatched, YelpSortMode.distance, YelpSortMode.highestRated]
        let sort = sortModes[sortIndex]
        
        print("sort: \(sort)")
        
        Business.searchWithTerm(term: "Restaurants", sort: sort, categories: categories, deals: deals, distance: distance, completion: {
            (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as! BusinessCell
        cell.business = businesses[indexPath.row]
        return cell
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        businesses = searchText.isEmpty ? allBusiness : allBusiness.filter({(business: Business) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return business.name?.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar?.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        businesses = allBusiness
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
