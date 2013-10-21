//
//  ComplexModel.h
//  AGModelStarterDemo
//
//  Created by Adrian Geana on 10/21/13.
//  Copyright (c) 2013 Adrian Geana. All rights reserved.
//

#import "AGModelStarter.h"

@interface ComplexModel : AGModelStarter

@property (nonatomic, strong) NSArray *list;
@property (nonatomic, assign) BOOL booleanValue;
@property (nonatomic, assign) int intValue;
@property (nonatomic, assign) CGPoint pointValue;
@property (nonatomic, strong) NSString *stringValue;
@property (nonatomic, strong) NSNumber *numberValue;
@property (nonatomic, strong) NSURL *urlValue;
@property (nonatomic, readonly) BOOL isListEmpty;
@property (nonatomic, strong) UIImage *image;

@end