//
//  MasterViewController.swift
//  FlickrMap
//
//  Created by Marvin Mouroum on 05.12.19.
//  Copyright © 2019 eurecom. All rights reserved.
//

import UIKit
import MapKit


class MasterViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
   
    var kml:KMLParser!
    
    var images:NSMutableArray = []

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        
        navigationItem.rightBarButtonItem = addButton
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        addThefollowingCode()
    }
    
    func addThefollowingCode(){
        let stringpath = "https://www.flickr.com/services/feeds/geo/fr?format=kml&page=1"
        let url = URL(string: stringpath)
        self.kml = KMLParser.parseKML (at: url)
        let annotations : NSArray = kml.points as NSArray
        map.addAnnotations(annotations as! [MKAnnotation])
        map.visibleMapRect = kml.pointsRect()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @objc
    func insertNewObject(_ sender: Any) {
        objects.insert(NSDate(), at: 0)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pin: MKAnnotationView = kml.view(for: annotation)
        let rightButton: UIButton! = UIButton(type: UIButton.ButtonType.detailDisclosure)
        rightButton.addTarget(self, action: #selector(showDetail), for: UIControl.Event.touchUpInside)
        pin.rightCalloutAccessoryView = rightButton
        rightButton.tag = images.count
        let url = kml.imageURL(for: annotation)
        self.images.add(url)
        return pin
    }
    
    @objc func showDetail(_ sender:UIButton){
        self.detailViewController = storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        let button = sender
        self.detailViewController!.images = self.images
        self.detailViewController!.currentIndex = button.tag
        self.navigationController?.pushViewController(self.detailViewController!, animated: true)
        self.detailViewController?.loadimage(index: button.tag)
    }



}

