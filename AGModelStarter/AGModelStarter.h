//
//  AGModelStarter.h
//  AGModelStarterDemo
//
//  Created by Adrian Geana on 10/21/13.
//  Copyright (c) 2013 Adrian Geana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(AGPropertyUtils)
-(NSArray *)allPropertyNames;
-(NSArray *)allNonReadOnlyPropertyNames;
-(BOOL)hasPropertyNamed:(NSString *)property;
-(Class)classOfPropertyNamed:(NSString *)property;
@end

@interface AGModelStarter : NSObject <NSCopying, NSCoding>

@end
