//
//  JDVBall.h
//  JDVLabyrinth
//
//  Created by sonique on 4/3/14.
//  Copyright (c) 2014 JDV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDVBall : UIView

@property (assign, nonatomic) double xVelocity;
@property (assign, nonatomic) double yVelocity;

- (double)greatestDirectionalVelocity;
- (void)stepInDirectionOfGreaterVelocityByFractionalStep:(double)fractionOfStep;
- (void)stepInDirectionOfLesserVelocityByFractionalStep:(double)fractionOfStep;

- (void)processCollisionWithEdge:(UIView *)edge;

@end
