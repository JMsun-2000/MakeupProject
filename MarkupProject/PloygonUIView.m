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
@property (nonatomic) UIBezierPath* curBezierPath;
@end

CGFloat BEZIER_FACTOR1 = 0.25f;
CGFloat BEZIER_FACTOR2 = 0.3f;

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

-(UIBezierPath*)getCurPath
{
    return self.curBezierPath;
}


-(void)dealloc
{
    if (_curPolygonPoints != nil){
        // release the old one
        [_curPolygonPoints release];
    }
    
    if (_curBezierPath  != nil){
        [self.curBezierPath release];
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
 
    // release old one
    if (self.curBezierPath != nil){
        [self.curBezierPath release];
    }
    self.curBezierPath = [[UIBezierPath bezierPath] retain];

    CGPoint pervious;
    int pointCnt = [self.curPolygonPoints count];
    for (int i = 0; i <= pointCnt; i++){
        // it's a polygon. So must add bezier for the last point line to begin, or it will be straight line by system automatically
        CGPoint p = [[self.curPolygonPoints objectAtIndex:(i%pointCnt)] CGPointValue];
        if (i == 0){
            [self.curBezierPath moveToPoint:CGPointMake(p.x, p.y)];
        }
        else{
            // add Curve
            CGFloat xOffset = (p.x - pervious.x);
            CGFloat yOffset = (p.y - pervious.y);
            
            // check the quadrant
            if (xOffset*yOffset < 0.0f){
                xOffset *= BEZIER_FACTOR2;
                [self.curBezierPath addCurveToPoint:p controlPoint1:CGPointMake(pervious.x+xOffset, p.y)  controlPoint2:CGPointMake(p.x-xOffset, p.y)];
            }
            else{
                xOffset *= BEZIER_FACTOR1;
                [self.curBezierPath addCurveToPoint:p controlPoint1:CGPointMake(pervious.x+xOffset, pervious.y)  controlPoint2:CGPointMake(p.x-xOffset,  pervious.y)];
            }

        }
        pervious = p;
    }   
    
    [self.curBezierPath fill];
    
}


@end
