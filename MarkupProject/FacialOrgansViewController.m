//
//  FacialOrgansViewController.m
//  MarkupProject
//
//  Created by Sun Jimmy on 7/20/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import "FacialOrgansViewController.h"
#import "FaceDataManager.h"
#import "PloygonUIView.h"
#import "MarkupDotUIView.h"

@interface FacialOrgansViewController ()
@property (nonatomic) PloygonUIView* polygonView;
@property (nonatomic) NSMutableArray* pointsViewArray;
@end

@implementation FacialOrgansViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithOrganType:(int)type
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_polygonView dealloc];
    for (int i; i < self.pointsViewArray.count; i++){
        [[self.pointsViewArray objectAtIndex:i] release];
    }
    [_pointsViewArray release];
    [super dealloc];
}

- (void)viewDidLoad
{

    // Do any additional setup after loading the view from its nib.
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[FaceDataManager getInstance] getLeftEye:self.view.frame ScaleType:0]];
    [[self view] addSubview:imageView];
    [imageView release];

    // get control point
    NSArray* points = [[FaceDataManager getInstance] getLeftEyePoints];
    
    self.polygonView = [[PloygonUIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.polygonView setPolygonPoints:points];
    [[self view] addSubview:self.polygonView];
    
    self.pointsViewArray = [[NSMutableArray alloc] init];
    // show control point
    for (int i = 0; i < points.count; i++){
        CGPoint p = [[points objectAtIndex:i] CGPointValue];
        // add small offset for point middle
        MarkupDotUIView* point = [[MarkupDotUIView alloc] initWithFrame:CGRectMake(p.x - 9, p.y - 9, 18, 18)];
        [self.pointsViewArray addObject:point];
        [[self view] addSubview:point];
    }
}

-(void)reDrawPolygon
{
    NSMutableArray* points = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.pointsViewArray.count; i++){
        MarkupDotUIView* dot = [self.pointsViewArray objectAtIndex:i];
        CGRect pinFrame = dot.frame;
        CGPoint point = CGPointMake(CGRectGetMidX(pinFrame),CGRectGetMidY(pinFrame));
        [points addObject:[NSValue valueWithCGPoint:point]];
    }
    [self.polygonView setPolygonPoints:points];
    [self.polygonView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
