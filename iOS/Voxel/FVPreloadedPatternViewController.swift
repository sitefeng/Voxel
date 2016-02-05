//
//  FVPreloadedPatternViewController.swift
//  Voxel
//
//  Created by Si Te Feng on 12/25/15.
//  Copyright © 2015 Si Te Feng. All rights reserved.
//

import UIKit

class FVPreloadedPatternViewController: HNAbstractViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let kCollectionViewCellReuseIdentifier = "kCollectionViewCellReuseIdentifier"
    
    let cellTitles = ["Voxel Images", "Light Patterns", "Sound Visualizer", "Request Feature"]
    let cellImageNames = ["preloadedImages", "lightPatterns", "soundVisualizer", "3DModel"]
    
    var cellWidth: CGFloat = 0
    var cellLabelHeight: CGFloat = 29
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Voxel Patterns"
        
        let layout = UICollectionViewFlowLayout()
        
        self.collectionView.collectionViewLayout = layout
        self.collectionView.registerNib(UINib(nibName: "FVMainCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kCollectionViewCellReuseIdentifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        // Calculate collection view cell width
        let collectionViewWidth = UIScreen.mainScreen().bounds.width
        cellWidth = (collectionViewWidth - 26) / 2
        self.collectionView.reloadData()
        
    }

   
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellTitles.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCollectionViewCellReuseIdentifier, forIndexPath: indexPath) as! FVMainCollectionViewCell
        
        cell.mainImageView.image = UIImage(named: cellImageNames[indexPath.row])
        cell.mainLabel.text = cellTitles[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: cellWidth , height: cellWidth + cellLabelHeight)
        
    }
    
    
    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0: // Home
            let mainViewController: FVHomeViewController! = FVHomeViewController(nibName:"FVHomeViewController", bundle: nil)
      
            
        case 1: // MyPattern
            let myPatternVC = FVMyPatternViewController(nibName: "FVMyPatternViewController", bundle: NSBundle.mainBundle())
       
            
        case 2: // PreloadedPattern
            let preloadedPatternVC = FVPreloadedPatternViewController(nibName: "FVPreloadedPatternViewController", bundle: NSBundle.mainBundle())
       
        case 3: // Connection
            let connectionVC = FVConnectionViewController(nibName: "FVConnectionViewController", bundle: NSBundle.mainBundle())

            
        default:
            print("No Action Implemented")
            
        }
    

    }
    
    
    

}
