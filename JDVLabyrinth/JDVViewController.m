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

- (void)addMotionManager
{
    self.motionManager = [[CMMotionManager alloc] init];
    [self.motionManager setAccelerometerUpdateInterval:0.04];
    NSOperationQueue *operationQueue = [NSOperationQueue mainQueue];
    CMAccelerometerHandler handler = ^(CMAccelerometerData *accelerometerData, NSError *error){
        double xAccel = accelerometerData.acceleration.x;
        double yAccel = accelerometerData.acceleration.y;
        NSLog(@"handled accelerometer data: %f, %f", xAccel, yAccel);
        self.ball.xVelocity += xAccel;
        self.ball.yVelocity += (-1 * yAccel);
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
