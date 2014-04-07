//
//  JDVBall.m
//  JDVLabyrinth
//
//  Created by sonique on 4/3/14.
//  Copyright (c) 2014 JDV. All rights reserved.
//

#import "JDVBall.h"

static double const kJDVMaxVelocity = 20;

@interface JDVBall ()

@end

@implementation JDVBall

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _xVelocity = 0;
        _yVelocity = 0;
        self.backgroundColor = [UIColor redColor];
        self.layer.cornerRadius = self.frame.size.width / 2;
    }
    return self;
}

- (void)setXVelocity:(double)velocity
{
    _xVelocity = fmax(-1 * kJDVMaxVelocity, velocity);
    _xVelocity = fmin(_xVelocity, kJDVMaxVelocity);
}

- (void)setYVelocity:(double)velocity
{
    _yVelocity = fmax(-1 * kJDVMaxVelocity, velocity);
    _yVelocity = fmin(_yVelocity, kJDVMaxVelocity);
}

- (double)greatestDirectionalVelocity
{
    if (fabs(self.xVelocity) > fabs(self.yVelocity)) {
        return fabs(self.xVelocity);
    } else {
        return fabs(self.yVelocity);
    }
}

- (void)stepInDirectionOfGreaterVelocityByFractionalStep:(double)fractionOfStep
{
    if (fabs(self.xVelocity) > fabs(self.yVelocity)) {
        if (self.xVelocity < 0) {
            fractionOfStep *= -1;
        }
        self.center = CGPointMake(self.center.x + fractionOfStep, self.center.y);
    } else {
        if (self.yVelocity < 0) {
            fractionOfStep *= -1;
        }
        self.center = CGPointMake(self.center.x, self.center.y + fractionOfStep);
    }
}

- (void)stepInDirectionOfLesserVelocityByFractionalStep:(double)fractionOfStep
{
    if (fabs(self.xVelocity) <= fabs(self.yVelocity)) {
        if (self.xVelocity < 0) {
            fractionOfStep *= -1;
        }
        double xDelta = (fabs(self.xVelocity / self.yVelocity) * fractionOfStep);
        self.center = CGPointMake(self.center.x + xDelta, self.center.y);
    } else {
        if (self.yVelocity < 0) {
            fractionOfStep *= -1;
        }
        double yDelta = (fabs(self.yVelocity / self.xVelocity) * fractionOfStep);
        self.center = CGPointMake(self.center.x, self.center.y + yDelta);
    }
}

@end
