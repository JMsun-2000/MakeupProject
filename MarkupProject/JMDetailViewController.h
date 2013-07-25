//
//  JMDetailViewController.h
//  MarkupProject
//
//  Created by Sun Jimmy on 6/5/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) UIBarButtonItem *refreshButton;
@property (strong, nonatomic) UIBarButtonItem *mouthButton;
@property (strong, nonatomic) UIBarButtonItem *leftEyeButton;
@property (strong, nonatomic) UIBarButtonItem *rightEyeButton;
@end
