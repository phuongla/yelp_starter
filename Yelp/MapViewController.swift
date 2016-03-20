//
//  MapViewController.swift
//  Yelp
//
//  Created by phuong le on 3/19/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    var restaurantLocation : NSDictionary!
    var locationManager:CLLocationManager!
    var restaurantName:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        
        
        mapView.delegate = self

        let latitude = restaurantLocation!["latitude"] as! CLLocationDegrees
        let longitude = restaurantLocation!["longitude"] as! CLLocationDegrees
        
        let centerLocation = CLLocation(latitude: latitude, longitude: longitude)
        goToLocation(centerLocation)
        
        let restaurantLoc = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        addAnnotationAtCoordinate(restaurantLoc, title: restaurantName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func goToLocation(loc:CLLocation) {
        let span = MKCoordinateSpanMake(0.2, 0.2)
        let region =  MKCoordinateRegionMake( loc.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    /*
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            
            mapView.setRegion(region, animated: false)
        }
    }
    */

    
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D, title:String) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        
        mapView.addAnnotation(annotation)
    }
    
    /*
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "customAnnotationView"
        
        // custom image annotation
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        else {
            annotationView!.annotation = annotation
        }
    
        if #available(iOS 9.0, *) {
            annotationView!.pinTintColor = UIColor.redColor()
        } else {
            // Fallback on earlier versions
        }

        
        return annotationView
    }
    */

}
