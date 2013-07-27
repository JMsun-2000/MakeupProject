//
//  FacialOrgansViewController.h
//  MarkupProject
//
//  Created by Sun Jimmy on 7/20/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FacialOrgansViewController : UIViewController
-(void)reDrawPolygon;
@property (strong, nonatomic) UIBarButtonItem *maskLeftEyeButton;
@property (strong, nonatomic) UIBarButtonItem *maskRightEyeButton;
@end
