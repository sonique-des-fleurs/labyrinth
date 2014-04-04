//
//  JDVBall.h
//  JDVLabyrinth
//
//  Created by sonique on 4/3/14.
//  Copyright (c) 2014 JDV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDVBall : UIView

- (void)updateVelocityWithAccelerationX:(double)xAcceleration
                          accelerationY:(double)yAcceleration;
- (void)updatePosition;

@end
