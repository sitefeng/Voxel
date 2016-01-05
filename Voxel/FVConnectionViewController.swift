//
//  FVConnectionViewController.swift
//  Voxel
//
//  Created by Si Te Feng on 12/25/15.
//  Copyright © 2015 Si Te Feng. All rights reserved.
//

import UIKit

class FVConnectionViewController: HNAbstractViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let kCollectionViewCellReuseIdentifier = "kCollectionViewCellReuseIdentifier"
    
    let cellTitles = ["FO24NF", "GJ4OIF", "AGO4OM", "AO9HR4"]
    let cellImageNames = ["voxelModule3", "voxelModule1", "voxelModule2", "voxelModule4"]
    
    var cellWidth: CGFloat = 0
    var cellLabelHeight: CGFloat = 29
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Connection"
        
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
        
    }
    

}
