//
//  ImageViewController.swift
//  Prostate PRO-Tracker
//
//  Created by Jackson Thea on 7/3/16.
//  Copyright © 2016 Jackson Thea. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, UIScrollViewDelegate
{
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.maximumZoomScale = 4.0
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private var imageView = UIImageView()
    
    private var image: UIImage? {
        get { return imageView.image }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
        }
    }
    
    func updateMinZoomScaleForSize() {
        let widthScale = view.bounds.size.width / imageView.bounds.width
        scrollView.minimumZoomScale = widthScale
        scrollView.zoomScale = widthScale
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateMinZoomScaleForSize), name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        image = UIImage(named: "Help document_v1")
        updateMinZoomScaleForSize()
    }
}
