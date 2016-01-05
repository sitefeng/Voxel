//
//  FVBannerView.h
//  JumpPad
//
//  Created by Si Te Feng on 2/23/2014.
//  Copyright (c) 2014 Si Te Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FVBannerView : UIScrollView <UIScrollViewDelegate>


//Array of UIImage
@property (nonatomic, strong, readonly) NSMutableArray* imgArray;

//Array of UIImageView
@property (nonatomic, strong, readonly) NSMutableArray* bannerArray;


- (void)setupBannerWithImageArray:(NSMutableArray *)imgArray frame:(CGRect)frame;

@end
