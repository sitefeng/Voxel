//
//  ViewController.h
//  DKVerticalColorPicker
//
//  Created by David Kopec on 1/6/15.
//  Copyright (c) 2015 Oak Snow Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKVerticalColorPicker.h"

@interface ViewController : UIViewController <DKVerticalColorPickerDelegate>

-(void)colorPicked:(UIColor *)color;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com