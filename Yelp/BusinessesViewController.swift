//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MBProgressHUD


class BusinessesViewController: UIViewController, SearchDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    
    var businesses: [Business] = []
    var searchBar:UISearchBar!
  
    var searchDefaut:String = ""
    var isLoadMoreData:Bool = false
    var searchText:String = ""
    
    var filterData:FilterInfo!
    
    let limit = 20
    var offset = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Restaurants"
        
        
        navigationItem.titleView = searchBar
        
        
        loadDataFilter()

    }

    
    func loadDataFilter() {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        if filterData == nil {
            Business.searchWithTerm(getSearchText(), offset: offset, limit: limit, completion: { (businesses: [Business]!, error: NSError!) -> Void in
                
                if businesses == nil {
                    self.loadDataError()
                } else{
                    self.loadDataComplete(businesses)
                }
                
            })
            
        } else {
        
            Business.searchWithTerm(getSearchText(), sort: filterData.sortBy, categories: filterData.category, deals: filterData.isOffer, radius_filter: filterData.distance * 1600, offset: offset, limit: limit, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            
                if businesses == nil {
                    self.loadDataError()
                } else{
                    self.loadDataComplete(businesses)
                }
                
            })
        }

    }
    
    func loadDataComplete(businesses: [Business]) {
        self.isLoadMoreData = false
        if offset > 0 {
            for bus in businesses {
                self.businesses.append(bus)
            }
        } else {
            self.businesses = businesses
        }
        self.tableView.reloadData()
        
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
    func loadDataError() {
        // create the alert
        let alert = UIAlertController(title: "Infomation", message: "Your search data is not found.", preferredStyle: UIAlertControllerStyle.Alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
        
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.destinationViewController is UINavigationController {
        
            let nag = segue.destinationViewController as! UINavigationController
        
            let vc =  nag.topViewController as!MapViewController
        
            let cell = sender as! BusinessesCell
            let indexPath = tableView.indexPathForCell(cell)
        
            let bus = businesses[indexPath!.row]
            vc.restaurantLocation = bus.coordinate
            vc.restaurantName = bus.name
            
        } else {
            let vc = segue.destinationViewController as?FilterViewController
            vc?.delegate = self
            if filterData != nil {
                print(filterData.isOffer)
                vc?.filterDatas = filterData
            }
        }
        
    }


    @IBAction func backMainScreen(segue: UIStoryboardSegue) {
        segue.sourceViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func search(vc:UIViewController, data: FilterInfo) {
        vc.dismissViewControllerAnimated(true, completion: nil)
    
        self.offset = 0
        filterData = data
        loadDataFilter()
    }
    
}

extension BusinessesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.businesses.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessesCell") as! BusinessesCell
        
        cell.business = self.businesses[indexPath.row]
        
        return cell
    }
    
    func getSearchText() -> String {
        return searchText.isEmpty ? searchDefaut : searchText
    }

}

extension BusinessesViewController : UISearchBarDelegate {
    func searchBarCancelButtonClicked( searchBar: UISearchBar) {
        searchBar.text = ""
        self.searchText = ""
        self.offset = 0
        searchBar.endEditing(true)
        self.loadDataFilter()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar){
        searchBar.showsCancelButton = false
    }
    
    func searchBar(searchBar: UISearchBar,
        textDidChange searchText: String) {
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchText = searchBar.text!
        self.offset = 0
        searchBar.endEditing(true)
        
        self.loadDataFilter()
    }
}

extension BusinessesViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if !self.isLoadMoreData {
            let contentSize = tableView.contentSize.height
            let scrollOffsetThreshold = contentSize - tableView.bounds.size.height
            
            if (scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isLoadMoreData = true
                offset += limit
                
                loadDataFilter()
            }
        }
        
    }
}

protocol SearchDelegate:class {
    func search(vc:UIViewController, data: FilterInfo)
}
