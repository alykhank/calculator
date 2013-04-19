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
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _origin.x = [defaults floatForKey:@"origin.x"];
        _origin.y = [defaults floatForKey:@"origin.y"];
        if (!_origin.x) _origin.x = DEFAULT_ORIGIN_X;
        if (!_origin.y) _origin.y = DEFAULT_ORIGIN_Y;
    }
    return _origin;
}

- (void)setOrigin:(CGPoint)origin
{
    if (_origin.x != origin.x || _origin.y != origin.y) {
        _origin = origin;
        [self setNeedsDisplay];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setFloat:_origin.x forKey:@"origin.x"];
        [defaults setFloat:_origin.y forKey:@"origin.y"];
    }
}

- (CGFloat)scale
{
    if (!_scale) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _scale = [defaults floatForKey:@"scale"];
        if (!_scale) _scale = DEFAULT_SCALE;
    }
    return _scale;
}

- (void)setScale:(CGFloat)scale
{
    if (_scale != scale) {
        _scale = scale;
        [self setNeedsDisplay];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setFloat:_scale forKey:@"scale"];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint origin = self.origin;
    CGFloat scale = self.scale;
    
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:origin scale:scale];
    
    CGContextSetLineWidth(context, 1);
    [[UIColor blueColor] setStroke];
    [[UIColor blueColor] setFill];
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.bounds.origin.x, origin.y - [self.dataSource yValueForGraphView:self withXValue:(self.bounds.origin.x - origin.x) / scale] * scale);
    
    if (self.contentScaleFactor == 2.0)
    {
        for (float i = self.bounds.origin.x; i <= self.bounds.size.width; i += 0.5)
        {
            if ([self.dataSource drawingStyle])
                CGContextAddLineToPoint(context, i, origin.y - [self.dataSource yValueForGraphView:self withXValue:(i - origin.x) / scale] * scale);
            else
                CGContextFillRect(context, CGRectMake(i - 1, origin.y - [self.dataSource yValueForGraphView:self withXValue:(i - origin.x) / scale] * scale - 1, 2, 2));
        }
    }
    else
    {
        for (float i = self.bounds.origin.x; i <= self.bounds.size.width; i++)
        {
            if ([self.dataSource drawingStyle])
                CGContextAddLineToPoint(context, i, origin.y - [self.dataSource yValueForGraphView:self withXValue:(i - origin.x) / scale] * scale);
            else
                CGContextFillRect(context, CGRectMake(i - 1, origin.y - [self.dataSource yValueForGraphView:self withXValue:(i - origin.x) / scale] * scale - 1, 2, 2));
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

- (void)tap:(UITapGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded)) {
        self.origin = [gesture locationInView:self];
    }
}

@end
