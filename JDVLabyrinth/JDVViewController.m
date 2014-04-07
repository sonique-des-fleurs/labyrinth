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

static double const kJDVAccelerationScalingFactor = 0.25;

@interface JDVViewController ()

@property (strong, nonatomic) NSArray *walls;
@property (strong, nonatomic) CMMotionManager *motionManager;

@end

@implementation JDVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self addWalls];
    [self startAccelerometer];
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

- (void)startAccelerometer
{
    self.motionManager = [[CMMotionManager alloc] init];
    [self.motionManager setAccelerometerUpdateInterval:0.04];
    NSOperationQueue *operationQueue = [NSOperationQueue mainQueue];
    CMAccelerometerHandler handler = ^(CMAccelerometerData *accelerometerData, NSError *error){
        NSLog(@"handled accelerometer data: %f, %f", accelerometerData.acceleration.x, accelerometerData.acceleration.y);
        [self.ball updateVelocityWithAccelerationX:accelerometerData.acceleration.x * kJDVAccelerationScalingFactor
                                     accelerationY:accelerometerData.acceleration.y * kJDVAccelerationScalingFactor];
        [self.ball updatePosition];
        [self checkForWin];
        [self checkForCollision];
    };
    [self.motionManager startAccelerometerUpdatesToQueue:operationQueue withHandler:handler];
}

- (void)checkForWin
{
//    if (CGRectContainsRect(self.hole.frame, self.ball.frame)) {
//        [self.ball removeFromSuperview];
//        [[[UIAlertView alloc] initWithTitle:@"TA DA"
//                                    message:@"You Win!"
//                                   delegate:nil
//                          cancelButtonTitle:nil
//                          otherButtonTitles:nil] show];
//    }
}

- (void)checkForCollision
{
    for (UIView *edge in self.view.subviews) {
        if ([edge isKindOfClass:[JDVBall class]] || edge.tag == 3) {
            continue;
        }
        if (CGRectIntersectsRect(self.ball.frame, edge.frame)) {
            [self.ball processCollisionWithEdge:edge];
        }
    }
}

@end
