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

CGFloat const DEFAULT_LEFTEYE_SHADOW_WIDTH = 249.57563983f;
CGFloat const DEFAULT_LEFTEYE_SHADOW_HEIGHT = 100.00000f;
CGFloat const LEFTEYE_REFERENCE_POINT_X = 412.0f;
CGFloat const LEFTEYE_REFERENCE_POINT_Y = 208.0f;

@interface FacialOrgansViewController ()
@property (nonatomic) PloygonUIView* polygonView;
@property (nonatomic) UIImageView* maskView;
@property (nonatomic) NSMutableArray* pointsViewArray;
@property (nonatomic) UIBezierPath* curOrganShapePath;
@property (nonatomic) BOOL isMakeUp;
@property (nonatomic) UISlider* alphaSlider;
@property (nonatomic) UIImageView* colorMapImageView;
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
    [_maskView dealloc];
    [_alphaSlider dealloc];
    for (int i; i < self.pointsViewArray.count; i++){
        [[self.pointsViewArray objectAtIndex:i] release];
    }
    [_pointsViewArray release];
    
    if (self.curOrganShapePath != nil){
        [self.curOrganShapePath release];
    }
    
    [super dealloc];
}

- (void)viewDidLoad
{
    self.isMakeUp = false;
    
    // set background color
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[FaceDataManager getInstance] getLeftEye:self.view.frame ScaleType:0]];
    [[self view] addSubview:imageView];
    [imageView release];

    // get control point
    NSArray* points = [[FaceDataManager getInstance] getLeftEyePoints];
    
    self.polygonView = [[PloygonUIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.polygonView setPolygonPoints:points];
    [[self view] addSubview:self.polygonView];
    self.maskView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[self view] addSubview:self.maskView];
    
    self.pointsViewArray = [[NSMutableArray alloc] init];
    // show control point
    for (int i = 0; i < points.count; i++){
        CGPoint p = [[points objectAtIndex:i] CGPointValue];
        // add small offset for point middle
        MarkupDotUIView* point = [[MarkupDotUIView alloc] initWithFrame:CGRectMake(p.x - 9, p.y - 9, 18, 18)];
        [self.pointsViewArray addObject:point];
        [[self view] addSubview:point];
    }
    
    // Add mask button
    self.maskLeftEyeButton = [[UIBarButtonItem alloc] initWithTitle:@"MaskLeftEye" style:UIBarButtonItemStylePlain target:self action:@selector(doMaskLeftEye)];
    // Add all button to bar
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.maskLeftEyeButton,nil];

    // add alpha slider bar
    self.alphaSlider = [[UISlider alloc] initWithFrame:CGRectMake(10.0, [[UIScreen mainScreen] bounds].size.height - 300, 200, 20)];
    self.alphaSlider.minimumValue = 0.0f;
    self.alphaSlider.maximumValue = 1.0f;
    self.alphaSlider.value = 1.0f;
    self.alphaSlider.continuous = YES;
    [self.alphaSlider addTarget:self action:@selector(maskAlphaChange) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.alphaSlider];
    
    self.colorMapImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"colorpallette.png"]];
    self.colorMapImageView.center = CGPointMake(450, [[UIScreen mainScreen] bounds].size.height - 250);

    [self.view addSubview:self.colorMapImageView];
}

-(void)maskAlphaChange
{
    float alpha = self.alphaSlider.value;
    self.maskView.alpha = alpha;
}

-(void)doMaskLeftEye
{
    // Get bezier path
    self.curOrganShapePath = [[self.polygonView getCurPath] retain];
    // update mask
    [self updateMaskLeftEye];
    // remove the polygon
    [self.polygonView removeFromSuperview];
    self.isMakeUp = true;
}

-(void)updateMaskLeftEye{
    UIImage *maskedImage = [self getLeftEyeMask];
    self.maskView.backgroundColor = [UIColor colorWithPatternImage:maskedImage];
}

-(UIImage*)getLeftEyeMask
{
    CGPoint pointsPos[4];
    // get 4 points
    for (int i = 0; i < self.pointsViewArray.count; i++){
        pointsPos[i] = [[self.pointsViewArray objectAtIndex:i] center];
    }
    
    UIImage *leftEye = [[FaceDataManager getInstance] getLeftEye:self.view.frame ScaleType:0];
    CGRect canvesRect = CGRectMake(0.0f, 0.0f, leftEye.size.width, leftEye.size.height);
    
    // Add Color by draw context
    UIGraphicsBeginImageContext(leftEye.size);
    CGContextRef oldContext = UIGraphicsGetCurrentContext();
    [leftEye drawAtPoint:CGPointZero];
    // save context
    CGContextSaveGState(oldContext);
    
    // Overlay red color
    CGContextSetBlendMode(oldContext, kCGBlendModeOverlay);
    // draw red
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, canvesRect);
    [[UIColor colorWithRed:1.00f green:0.00f blue:0.00f alpha:1.0f] setFill];
    CGContextAddPath(oldContext, path);
    CGContextDrawPath(oldContext, kCGPathFill);
    CGPathRelease(path);
    
    // recovery environment and save new Image
    CGContextRestoreGState(oldContext);
    UIImage *source = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // test for step1
    //return source;
    
    // Add alpha mask
    UIImage *maskOriginal = [UIImage imageNamed:@"eyeshadow-test-samples-L.jpg"];
    // Scale and rotation mask
    CGFloat curXDist = pointsPos[2].x - pointsPos[0].x;
    CGFloat curYDist = pointsPos[2].y - pointsPos[0].y;
    CGFloat curEyeDistance = sqrt((curXDist*curXDist)+(curYDist*curYDist));
    curXDist = pointsPos[3].x - pointsPos[1].x;
    curYDist = pointsPos[3].y - pointsPos[1].y;
    CGFloat curEyeHeight = sqrt((curXDist*curXDist)+(curYDist*curYDist));
    CGFloat xScaleFactor = curEyeDistance/DEFAULT_LEFTEYE_SHADOW_WIDTH;
    CGFloat yScaleFactor = curEyeHeight/DEFAULT_LEFTEYE_SHADOW_HEIGHT;
    CGFloat realWidth = maskOriginal.size.width * xScaleFactor;
    CGFloat realHeigth = maskOriginal.size.height * yScaleFactor;
    CGFloat xOffset = LEFTEYE_REFERENCE_POINT_X * xScaleFactor;
    CGFloat yOffset = LEFTEYE_REFERENCE_POINT_Y * yScaleFactor;
    xOffset = pointsPos[2].x-xOffset;
    yOffset = pointsPos[2].y-yOffset;
    
    UIGraphicsBeginImageContext(leftEye.size);
    oldContext = UIGraphicsGetCurrentContext();
    // save context
    CGContextSaveGState(oldContext);
    [[UIColor colorWithWhite:1.0f alpha:1.0f] setFill];
    UIRectFill(canvesRect);
    [maskOriginal drawInRect:CGRectMake(xOffset, yOffset, realWidth, realHeigth)];
    // move the polygon of eye
    [self.curOrganShapePath fill];
    
    // recovery environment and save new Image
    CGContextRestoreGState(oldContext);
    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // test for step2
    //return maskImage;
    
    CGImageRef maskRef = maskImage.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef sourceImage = [source CGImage];
    CGImageRef imageWithAlpha = sourceImage;
    if ((CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNone)
        || (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNoneSkipFirst)
        || (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNoneSkipLast)){
        imageWithAlpha = CopyImageAndAddAlphaChannel(sourceImage);
    }
    
    CGImageRef masked = CGImageCreateWithMask(imageWithAlpha, mask);
    CGImageRelease(mask);
    
    if (sourceImage != imageWithAlpha) {
        CGImageRelease(imageWithAlpha);
    }
    
    //Added extra render step to force it to save correct alpha values (not the mask)
    UIImage* retImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    
    UIGraphicsBeginImageContext(retImage.size);
    [retImage drawAtPoint:CGPointZero];
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    retImage = nil;
    
    return newImg;
}

CGImageRef CopyImageAndAddAlphaChannel(CGImageRef sourceImage) {
    
    CGImageRef retVal = NULL;
    
    size_t width = CGImageGetWidth(sourceImage);
    
    size_t height = CGImageGetHeight(sourceImage);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL, width, height,
                                                          
                                                          8, 0, colorSpace,   kCGImageAlphaPremultipliedLast );
    
    
    if (offscreenContext != NULL) {
        
        CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), sourceImage);
        
        retVal = CGBitmapContextCreateImage(offscreenContext);
        
        CGContextRelease(offscreenContext);
        
    }
    
    CGColorSpaceRelease(colorSpace);
    
    return retVal;
    
}

-(void)reDrawPolygon
{
    // check if make up done
    if (self.isMakeUp){
        // adjust the mask
        [self updateMaskLeftEye];
    }
    else{
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
