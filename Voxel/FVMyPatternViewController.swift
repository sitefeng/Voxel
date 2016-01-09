//
//  FVMyPatternViewController.swift
//  Voxel
//
//  Created by Si Te Feng on 12/25/15.
//  Copyright © 2015 Si Te Feng. All rights reserved.
//

import UIKit

class FVMyPatternViewController: HNAbstractViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let kCollectionViewCellReuseIdentifier = "kCollectionViewCellReuseIdentifier"
    
    let cellTitles = ["Solid Color", "Set LEDs", "Load Media", "2D Draw", "Load STL"]
    let cellImageNames = ["solidColor", "setLEDs", "loadMedia", "draw2D", "draw3D"]
    
    var cellWidth: CGFloat = 0
    var cellLabelHeight: CGFloat = 29
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Patterns"
        
        let layout = UICollectionViewFlowLayout()
        
        self.collectionView.collectionViewLayout = layout
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerNib(UINib(nibName: "FVMainCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kCollectionViewCellReuseIdentifier)
        self.collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        // Calculate collection view cell width
        let collectionViewWidth = UIScreen.mainScreen().bounds.width
        cellWidth = (collectionViewWidth - 26) / 2
        self.collectionView.reloadData()
    }
    
    
    // MARK: Collection View Delegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellTitles.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let collectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(kCollectionViewCellReuseIdentifier, forIndexPath: indexPath) as! FVMainCollectionViewCell
        
        collectionViewCell.mainImageView.image = UIImage(named: cellImageNames[indexPath.row])
        collectionViewCell.mainLabel.text = cellTitles[indexPath.row]
        
        return collectionViewCell
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: cellWidth , height: cellWidth + cellLabelHeight)
        
    }
    
    
    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
        case 0: // Solid Color
            let mainViewController: FVHomeViewController! = FVHomeViewController(nibName:"FVHomeViewController", bundle: nil)
  
            
        case 1: // Set LEDs
            let myPatternVC = FVMyPatternViewController(nibName: "FVMyPatternViewController", bundle: NSBundle.mainBundle())
   
            
        case 2: // Load Media
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imagePicker, animated: true, completion: nil)
     
            
        case 3: // 2D Draw

            let customDraw = FVCustomDrawViewController(nibName:"FVCustomDrawViewController", bundle: nil)
            let navController = FVNavigationController(rootViewController: customDraw)
            
            self.presentViewController(navController, animated: true, completion: nil)
            
        case 4: // 3D STL
            let cameraVC = FVCameraViewController(nibName: "FVCameraViewController", bundle: NSBundle.mainBundle())
            
        default:
            print("No Action Implemented")
            
        }
    

        
    }
    
    
    
    
    
    
    
    
    
    
    
   
}
