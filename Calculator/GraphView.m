//
//  GraphView.m
//  Calculator
//
//  Created by alykhan.kanji on 16/04/13.
//  Copyright (c) 2013 Alykhan Kanji. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

@synthesize dataSource = _dataSource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint origin;
    origin.x = self.bounds.origin.x + self.bounds.size.width / 2.0;
    origin.y = self.bounds.origin.y + self.bounds.size.height / 2.0;
    
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:origin scale:1.0];
    
    CGFloat minimumX;
    minimumX = self.bounds.origin.x - origin.x;
    CGFloat maximumX;
    maximumX = self.bounds.size.width - origin.x;
    
    CGContextSetLineWidth(context, 1);
    [[UIColor blueColor] setStroke];
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, origin.x + minimumX, origin.y - [self.dataSource yValueForGraphView:self withXValue:minimumX]);
    
    if (self.contentScaleFactor == 2.0)
    {
        for (float i = minimumX; i <= maximumX; i += 0.5)
        {
//            NSLog(@"Mathematical X: %f Y: %f", i, [self.dataSource yValueForGraphView:self withXValue:i]);
//            NSLog(@"Drawing X: %f Y: %f", origin.x + i, origin.y - [self.dataSource yValueForGraphView:self withXValue:i]);
            CGContextAddLineToPoint(context, origin.x + i, origin.y - [self.dataSource yValueForGraphView:self withXValue:i]);
        }
    }
    else
    {
        for (float i = minimumX; i <= maximumX; i++)
        {
//            NSLog(@"Mathematical X: %f Y: %f", i, [self.dataSource yValueForGraphView:self withXValue:i]);
//            NSLog(@"Drawing X: %f Y: %f", origin.x + i, origin.y - [self.dataSource yValueForGraphView:self withXValue:i]);
            CGContextAddLineToPoint(context, origin.x + i, origin.y - [self.dataSource yValueForGraphView:self withXValue:i]);
        }
    }
    
    CGContextStrokePath(context);
}

@end
