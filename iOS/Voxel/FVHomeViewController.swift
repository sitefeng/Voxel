//
//  FVHomeViewController.swift
//  Voxel
//
//  Created by Si Te Feng on 12/25/15.
//  Copyright © 2015 Si Te Feng. All rights reserved.
//

import UIKit

class FVHomeViewController: HNAbstractViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var bannerView: FVBannerView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let collectionViewCellReuseIdentifier = "collectionViewCellReuseIdentifier"
    
    let cellImageNames = ["myPatterns", "preloadedPatterns", "connection", "cameraSLR", "settings"]
    let cellTitles = ["My Patterns", "Voxel Patterns", "Connection Help", "Night Camera", "Settings"]
    
    let numPaintings = 5
    
    var cellWidth: CGFloat = 0
    var cellLabelHeight: CGFloat = 29
    let numCellCols: CGFloat = 2
    let cellMargin: CGFloat = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Home"
        
        // Setup Collection View
        let flowLayout = UICollectionViewFlowLayout()
        
        self.collectionView.registerNib(UINib(nibName: "FVMainCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: collectionViewCellReuseIdentifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        // Setup for Banner
        var imgArray: [UIImage] = []
        for i in 0..<numPaintings {
            let imageName = "lightPainting\(i)"
            let image = UIImage(named: imageName)!
            imgArray.append(image)
        }
        
        let traditionalArray = imgArray as NSArray
        let mutableArray = NSMutableArray(array: traditionalArray)
        let bannerFrame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 150)
        self.bannerView.setupBannerWithImageArray(mutableArray, frame: bannerFrame)
        
        
        // Calculate collection view cell width
        let collectionViewWidth = UIScreen.mainScreen().bounds.width
        cellWidth = (collectionViewWidth - cellMargin * (numCellCols) - 24) / numCellCols
        self.collectionView.reloadData()
    }
    
    
    
    
    // MARK: UICollectionView DataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellTitles.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let collectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(collectionViewCellReuseIdentifier, forIndexPath: indexPath) as! FVMainCollectionViewCell
        
        collectionViewCell.mainImageView.image = UIImage(named: self.cellImageNames[indexPath.row])
        collectionViewCell.mainLabel.text = self.cellTitles[indexPath.row]
        
        return collectionViewCell
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: cellWidth , height: cellWidth + cellLabelHeight)
    
    }
    
    
    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.abstractViewController(self, switchToHeaderIndex: indexPath.row + 1)
    }

    
    
    
    
    
    
}
