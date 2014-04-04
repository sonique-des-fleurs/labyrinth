//
//  JDVViewController.m
//  JDVLabyrinth
//
//  Created by sonique on 4/3/14.
//  Copyright (c) 2014 JDV. All rights reserved.
//

#import "JDVViewController.h"

@interface JDVViewController ()

@property (strong, nonatomic) UIView *ball;

@end

@implementation JDVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self createBall];
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

- (void)createBall
{
    UIView *newBall = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    newBall.center = self.view.center;
    newBall.backgroundColor = [UIColor redColor];
    newBall.layer.cornerRadius = newBall.frame.size.width / 2;
    [self.view addSubview:newBall];
}

@end
