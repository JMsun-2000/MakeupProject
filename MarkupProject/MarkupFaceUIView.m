//
//  MarkupFaceView.m
//  MarkupProject
//
//  Created by Sun Jimmy on 6/5/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import "MarkupFaceUIView.h"
#import "FaceDataManager.h"

@interface MarkupFaceUIView()
- (void)showfaceDetectorInfo;
@end

@implementation MarkupFaceUIView

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [[FaceDataManager getInstance] initWithUIImage:[UIImage imageNamed:@"markupdemo.jpg"] limitSize:[[UIScreen mainScreen] bounds]];
        self.basicImageMana = [FaceDataManager getInstance].faceDetector;
        UIImage* afterconverted = [self.basicImageMana getScaledImage];
        [self.basicImageMana detectorFacefromPhoto:[CIImage imageWithCGImage:afterconverted.CGImage]];
    }
    
    return self;
}

- (void)dealloc
{
     [super dealloc];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

    UIImage *newImage = [self.basicImageMana getScaledImage];
    [newImage drawAtPoint:CGPointMake(0.0f, 0.0f)];
    
    // This is for debug
    [self showfaceDetectorInfo];
    

}

- (void)showfaceDetectorInfo
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    // draw face
    // scale the transform
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect faceArea = self.basicImageMana.faceBounds;
    CGPathAddRect(path, NULL, faceArea);
    [[UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:0.3] setFill];
    CGContextAddPath(currentContext, path);
    CGContextDrawPath(currentContext, kCGPathFill);
    CGPathRelease(path);
    
    // draw left eye
    path = CGPathCreateMutable();
    CGPoint leftEyePos = self.basicImageMana.leftEyePosition;
    CGRect leftEyeArea = CGRectMake(leftEyePos.x - faceArea.size.width * 0.01f,
                                    leftEyePos.y - faceArea.size.width * 0.01f,
                                    faceArea.size.width * 0.02f, faceArea.size.width * 0.02f);
    CGPathAddRect(path, NULL, leftEyeArea);
    [[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.3] setFill];
    CGContextAddPath(currentContext, path);
    CGContextDrawPath(currentContext, kCGPathFill);
    CGPathRelease(path);
    
    // draw right eye
    path = CGPathCreateMutable();
    CGPoint rightEyePos = self.basicImageMana.rightEyePosition;
    CGRect rightEyeArea = CGRectMake(rightEyePos.x - faceArea.size.width * 0.1f,
                                     rightEyePos.y - faceArea.size.width * 0.1f,
                                     faceArea.size.width * 0.2f, faceArea.size.width * 0.2f);
    CGPathAddRect(path, NULL, rightEyeArea);
    [[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.3] setFill];
    CGContextAddPath(currentContext, path);
    CGContextDrawPath(currentContext, kCGPathFill);
    CGPathRelease(path);
    
    // draw mouth
    path = CGPathCreateMutable();
    CGPoint mouthPos = self.basicImageMana.mouthPosition;
    CGRect mouthArea = CGRectMake(mouthPos.x - faceArea.size.width * 0.1f,
                                  mouthPos.y - faceArea.size.width * 0.1f,
                                  faceArea.size.width * 0.2f, faceArea.size.width * 0.2f);
    CGPathAddRect(path, NULL, mouthArea);
    [[UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:0.3] setFill];
    CGContextAddPath(currentContext, path);
    CGContextDrawPath(currentContext, kCGPathFill);
    CGPathRelease(path);
    
}





@end
