//
//  ploygonUIView.m
//  MarkupProject
//
//  Created by Sun Jimmy on 7/13/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import "PloygonUIView.h"

@interface PloygonUIView()
@property (nonatomic) NSArray* curPolygonPoints;
@end

@implementation PloygonUIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(void)setPolygonPoints:(NSArray*)points
{
    if (_curPolygonPoints != nil){
        // release the old one
        [_curPolygonPoints release];
    }
    
    _curPolygonPoints = [points retain];
}

-(void)dealloc
{
    if (_curPolygonPoints != nil){
        // release the old one
        [_curPolygonPoints release];
    }
    [super dealloc];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    UIColor *stellBlueColor = [UIColor colorWithRed:0.3f green:0.4f blue:0.6f alpha:0.5f];
    CGContextSetFillColorWithColor(currentContext, [stellBlueColor CGColor]);
 
    UIBezierPath* path = [UIBezierPath bezierPath];
    CGPoint pervious;
    for (int i = 0; i < [self.curPolygonPoints count]; i++){
        CGPoint p = [[self.curPolygonPoints objectAtIndex:i] CGPointValue];
        if (i == 0){
            [path moveToPoint:CGPointMake(p.x, p.y)];
        }
        else{
            // add Curve
            [path addQuadCurveToPoint:CGPointMake(p.x, p.y) controlPoint:CGPointMake((pervious.x + p.x)/2.0f - 50, (pervious.y + p.y)/2.0f - 50)];
            [path addLineToPoint:CGPointMake(p.x, p.y)];
        }
        
        pervious = p;
    }
    
    
 //   [path addQuadCurveToPoint:CGPointMake(160.0, 140.0) controlPoint:CGPointMake(300.0, 90.0)];
 //   [path addLineToPoint:CGPointMake(160.0, 140.0)];
 //   [path addLineToPoint:CGPointMake(40.0, 140.0)];
 //   [path addLineToPoint:CGPointMake(0.0, 40.0)];
    [path closePath];
    
    
    [path fill];
    
 /*
    CGMutablePathRef path = CGPathCreateMutable();
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, 20, 20);
    CGContextAddLineToPoint(currentContext, 30, 40);
    CGContextAddLineToPoint(currentContext, 130, 140);
     CGContextAddLineToPoint(currentContext, 130, 30);
     CGContextAddLineToPoint(currentContext, 30, 30);
    CGContextClosePath(currentContext);
    
    CGContextAddPath(currentContext, path);
 
    UIColor *stellBlueColor = [UIColor colorWithRed:0.3f green:0.4f blue:0.6f alpha:0.5f];
    CGContextSetFillColorWithColor(currentContext, [stellBlueColor CGColor]);
    CGContextFillPath(currentContext);
    CGPathRelease(path);
    */ 
}


@end
