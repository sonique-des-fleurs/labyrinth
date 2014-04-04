//
//  JDVBall.m
//  JDVLabyrinth
//
//  Created by sonique on 4/3/14.
//  Copyright (c) 2014 JDV. All rights reserved.
//

#import "JDVBall.h"

@interface JDVBall ()

@property (assign, nonatomic) double xVelocity;
@property (assign, nonatomic) double yVelocity;

@end

@implementation JDVBall

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _xVelocity = 0.0;
        _yVelocity = 0.0;
    }
    return self;
}

- (void)updateVelocityWithAccelerationX:(double)xAcceleration
                          accelerationY:(double)yAcceleration
{
    self.xVelocity += xAcceleration;
    self.yVelocity += yAcceleration;
}

- (void)updatePosition
{
    double centerX = self.center.x + self.xVelocity;
    double centerY = self.center.y - self.yVelocity;
    self.center = CGPointMake(centerX, centerY);
}

- (void)processCollisionWithEdge:(UIView *)edge
{
    [self flushWithEdge:edge];
    if (edge.tag == 1) {
        self.xVelocity *= -1;
    }
    if (edge.tag == 2) {
        self.yVelocity *= -1;
    }
}

- (void)flushWithEdge:(UIView *)edge
{
    if (edge.tag == 1) {
        double centerX;
        if (self.xVelocity >= 0) {
            centerX = edge.frame.origin.x - (self.frame.size.width / 2);
        } else {
            centerX = (edge.frame.origin.x + edge.frame.size.width) + (self.frame.size.width / 2);
        }
        self.center = CGPointMake(centerX, self.center.y);
    }
    
    if (edge.tag == 2) {
        double centerY;
        if (self.yVelocity >= 0) {
            centerY = (edge.frame.origin.y + edge.frame.size.height) + (self.frame.size.height / 2);
        } else {
            centerY = edge.frame.origin.y - (self.frame.size.height / 2);
        }
        self.center = CGPointMake(self.center.x, centerY);
    }
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
