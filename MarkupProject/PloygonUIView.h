//
//  ploygonUIView.h
//  MarkupProject
//
//  Created by Sun Jimmy on 7/13/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PloygonUIView : UIView{
}

-(void)setPolygonPoints:(NSArray*)points;
-(UIBezierPath*)getCurPath;
@end
