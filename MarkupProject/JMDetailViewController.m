//
//  JMDetailViewController.m
//  MarkupProject
//
//  Created by Sun Jimmy on 6/5/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import "JMDetailViewController.h"
#import "FacialOrgansViewController.h"

@interface JMDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation JMDetailViewController

- (void)dealloc
{
    [_detailItem release];
    [_detailDescriptionLabel release];
    [_masterPopoverController release];
    [_refreshButton release];
    [_mouthButton release];
    [super dealloc];
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        [_detailItem release];
        _detailItem = [newDetailItem retain];

        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"timeStamp"] description];
    }
    
    // new button
    self.refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refreshMarkupView)];
    self.mouthButton = [[UIBarButtonItem alloc] initWithTitle:@"Mouth" style:UIBarButtonItemStylePlain target:self action:@selector(openMouthEditor)];
    self.leftEyeButton = [[UIBarButtonItem alloc] initWithTitle:@"LeftEye" style:UIBarButtonItemStylePlain target:self action:@selector(openLeftEyeEditor)];
    self.rightEyeButton = [[UIBarButtonItem alloc] initWithTitle:@"RightEye" style:UIBarButtonItemStylePlain target:self action:@selector(openRightEyeEditor)];
    // Add all button to bar
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.refreshButton, self.mouthButton, self.rightEyeButton, self.leftEyeButton, nil];
}

-(void)refreshMarkupView{
    [self.view setNeedsDisplay];
}

-(void)openLeftEyeEditor{
    //Save for current documents view
    UIViewController* documentVC = [[FacialOrgansViewController alloc] init];
    [self.navigationController pushViewController:documentVC animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
