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
    if (edge.tag == 1) {
        self.xVelocity *= -1;
    }
    if (edge.tag == 2) {
        self.yVelocity *= -1;
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
