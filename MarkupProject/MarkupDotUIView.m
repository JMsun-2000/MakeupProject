//
//  MarkupDotUIView.m
//  MarkupProject
//
//  Created by Sun Jimmy on 7/16/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import "MarkupDotUIView.h"
#import "FacialOrgansViewController.h"

@implementation MarkupDotUIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"point" ofType:@"png"];
        UIImage * image = [[UIImage alloc] initWithContentsOfFile:imagePath];
        self.backgroundColor = [UIColor colorWithPatternImage:image];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	
	// If the touch was in the view, move the dot view to its location
	if ([touch view] == self) {
		CGPoint location = [touch locationInView:self.superview];
		self.center = location;
       
        FacialOrgansViewController* controller = (FacialOrgansViewController*)[self getParentViewController];
        if (controller != nil){
            // Do callback
            [controller reDrawPolygon];
        }
        
		return;
	}
}

- (UIViewController*)getParentViewController{
    for (UIView* next = [self superview]; next; next = next.superview){
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]){
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
