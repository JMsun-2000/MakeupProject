//
//  FaceDataManager.h
//  MarkupProject
//
//  Created by Sun Jimmy on 7/13/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageFaceDetectorUtils.h"

@interface FaceDataManager : NSObject
@property (nonatomic, strong) ImageFaceDetectorUtils *faceDetector;

+(FaceDataManager*)getInstance;
-(void)initWithUIImage:(UIImage*)image limitSize:(CGRect)boundBox;
-(UIImage*)getLeftEye:(CGRect)boundBox ScaleType:(int)scaleType;
-(NSArray*)getLeftEyePoints;
@end
