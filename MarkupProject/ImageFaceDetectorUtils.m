//
//  BasicImageManager.m
//  MarkupProject
//
//  Created by Sun Jimmy on 6/6/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import "ImageFaceDetectorUtils.h"
#import <CoreImage/CoreImage.h>

@interface ImageFaceDetectorUtils()

@property (nonatomic, strong) UIImage *m_originalImage;
@property (nonatomic, strong) UIImage *m_scaledImage;
@property (nonatomic) CGRect m_limitedSize;
@end

@implementation ImageFaceDetectorUtils

-(id)initWithUIImage:(UIImage*)image limitSize:(CGRect)boundBox
{
    self.m_originalImage = [image retain];
    self.m_limitedSize = boundBox;
    
    // initialize scaled the size
    [self scaledFactor:boundBox];
    
    // initialize face detector
    NSDictionary *detectorOptions = [[NSDictionary alloc] initWithObjectsAndKeys:CIDetectorAccuracyLow, CIDetectorAccuracy, nil];
	faceDetector = [[CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions] retain];
	[detectorOptions release];
    
    return self;
}

-(void)dealloc
{
    [_m_originalImage release];
    [_m_scaledImage release];
    [faceDetector release];
    [super dealloc];
}

- (UIImage*)getOriginalImage
{
    return self.m_originalImage;
}

- (UIImage*)getScaledImage
{
    if (self.m_scaledImage != nil){
        // still there
       return self.m_scaledImage;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.sizeAfterScale, NO, 0.0);
    [self.m_originalImage drawInRect:CGRectMake(0, 0, self.sizeAfterScale.width, self.sizeAfterScale.height)];
    self.m_scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return self.m_scaledImage;
}

-(void)scaledFactor:(CGRect)boxBounds
{
    CGFloat imageWidth = [self.m_originalImage size].width;
    CGFloat imageHeight = [self.m_originalImage size].height;
    CGFloat screenWidth = boxBounds.size.width;
    CGFloat screenHeight = boxBounds.size.height;
    
    _curScaleFactor = 1.0f;
    
    // check for a  most suitable factor
    if ((imageHeight > imageWidth) && (imageHeight > screenHeight)){
        _curScaleFactor = imageHeight / screenHeight;
    }
    else if ((imageWidth >= imageHeight) && (imageHeight > screenWidth)){
        _curScaleFactor = imageWidth / screenWidth;
    }
    
    _sizeAfterScale.width = imageWidth/self.curScaleFactor;
    _sizeAfterScale.height = imageHeight/self.curScaleFactor;
}

-(void)detectorFacefromPhoto:(CIImage *)photo{
    CIImage* ciimage = photo;
    NSArray* features = [faceDetector featuresInImage:ciimage];
    
    for (CIFaceFeature* faceFeature in features){
        _faceBounds = faceFeature.bounds;
        
        _faceBounds.origin.y = self.sizeAfterScale.height - _faceBounds.origin.y - _faceBounds.size.height;
        
        // left eye
        if (faceFeature.hasLeftEyePosition){
            _leftEyePosition = faceFeature.leftEyePosition;
            _leftEyePosition.y = self.sizeAfterScale.height - _leftEyePosition.y;
        }
        
        // right eye
        if (faceFeature.hasRightEyePosition){
            _rightEyePosition = faceFeature.rightEyePosition;
            _rightEyePosition.y = self.sizeAfterScale.height - _rightEyePosition.y;
        }
        
        // mouth
        if (faceFeature.hasMouthPosition){
            _mouthPosition = faceFeature.mouthPosition;
            _mouthPosition.y = self.sizeAfterScale.height - _mouthPosition.y;
        }
        
        // just one face now
        break;
    }
    
}

@end
