//
//  JDVViewController.m
//  JDVLabyrinth
//
//  Created by sonique on 4/3/14.
//  Copyright (c) 2014 JDV. All rights reserved.
//

#import "JDVViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "JDVBall.h"

static const double kJDVFriction = 0.97;

@interface JDVViewController ()

@property (strong, nonatomic) NSArray *walls;
@property (strong, nonatomic) JDVBall *ball;
@property (strong, nonatomic) CMMotionManager *motionManager;

@end

@implementation JDVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addWalls];
    [self addBall];
    self.hole.layer.cornerRadius = self.hole.frame.size.width / 2;
    [self addMotionManager];
}

- (BOOL)prefersStatusBarHidden
{
    return TRUE;
}

- (void)addWalls
{
    NSMutableArray *mutableWalls = [NSMutableArray array];
    for (UIView *view in self.view.subviews) {
        if (view.tag == 1) {
            [mutableWalls addObject:view];
        }
    }
    self.walls = [NSArray arrayWithArray:mutableWalls];
}

- (void)addBall
{
    self.ball = [[JDVBall alloc] initWithFrame:CGRectMake(20, 510, 34, 34)];
    [self.view addSubview:self.ball];
}

- (void)addMotionManager
{
    self.motionManager = [[CMMotionManager alloc] init];
    [self.motionManager setAccelerometerUpdateInterval:0.04];
    NSOperationQueue *operationQueue = [NSOperationQueue mainQueue];
    CMAccelerometerHandler handler = ^(CMAccelerometerData *accelerometerData, NSError *error){
        double xAccel = accelerometerData.acceleration.x;
        double yAccel = accelerometerData.acceleration.y;
        self.ball.xVelocity += xAccel;
        self.ball.yVelocity += (-1 * yAccel);
        [self moveBall];
    };
    [self.motionManager startAccelerometerUpdatesToQueue:operationQueue withHandler:handler];
}

- (void)moveBall
{
    [self applyFrictionToBall];
    double movementSteps = [self.ball greatestDirectionalVelocity];
    while (movementSteps > 0) {
        double step = fmin(movementSteps, 1);
        [self stepBallInDirectionOfGreaterVelocityByStep:step];
        [self checkForCollisionInDirectionOfGreaterVelocity];
        [self stepBallInDirectionOfLesserVelocityByStep:step];
        [self checkForCollisionInDirectionOfLesserVelocity];
        if ([self gameIsOver]) {
            [self.motionManager stopAccelerometerUpdates];
            [self.ball removeFromSuperview];
            [[[UIAlertView alloc] initWithTitle:@"TA DA"
                                        message:@"You Win!"
                                       delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:nil] show];
            break;
        }
        movementSteps -= step;
    }
}

- (void)applyFrictionToBall
{
    self.ball.xVelocity *= kJDVFriction;
    self.ball.yVelocity *= kJDVFriction;
}

- (void)stepBallInDirectionOfGreaterVelocityByStep:(double)step
{
    if (fabs(self.ball.xVelocity) > fabs(self.ball.yVelocity)) {
        if (self.ball.xVelocity < 0) {
            step *= -1;
        }
        self.ball.center = CGPointMake(self.ball.center.x + step, self.ball.center.y);
    } else {
        if (self.ball.yVelocity < 0) {
            step *= -1;
        }
        self.ball.center = CGPointMake(self.ball.center.x, self.ball.center.y + step);
    }
}

- (void)stepBallInDirectionOfLesserVelocityByStep:(double)step
{
    if (fabs(self.ball.xVelocity) <= fabs(self.ball.yVelocity)) {
        if (self.ball.xVelocity < 0) {
            step *= -1;
        }
        double xDelta = (fabs(self.ball.xVelocity / self.ball.yVelocity) * step);
        self.ball.center = CGPointMake(self.ball.center.x + xDelta, self.ball.center.y);
    } else {
        if (self.ball.yVelocity < 0) {
            step *= -1;
        }
        double yDelta = (fabs(self.ball.yVelocity / self.ball.xVelocity) * step);
        self.ball.center = CGPointMake(self.ball.center.x, self.ball.center.y + yDelta);
    }
}

- (void)checkForCollisionInDirectionOfGreaterVelocity
{
    for (UIView *wall in self.walls) {
        if (CGRectIntersectsRect(self.ball.frame, wall.frame)) {
            if (fabs(self.ball.xVelocity) > fabs(self.ball.yVelocity)) {
                double centerX;
                if (self.ball.xVelocity > 0) {
                    centerX = wall.frame.origin.x - (self.ball.frame.size.width / 2);
                } else {
                    centerX = (wall.frame.origin.x + wall.frame.size.width) + (self.ball.frame.size.width / 2);
                }
                self.ball.center = CGPointMake(centerX, self.ball.center.y);
                self.ball.xVelocity *= -1;
            } else {
                double centerY;
                if (self.ball.yVelocity > 0) {
                    centerY = wall.frame.origin.y - (self.ball.frame.size.height / 2);
                } else {
                    centerY = (wall.frame.origin.y + wall.frame.size.height) + (self.ball.frame.size.height / 2);
                }
                self.ball.center = CGPointMake(self.ball.center.x, centerY);
                self.ball.yVelocity *= -1;
            }
        }
    }
}

- (void)checkForCollisionInDirectionOfLesserVelocity
{
    for (UIView *wall in self.walls) {
        if (CGRectIntersectsRect(self.ball.frame, wall.frame)) {
            if (fabs(self.ball.xVelocity) <= fabs(self.ball.yVelocity)) {
                double centerX;
                if (self.ball.xVelocity > 0) {
                    centerX = wall.frame.origin.x - (self.ball.frame.size.width / 2);
                } else {
                    centerX = (wall.frame.origin.x + wall.frame.size.width) + (self.ball.frame.size.width / 2);
                }
                self.ball.center = CGPointMake(centerX, self.ball.center.y);
                self.ball.xVelocity *= -1;
            } else {
                double centerY;
                if (self.ball.yVelocity > 0) {
                    centerY = wall.frame.origin.y - (self.ball.frame.size.height / 2);
                } else {
                    centerY = (wall.frame.origin.y + wall.frame.size.height) + (self.ball.frame.size.height / 2);
                }
                self.ball.center = CGPointMake(self.ball.center.x, centerY);
                self.ball.yVelocity *= -1;
            }
        }
    }
}

- (BOOL)gameIsOver
{
    if (CGRectContainsRect(self.hole.frame, self.ball.frame)) {
        return TRUE;
    }
    return FALSE;
}

@end
