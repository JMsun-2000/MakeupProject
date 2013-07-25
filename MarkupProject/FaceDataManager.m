//
//  FaceDataManager.m
//  MarkupProject
//
//  Created by Sun Jimmy on 7/13/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import "FaceDataManager.h"


static FaceDataManager *instance = nil;



@implementation FaceDataManager{
    CGRect leftEyeScope;
    CGFloat scalefactor;
    CGPoint leftEyePos; 
    CGPoint rightEyePos;
}

+(FaceDataManager *)getInstance
{
    if (instance == nil){
        // Create instance
        instance = [FaceDataManager alloc];
    }
    
    return instance;
}

-(void)initWithUIImage:(UIImage*)image limitSize:(CGRect)boundBox
{
    self.faceDetector = [[ImageFaceDetectorUtils alloc] initWithUIImage:image limitSize:boundBox];
}

-(UIImage*)getLeftEye:(CGRect)boundBox ScaleType:(int)scaleType
{
    UIImage* original = [self.faceDetector getOriginalImage];
    scalefactor = self.faceDetector.curScaleFactor;
    leftEyePos  =  self.faceDetector.leftEyePosition;
    rightEyePos = self.faceDetector.rightEyePosition;
    CGFloat centerPos = (leftEyePos.x + rightEyePos.x) /2.0f;
    CGFloat leftBond = self.faceDetector.faceBounds.origin.x;
    CGFloat width = centerPos - leftBond;
    CGFloat height = width;
    CGFloat topPos = leftEyePos.y - height/2.0f;
    leftEyeScope = CGRectMake(leftBond*scalefactor, topPos*scalefactor, width*scalefactor, height*scalefactor);
    CGImageRef imageRef = CGImageCreateWithImageInRect([original CGImage], leftEyeScope);
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return img;
}

-(NSArray*)getLeftEyePoints
{
    CGFloat eyeWidth = self.faceDetector.faceBounds.size.width * 0.2f / 2.0f;
    CGFloat eyeHeight = eyeWidth / 3.0f;
    CGFloat offsetX = leftEyeScope.origin.x;
    CGFloat offsetY = leftEyeScope.origin.y;
    
    CGPoint point1 = CGPointMake((leftEyePos.x - eyeWidth)*scalefactor - offsetX, leftEyePos.y * scalefactor - offsetY);
    CGPoint point2 = CGPointMake(leftEyePos.x*scalefactor - offsetX, (leftEyePos.y - eyeHeight) * scalefactor - offsetY);
    CGPoint point3 = CGPointMake((leftEyePos.x + eyeWidth)*scalefactor - offsetX, leftEyePos.y * scalefactor - offsetY);
    CGPoint point4 = CGPointMake(leftEyePos.x*scalefactor - offsetX, (leftEyePos.y + eyeHeight) * scalefactor - offsetY);
    return [NSArray arrayWithObjects:[NSValue valueWithCGPoint:point1],
                                     [NSValue valueWithCGPoint:point2],
                                     [NSValue valueWithCGPoint:point3],
                                     [NSValue valueWithCGPoint:point4],
                                      nil];
}

@end
