//
//  DetailViewController.swift
//  FlickrMap
//
//  Created by Marvin Mouroum on 05.12.19.
//  Copyright © 2019 eurecom. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var image: UIImageView!
    var images:NSMutableArray!
    var currentIndex:Int!

    func configureView() {
        // Update the user interface for the detail item.

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
        scrollview.delegate = self
        
        scrollview.minimumZoomScale = 1.0
        scrollview.maximumZoomScale = 5.0

        scrollview.contentSize = .init(width: 2000, height: 2000)
        
        let swipeL = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeL.direction = .left
        let swipeR = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeR.direction = .right
        
        self.view.addGestureRecognizer(swipeL)
        self.view.addGestureRecognizer(swipeR)
    }

    var detailItem: NSDate? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    let indicator = UIActivityIndicatorView(style: .medium)
    
    func loadimage(index: Int){
        
        indicator.frame.size = CGSize(width:100,height:100)
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.startAnimating()
        
        DispatchQueue.global(qos: .background).async {
            let imageURL: NSURL! = self.images.object(at: index) as! NSURL
            let data: NSData! = NSData(contentsOf: imageURL as URL)
            print("data size: %d", data!.length)
            DispatchQueue.main.async {
                self.image.image = UIImage(data: data as Data)
                self.indicator.stopAnimating()
            }
        }
    }
    
    @objc func swiped(_ sender:UISwipeGestureRecognizer){
        print("next image")
        
        if sender.direction == .left {
            currentIndex += 1
        }
        else{
            currentIndex -= 1
            if currentIndex < 0 { currentIndex = self.images.count-1 }
        }
        
        if currentIndex < images.count {
            loadimage(index: currentIndex)
        }
        else{
            currentIndex = 0
            loadimage(index: 0)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.image
    }


}

