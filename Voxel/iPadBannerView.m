//
//  iPadBannerView.m
//  JumpPad
//
//  Created by Si Te Feng on 2/23/2014.
//  Copyright (c) 2014 Si Te Feng. All rights reserved.
//

#import "iPadBannerView.h"

@implementation iPadBannerView {
    
    float          _bannerWidth;
    BOOL           _bannerRightIsSet;
    BOOL           _bannerLeftIsSet;
    
    NSTimer*       _scrollTimer;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //Setting up iVars
        _bannerRightIsSet = NO; //this flag prevents scroll being stalled
        _bannerLeftIsSet = NO;
        
        _bannerWidth = frame.size.width;
        self.bannerArray = [NSMutableArray array];

        //Adding images Statically
        UIImage* img1 = [UIImage imageNamed:@"banner1"];
        UIImage* img2 = [UIImage imageNamed:@"banner2"];
        UIImage* img3 = [UIImage imageNamed:@"banner3"];
        UIImage* img4 = [UIImage imageNamed:@"banner4"];
        UIImage* img5 = [UIImage imageNamed:@"banner5"];
        self.imgArray = [@[img1, img2, img3, img4, img5] mutableCopy];
        
        //Adding all the banners to the view
        for(int i=0; i< [self.imgArray count]; i++)
        {
            UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*frame.size.width, 0, frame.size.width, frame.size.height)];
            
            imgView.image = self.imgArray[i];
            
            [self.bannerArray addObject:imgView];
            [self addSubview: self.bannerArray[i]];
        }
        
        //Adding a repeated 1st and 2nd images of the array for Infinite Scrolling
        for(int i=0; i< 2; i++)
        {
            UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake((i+[self.imgArray count])*frame.size.width, 0, frame.size.width, frame.size.height)];
            
            imgView.image = self.imgArray[i];
            
            [self.bannerArray addObject:imgView];
            [self addSubview: self.bannerArray[i+[self.imgArray count]]];
            
        }
        
        //Setting up properties for Scroll View
        self.showsHorizontalScrollIndicator = NO;
        self.contentInset = UIEdgeInsetsZero;
        self.pagingEnabled = YES;
        [self setContentSize:CGSizeMake(frame.size.width*([self.imgArray count]+2), 200)];
        self.delegate = self;

        //Show 2nd Banner first for infinite scrolling
        [self setContentOffset:CGPointMake(_bannerWidth, 0) animated:NO];

        //Setting up Automatic Scrolling
        _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(autoscrollBanner) userInfo:nil repeats:YES];
        
    }
    return self;
}

//Auto Scrolling the banner periodically
- (void)autoscrollBanner
{
    float currentOffset = self.contentOffset.x;
    
    CGPoint newOffset = CGPointMake(currentOffset + _bannerWidth, 0);
    [self setContentOffset:newOffset animated:YES];
}


#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger imageCount = [self.imgArray count];
    
    //Setting up Infinite Scrolling
    
    //Right Side
    BOOL isLastBanner = fabs(scrollView.contentOffset.x - _bannerWidth*(imageCount+1)) < 8.0;
    CGPoint secondBanner = CGPointMake(_bannerWidth, 0);
    
    if(isLastBanner && !_bannerRightIsSet)
    {
        [self setContentOffset:secondBanner animated:NO];
        _bannerRightIsSet = YES;
    }
    
    BOOL isOutsideRightDetectionZone = (fabs(scrollView.contentOffset.x - _bannerWidth*(imageCount+1)) > 8.0) && (fabs(scrollView.contentOffset.x - _bannerWidth*(imageCount+1)) < 100.0);

    if(isOutsideRightDetectionZone)
    {
        _bannerRightIsSet = NO;
    }
    
    
    //Left Side
    BOOL isFirstBanner = fabs(scrollView.contentOffset.x - 0) < 8.0;
    CGPoint firstBanner = CGPointMake(_bannerWidth*(imageCount), 0);
    
    if(isFirstBanner && !_bannerLeftIsSet)
    {
        [self setContentOffset:firstBanner animated:NO];
    }
    
    BOOL isOutSideLeftDetectionZone = (fabs(scrollView.contentOffset.x - 0) > 8.0) && (fabs(scrollView.contentOffset.x - 0) < 100.0);
    
    if(isOutSideLeftDetectionZone)
    {
        _bannerLeftIsSet = NO;
    }

}


@end
