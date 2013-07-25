//
//  BasicImageManager.h
//  MarkupProject
//
//  Created by Sun Jimmy on 6/6/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CIDetector;


@interface ImageFaceDetectorUtils : NSObject{
    CIDetector *faceDetector;
}

@property (nonatomic, readonly) CGFloat curScaleFactor;
@property (nonatomic, readonly) CGSize sizeAfterScale;
@property (nonatomic, readonly) CGRect faceBounds;
@property (nonatomic, readonly) CGPoint leftEyePosition;
@property (nonatomic, readonly) CGPoint rightEyePosition;
@property (nonatomic, readonly) CGPoint mouthPosition;

-(id)initWithUIImage:(UIImage*)image limitSize:(CGRect)boundBox;
- (UIImage*)getScaledImage;
- (UIImage*)getOriginalImage;
-(void)detectorFacefromPhoto:(CIImage *)photo;

@end
