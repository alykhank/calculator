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

@synthesize origin = _origin;
@synthesize scale = _scale;
@synthesize dataSource = _dataSource;

#define DEFAULT_SCALE 20.0
#define DEFAULT_ORIGIN_X self.bounds.origin.x + self.bounds.size.width / 2.0
#define DEFAULT_ORIGIN_Y self.bounds.origin.y + self.bounds.size.height / 2.0

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGPoint)origin
{
    if (!_origin.x || !_origin.y) {
        return CGPointMake(DEFAULT_ORIGIN_X, DEFAULT_ORIGIN_Y);
    } else {
        return _origin;
    }
}

- (void)setOrigin:(CGPoint)origin
{
    if (_origin.x != origin.x || _origin.y != origin.y) {
        _origin = origin;
        [self setNeedsDisplay];
    }
}

- (CGFloat)scale
{
    if (!_scale) {
        return DEFAULT_SCALE;
    } else {
        return _scale;
    }
}

- (void)setScale:(CGFloat)scale
{
    if (_scale != scale) {
        _scale = scale;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint origin = self.origin;
    CGFloat scale = self.scale;
    
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:origin scale:scale];
    
    CGFloat minimumX = (self.bounds.origin.x - origin.x) / scale;
    CGFloat maximumX = (self.bounds.size.width - origin.x) / scale;
    
    CGContextSetLineWidth(context, 1);
    [[UIColor blueColor] setStroke];
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, origin.x + minimumX * scale, origin.y - [self.dataSource yValueForGraphView:self withXValue:minimumX] * scale);
    
    if (self.contentScaleFactor == 2.0)
    {
        for (float i = minimumX; i <= maximumX + 0.5; i += 0.5)
        {
//            NSLog(@"Mathematical X: %f Y: %f", i, [self.dataSource yValueForGraphView:self withXValue:i]);
//            NSLog(@"Drawing X: %f Y: %f", origin.x + i, origin.y - [self.dataSource yValueForGraphView:self withXValue:i]);
            CGContextAddLineToPoint(context, origin.x + i * scale, origin.y - [self.dataSource yValueForGraphView:self withXValue:i] * scale);
        }
    }
    else
    {
        for (float i = minimumX; i <= maximumX + 1; i++)
        {
//            NSLog(@"Mathematical X: %f Y: %f", i, [self.dataSource yValueForGraphView:self withXValue:i]);
//            NSLog(@"Drawing X: %f Y: %f", origin.x + i, origin.y - [self.dataSource yValueForGraphView:self withXValue:i]);
            CGContextAddLineToPoint(context, origin.x + i * scale, origin.y - [self.dataSource yValueForGraphView:self withXValue:i] * scale);
        }
    }
    
    CGContextStrokePath(context);
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self];
        self.origin = CGPointMake(self.origin.x + translation.x, self.origin.y + translation.y);
        [gesture setTranslation:CGPointZero inView:self];
    }
}

@end
