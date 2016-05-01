//
//  ViewController.m
//  DKVerticalColorPicker
//
//  Created by David Kopec on 1/6/15.
//  Copyright (c) 2015 Oak Snow Consulting. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet DKVerticalColorPicker *vertPicker;
@property (nonatomic, weak) IBOutlet UIView *sampleView;
@property (weak, nonatomic) IBOutlet UILabel *sampleLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.vertPicker.selectedColor = [UIColor blueColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)colorPicked:(UIColor *)color
{
    self.sampleView.backgroundColor = color;
    self.sampleLabel.textColor = color;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com