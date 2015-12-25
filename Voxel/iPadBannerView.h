//
//  iPadBannerView.h
//  JumpPad
//
//  Created by Si Te Feng on 2/23/2014.
//  Copyright (c) 2014 Si Te Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iPadBannerView : UIScrollView <UIScrollViewDelegate>


//Array of UIImage
@property (nonatomic, strong) NSMutableArray* imgArray;

//Array of UIImageView
@property (nonatomic, strong) NSMutableArray* bannerArray;


@end
