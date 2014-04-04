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

@property (strong, nonatomic) JDVBall *ball;
@property (strong, nonatomic) CMMotionManager *motionManager;

@end

@implementation JDVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.ball = [self newBall];
    [self.view addSubview:self.ball];
    self.hole.layer.cornerRadius = self.hole.frame.size.width / 2;
    [self startAccelerometer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return TRUE;
}

- (JDVBall *)newBall
{
    JDVBall *newBall = [[JDVBall alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    newBall.center = CGPointMake(34, self.view.frame.size.height - 34);
    newBall.backgroundColor = [UIColor redColor];
    newBall.layer.cornerRadius = newBall.frame.size.width / 2;
    return newBall;
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
    if (CGRectContainsRect(self.hole.frame, self.ball.frame)) {
        [self.ball removeFromSuperview];
        [[[UIAlertView alloc] initWithTitle:@"TA DA"
                                    message:@"You Win!"
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:nil] show];
    }
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
