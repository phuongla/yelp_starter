//
//  FilterViewController.swift
//  Yelp
//
//  Created by phuong le on 3/19/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

enum SectionType: Int{
    case Deal = 0
    case Distance = 1
    case SortBy = 2
    case Category = 3
    
}

struct DistanceItem {
    var name:String
    var value:Float
}

struct SortByItem {
    var name:String
    var value:YelpSortMode
}


class FilterViewController: UIViewController {
    
    let headerTitle: [String] = ["", "Distance", "Sort By", "Category"]
    let categories = CategoryData.categories
    
    var tableStructure : [Int] = [1, 1, 1, 4]
    
    let distanceDatas: [DistanceItem] = [DistanceItem(name: "Auto", value: 0), DistanceItem(name: "0.3 miles", value: 0.3), DistanceItem(name: "1 mile", value: 1), DistanceItem(name: "5 miles", value: 5),  DistanceItem(name: "20 miles", value: 20)]
    let sortByDatas = [SortByItem(name: "Best matched", value: YelpSortMode.BestMatched), SortByItem(name: "Distance", value: YelpSortMode.Distance), SortByItem(name: "Highest Rated", value: YelpSortMode.HighestRated)]
    
    
    var filterDatas: FilterInfo = FilterInfo(isOffer: false, distance: 0, sortBy: YelpSortMode.BestMatched, category: [])
    
    weak var delegate:SearchDelegate?
    
    var expandDistance:Bool = false
    var expandSortBy:Bool = false
    var expandCategory:Bool = false
    
    @IBOutlet weak var tableView: UITableView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchHandler(sender: UIBarButtonItem) {
        delegate?.search(self, data: filterDatas)
    }
}

extension FilterViewController: UITableViewDataSource, UITableViewDelegate, SettingSwitchCellDelegate{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableStructure.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitle[section]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SectionType.Distance.rawValue && expandDistance{
            return distanceDatas.count
        } else if section == SectionType.SortBy.rawValue && expandSortBy {
            return sortByDatas.count
        } else if section == SectionType.Category.rawValue && expandCategory{
            return categories.count
        }
        return tableStructure[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case SectionType.Deal.rawValue :
            let cell = tableView.dequeueReusableCellWithIdentifier("SettingCell") as! SettingCell
            cell.nameLabel.text = "Offering a Deal"
            cell.styleCell = StyleCell.Switch
            cell.onOffSwitch.on = filterDatas.isOffer
             cell.delegate = self
            return cell
        case SectionType.Distance.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("SettingCell") as! SettingCell
            
            if expandDistance {
                let distance:DistanceItem = distanceDatas[indexPath.row]
                cell.nameLabel.text = distance.name
                cell.styleCell = StyleCell.Check
                cell.checked = distance.value == filterDatas.distance
                cell.delegate = self
                
            } else {
                let index = getDistanceItemIndex(filterDatas.distance)
                let distance:DistanceItem = distanceDatas[index]
                cell.nameLabel.text = distance.name
                cell.styleCell = StyleCell.Expand
                cell.delegate = self
                return cell
            }
            
            return cell
        case SectionType.SortBy.rawValue:
             let cell = tableView.dequeueReusableCellWithIdentifier("SettingCell") as! SettingCell
             
             if expandSortBy {
                let sortByte = sortByDatas[indexPath.row]
                cell.styleCell = StyleCell.Check
                cell.nameLabel.text = sortByte.name
                cell.checked = sortByte.value == filterDatas.sortBy
                cell.delegate = self
                
             } else{
                let index = getSortByItemIndex(filterDatas.sortBy)
                let sortByte = sortByDatas[index]
                cell.styleCell = StyleCell.Expand
                cell.nameLabel.text = sortByte.name
                cell.delegate = self
             }
          
            return cell
        case SectionType.Category.rawValue:
    
            if indexPath.row == tableStructure.count - 1 && !expandCategory{
                let cell = tableView.dequeueReusableCellWithIdentifier("SeeAllCell") as! SeeAllCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("SettingCell") as! SettingCell
                
                let cat = categories[indexPath.row]
                cell.nameLabel.text = cat["name"]
                cell.styleCell = StyleCell.Switch
                cell.onOffSwitch.on = filterDatas.category.contains(cat["code"]!)
                cell.delegate = self
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
    
    func getDistanceItemIndex(val:Float) -> Int {
        for index in 1...distanceDatas.count {
            if distanceDatas[index - 1].value == val {
                return index - 1
            }
        }
        return 0
    }
    
    func getSortByItemIndex(val:YelpSortMode) -> Int {
        for index in 1...sortByDatas.count {
            if sortByDatas[index - 1].value == val {
                return index - 1
            }
        }
        return 0
    }
    
    
    func onOffHander(cell: SettingCell, newValue: Bool) {
        let indexPath = tableView.indexPathForCell(cell)
        
        if indexPath!.section == 0 {
            filterDatas.isOffer = newValue
        } else if indexPath!.section == SectionType.Category.rawValue {
            
            let cat = categories[indexPath!.row]
            
            if newValue {
                filterDatas.category.append(cat["code"]!)
            } else {
                let index = filterDatas.category.indexOf(cat["code"]!)
                if index >= 0 {
                    filterDatas.category.removeAtIndex(index!)
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == SectionType.Distance.rawValue {
        
            if expandDistance {
                let distance:DistanceItem = distanceDatas[indexPath.row]
                filterDatas.distance = distance.value
            }
            
            expandDistance = !expandDistance
            tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            
            
        } else if indexPath.section == SectionType.SortBy.rawValue {
            
            if expandSortBy {
                let sortBy = sortByDatas[indexPath.row]
                filterDatas.sortBy = sortBy.value
            }
            
            expandSortBy = !expandSortBy
            tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            
        } else if indexPath.section == SectionType.Category.rawValue {
            
            if indexPath.row == tableStructure.count - 1 && !expandCategory{
                expandCategory = !expandCategory
                tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            }
            
        }
    }
    
}

