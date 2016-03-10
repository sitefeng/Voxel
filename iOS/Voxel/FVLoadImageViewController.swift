//
//  FVLoadImageViewController.swift
//  Voxel
//
//  Created by Si Te Feng on 12/25/15.
//  Copyright © 2015 Si Te Feng. All rights reserved.
//

import UIKit


class FVLoadImageViewController: FVPatternAbstractViewController, UIScrollViewDelegate {

    var loadedImage: UIImage?
    @IBOutlet weak var scrollView: UIScrollView!
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Load Media"
        
        self.imageView = UIImageView(image: loadedImage)
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.imageView.hidden = true
        
        self.scrollView.addSubview(self.imageView)
        self.scrollView.maximumZoomScale = 3
        self.scrollView.minimumZoomScale = 1
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.delegate = self
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        sizeToFitImage()
        self.imageView.hidden = false
    }
    
    func sizeToFitImage() {
        self.imageView.frame = self.scrollView.bounds;
    }

    // MARK: UIScrollView Delegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
    }
    
    
    // MARK: Overriding super class functions
    override func sendButtonPressed() {
        guard let loadedImage = loadedImage else {
            return
        }
        
        let imageMessage = FVWirelessImageMessage(image: loadedImage)
        FVConnectionManager.sharedManager().sendMessageToVoxel(imageMessage) { (response) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if response == FVWirelessMessageResponse.Success {
                    self.showAlert("Success", message: "Your image has been sent to Voxel")
                } else {
                    self.showAlert("Error Occured", message: "Your image has not been sent. ErrorType: \(response)")
                }
            })
        }
    }
    
    
}
