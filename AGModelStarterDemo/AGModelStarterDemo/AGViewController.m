//
//  AGViewController.m
//  AGModelStarterDemo
//
//  Created by Adrian Geana on 10/21/13.
//  Copyright (c) 2013 Adrian Geana. All rights reserved.
//

#import "AGViewController.h"
#import "ComplexModel.h"


@implementation AGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ComplexModel *model = [[ComplexModel alloc] init];
    model.list = @[@1, @2, @3];
    model.intValue = 15;
    model.booleanValue = YES;
    model.pointValue = CGPointMake(15, 20.3);
    model.stringValue = @"Great string right there";
    model.numberValue = @144;
    model.urlValue = [NSURL URLWithString:[NSString stringWithFormat:@"https://moqups.com"]];
    model.image = [UIImage imageNamed:@"sample.jpeg"];
    
    NSLog(@"description : %@", model);
    ComplexModel *copy = [model copy];
    
    NSLog(@"description of copy : %@", copy);
    
    NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:model];
    NSLog(@"description of archive %@", [NSKeyedUnarchiver unarchiveObjectWithData:archive]);
    
    NSLog(@"isEqualCopy %d ", [model isEqual:copy]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
