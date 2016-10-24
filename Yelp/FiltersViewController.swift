//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Belinda Zeng on 10/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters:[String:AnyObject])
    
}


class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate{
    // section headers
    
    let NUM_SECTIONS = 4
    var dealSwitchState = Bool()
    var distanceSwitchState = 0
    var sortSwitchState = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var categories: [[String:String]]!
    var sort: [[String:String]]!
    var distances: [[String:String]]!
    var switchStates = [Int:Bool]()
    weak var delegate : FiltersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        categories = yelpCategories()
        sort = yelpSort()
        distances = yelpDistance()
        tableView.delegate = self
        tableView.dataSource = self
        print(tableView.numberOfSections)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0: return "Offering a Deal"
            case 1: return "Distance"
            case 2: return "Sort By"
            case 3: return "Category"
            default: return " "
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return NUM_SECTIONS
    }

    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onSearchButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        var filters = [String: AnyObject]()
        
        var selectedCategories = [String]()
        for (row, isSelected) in switchStates {
            if isSelected {
                let category_code = categories[row]["code"]
                selectedCategories.append(category_code!)
            }
        }
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject
        }
        if dealSwitchState {
            filters["deals"] = dealSwitchState as AnyObject
        }
        if distanceSwitchState > 0 {
            filters["distance"] = distances[distanceSwitchState]["code"] as AnyObject
        }
        if sortSwitchState > 0 {
            filters["sort"] = sort[sortSwitchState]["code"] as AnyObject
        }
        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0: return 1
            case 1: return distances.count
            case 2: return sort.count
            case 3: return categories.count
            default: return  0
        }
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            // offering a deal
        case 0:
           let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchCell
           cell.switchLabel.text = "Offering a Deal"
           cell.delegate = self
           cell.onSwitch.isOn = dealSwitchState 
           return cell
        // sort by
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchCell
            cell.switchLabel.text = distances[indexPath.row]["name"]
            cell.delegate = self
            // make sure only one is selected
            if indexPath.row == distanceSwitchState {
                cell.onSwitch.isOn = true
            }
            else {
                cell.onSwitch.isOn = false
            }
            return cell
        // distance
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchCell
            cell.delegate = self
            if indexPath.row == sortSwitchState {
                cell.onSwitch.isOn = true
            }
            else {
                cell.onSwitch.isOn = false
            }
            cell.switchLabel.text = sort[indexPath.row]["name"]
            return cell
        // category
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchCell
            cell.delegate = self
            cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
            cell.switchLabel.text = categories[indexPath.row]["name"]
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchCell
            return cell
        }

    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        switch indexPath.section {
            case 0:
                dealSwitchState = value
            case 1:
                distanceSwitchState = indexPath.row
                tableView.reloadData()
                print("switch-distance\(distanceSwitchState)")
            case 2:
                sortSwitchState = indexPath.row
                tableView.reloadData()
                print("switch-sort\(sortSwitchState)")
            case 3:
                switchStates[indexPath.row] = value
            default:
                print("default")
            
        }
        
        
    }
    
    func yelpSort() -> [[String:String]] {

        return [["name" : "Best matched", "code": "0"],
                ["name" : "Distance", "code": "1"],
                ["name" : "Highest Rated", "code": "2"]]
    }
    
    func yelpDistance() -> [[String:String]] {
        return [["name" : "Auto", "code": "0"],
                ["name" : ".3 miles", "code": "1"],
                ["name" : "1 miles", "code": "2"],
                ["name" : "5 miles", "code": "3"],
                ["name" : "10 miles", "code": "4"]
        ]
    }
    func yelpCategories() -> [[String:String]] {
        return [["name" : "Afghan", "code": "afghani"],
                ["name" : "African", "code": "african"],
                ["name" : "American, New", "code": "newamerican"],
                ["name" : "American, Traditional", "code": "tradamerican"],
                ["name" : "Arabian", "code": "arabian"],
                ["name" : "Argentine", "code": "argentine"],
                ["name" : "Armenian", "code": "armenian"],
                ["name" : "Asian Fusion", "code": "asianfusion"],
                ["name" : "Asturian", "code": "asturian"],
                ["name" : "Australian", "code": "australian"],
                ["name" : "Austrian", "code": "austrian"],
                ["name" : "Baguettes", "code": "baguettes"],
                ["name" : "Bangladeshi", "code": "bangladeshi"],
                ["name" : "Barbeque", "code": "bbq"],
                ["name" : "Basque", "code": "basque"],
                ["name" : "Bavarian", "code": "bavarian"],
                ["name" : "Beer Garden", "code": "beergarden"],
                ["name" : "Beer Hall", "code": "beerhall"],
                ["name" : "Beisl", "code": "beisl"],
                ["name" : "Belgian", "code": "belgian"],
                ["name" : "Bistros", "code": "bistros"],
                ["name" : "Black Sea", "code": "blacksea"],
                ["name" : "Brasseries", "code": "brasseries"],
                ["name" : "Brazilian", "code": "brazilian"],
                ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
                ["name" : "British", "code": "british"],
                ["name" : "Buffets", "code": "buffets"],
                ["name" : "Bulgarian", "code": "bulgarian"],
                ["name" : "Burgers", "code": "burgers"],
                ["name" : "Burmese", "code": "burmese"],
                ["name" : "Cafes", "code": "cafes"],
                ["name" : "Cafeteria", "code": "cafeteria"],
                ["name" : "Cajun/Creole", "code": "cajun"],
                ["name" : "Cambodian", "code": "cambodian"],
                ["name" : "Canadian", "code": "New)"],
                ["name" : "Canteen", "code": "canteen"],
                ["name" : "Caribbean", "code": "caribbean"],
                ["name" : "Catalan", "code": "catalan"],
                ["name" : "Chech", "code": "chech"],
                ["name" : "Cheesesteaks", "code": "cheesesteaks"],
                ["name" : "Chicken Shop", "code": "chickenshop"],
                ["name" : "Chicken Wings", "code": "chicken_wings"],
                ["name" : "Chilean", "code": "chilean"],
                ["name" : "Chinese", "code": "chinese"],
                ["name" : "Comfort Food", "code": "comfortfood"],
                ["name" : "Corsican", "code": "corsican"],
                ["name" : "Creperies", "code": "creperies"],
                ["name" : "Cuban", "code": "cuban"],
                ["name" : "Curry Sausage", "code": "currysausage"],
                ["name" : "Cypriot", "code": "cypriot"],
                ["name" : "Czech", "code": "czech"],
                ["name" : "Czech/Slovakian", "code": "czechslovakian"],
                ["name" : "Danish", "code": "danish"],
                ["name" : "Delis", "code": "delis"],
                ["name" : "Diners", "code": "diners"],
                ["name" : "Dumplings", "code": "dumplings"],
                ["name" : "Eastern European", "code": "eastern_european"],
                ["name" : "Ethiopian", "code": "ethiopian"],
                ["name" : "Fast Food", "code": "hotdogs"],
                ["name" : "Filipino", "code": "filipino"],
                ["name" : "Fish & Chips", "code": "fishnchips"],
                ["name" : "Fondue", "code": "fondue"],
                ["name" : "Food Court", "code": "food_court"],
                ["name" : "Food Stands", "code": "foodstands"],
                ["name" : "French", "code": "french"],
                ["name" : "French Southwest", "code": "sud_ouest"],
                ["name" : "Galician", "code": "galician"],
                ["name" : "Gastropubs", "code": "gastropubs"],
                ["name" : "Georgian", "code": "georgian"],
                ["name" : "German", "code": "german"],
                ["name" : "Giblets", "code": "giblets"],
                ["name" : "Gluten-Free", "code": "gluten_free"],
                ["name" : "Greek", "code": "greek"],
                ["name" : "Halal", "code": "halal"],
                ["name" : "Hawaiian", "code": "hawaiian"],
                ["name" : "Heuriger", "code": "heuriger"],
                ["name" : "Himalayan/Nepalese", "code": "himalayan"],
                ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
                ["name" : "Hot Dogs", "code": "hotdog"],
                ["name" : "Hot Pot", "code": "hotpot"],
                ["name" : "Hungarian", "code": "hungarian"],
                ["name" : "Iberian", "code": "iberian"],
                ["name" : "Indian", "code": "indpak"],
                ["name" : "Indonesian", "code": "indonesian"],
                ["name" : "International", "code": "international"],
                ["name" : "Irish", "code": "irish"],
                ["name" : "Island Pub", "code": "island_pub"],
                ["name" : "Israeli", "code": "israeli"],
                ["name" : "Italian", "code": "italian"],
                ["name" : "Japanese", "code": "japanese"],
                ["name" : "Jewish", "code": "jewish"],
                ["name" : "Kebab", "code": "kebab"],
                ["name" : "Korean", "code": "korean"],
                ["name" : "Kosher", "code": "kosher"],
                ["name" : "Kurdish", "code": "kurdish"],
                ["name" : "Laos", "code": "laos"],
                ["name" : "Laotian", "code": "laotian"],
                ["name" : "Latin American", "code": "latin"],
                ["name" : "Live/Raw Food", "code": "raw_food"],
                ["name" : "Lyonnais", "code": "lyonnais"],
                ["name" : "Malaysian", "code": "malaysian"],
                ["name" : "Meatballs", "code": "meatballs"],
                ["name" : "Mediterranean", "code": "mediterranean"],
                ["name" : "Mexican", "code": "mexican"],
                ["name" : "Middle Eastern", "code": "mideastern"],
                ["name" : "Milk Bars", "code": "milkbars"],
                ["name" : "Modern Australian", "code": "modern_australian"],
                ["name" : "Modern European", "code": "modern_european"],
                ["name" : "Mongolian", "code": "mongolian"],
                ["name" : "Moroccan", "code": "moroccan"],
                ["name" : "New Zealand", "code": "newzealand"],
                ["name" : "Night Food", "code": "nightfood"],
                ["name" : "Norcinerie", "code": "norcinerie"],
                ["name" : "Open Sandwiches", "code": "opensandwiches"],
                ["name" : "Oriental", "code": "oriental"],
                ["name" : "Pakistani", "code": "pakistani"],
                ["name" : "Parent Cafes", "code": "eltern_cafes"],
                ["name" : "Parma", "code": "parma"],
                ["name" : "Persian/Iranian", "code": "persian"],
                ["name" : "Peruvian", "code": "peruvian"],
                ["name" : "Pita", "code": "pita"],
                ["name" : "Pizza", "code": "pizza"],
                ["name" : "Polish", "code": "polish"],
                ["name" : "Portuguese", "code": "portuguese"],
                ["name" : "Potatoes", "code": "potatoes"],
                ["name" : "Poutineries", "code": "poutineries"],
                ["name" : "Pub Food", "code": "pubfood"],
                ["name" : "Rice", "code": "riceshop"],
                ["name" : "Romanian", "code": "romanian"],
                ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
                ["name" : "Rumanian", "code": "rumanian"],
                ["name" : "Russian", "code": "russian"],
                ["name" : "Salad", "code": "salad"],
                ["name" : "Sandwiches", "code": "sandwiches"],
                ["name" : "Scandinavian", "code": "scandinavian"],
                ["name" : "Scottish", "code": "scottish"],
                ["name" : "Seafood", "code": "seafood"],
                ["name" : "Serbo Croatian", "code": "serbocroatian"],
                ["name" : "Signature Cuisine", "code": "signature_cuisine"],
                ["name" : "Singaporean", "code": "singaporean"],
                ["name" : "Slovakian", "code": "slovakian"],
                ["name" : "Soul Food", "code": "soulfood"],
                ["name" : "Soup", "code": "soup"],
                ["name" : "Southern", "code": "southern"],
                ["name" : "Spanish", "code": "spanish"],
                ["name" : "Steakhouses", "code": "steak"],
                ["name" : "Sushi Bars", "code": "sushi"],
                ["name" : "Swabian", "code": "swabian"],
                ["name" : "Swedish", "code": "swedish"],
                ["name" : "Swiss Food", "code": "swissfood"],
                ["name" : "Tabernas", "code": "tabernas"],
                ["name" : "Taiwanese", "code": "taiwanese"],
                ["name" : "Tapas Bars", "code": "tapas"],
                ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
                ["name" : "Tex-Mex", "code": "tex-mex"],
                ["name" : "Thai", "code": "thai"],
                ["name" : "Traditional Norwegian", "code": "norwegian"],
                ["name" : "Traditional Swedish", "code": "traditional_swedish"],
                ["name" : "Trattorie", "code": "trattorie"],
                ["name" : "Turkish", "code": "turkish"],
                ["name" : "Ukrainian", "code": "ukrainian"],
                ["name" : "Uzbek", "code": "uzbek"],
                ["name" : "Vegan", "code": "vegan"],
                ["name" : "Vegetarian", "code": "vegetarian"],
                ["name" : "Venison", "code": "venison"],
                ["name" : "Vietnamese", "code": "vietnamese"],
                ["name" : "Wok", "code": "wok"],
                ["name" : "Wraps", "code": "wraps"],
                ["name" : "Yugoslav", "code": "yugoslav"]]
    }

}
