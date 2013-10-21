//
//  AGModelStarter.m
//  AGModelStarterDemo
//
//  Created by Adrian Geana on 10/21/13.
//  Copyright (c) 2013 Adrian Geana. All rights reserved.
//

#import "AGModelStarter.h"
#import <objc/runtime.h>

@interface NSObject(AGPropertyUtils)
-(NSArray *)allPropertyNames;
-(NSArray *)allNonReadOnlyPropertyNames;
@end

@implementation AGModelStarter

-(id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]) {
        for(NSString *property in [self allNonReadOnlyPropertyNames]) {
            [self setValue:[aDecoder decodeObjectForKey:property]
                    forKey:property];
        }
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    for(NSString *property in [self allNonReadOnlyPropertyNames]) {
        [aCoder encodeObject:[self valueForKey:property] forKey:property];
    }
}

-(id)copyWithZone:(NSZone *)zone {
    id copy = [[self class] allocWithZone:zone];
    for(NSString *property in [self allNonReadOnlyPropertyNames]) {
        [copy setValue:[[self valueForKey:property] copyWithZone:zone]
                forKey:property];
    }
    return copy;
}

-(NSString *)description {
    NSString *desc = [super description];
    for(NSString *property in [self allPropertyNames]) {
        desc = [NSString stringWithFormat:@"%@\n%@ = %@",
                desc,
                property,
                [[self valueForKey:property] description]];
    }
    return desc;
}

-(BOOL)isEqual:(id)object {
    
    if(![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    for(NSString *property in [self allPropertyNames]) {
        if(![[self valueForKey:property] isEqual:[object valueForKey:property]]) {
            return NO;
        }
    }
    
    return YES;
}

@end

@implementation NSObject(AGPropertyUtils)

-(NSArray *)allPropertyNames {
    Class objectClass = [self class];
    u_int count = 0;
    objc_property_t* properties = class_copyPropertyList(objectClass, &count);
    NSMutableArray *allProperties = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++) {
        const char *propertyName = property_getName(properties[i]);
        [allProperties addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
    return [allProperties copy];
}

-(NSArray *)allNonReadOnlyPropertyNames {
    Class objectClass = [self class];
    u_int count = 0;
    objc_property_t* properties = class_copyPropertyList(objectClass, &count);
    NSMutableArray *allProperties = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++) {
        const char *propertyName = property_getName(properties[i]);
        NSString *popertyAttributes = [NSString  stringWithCString:property_getAttributes(properties[i])
                                                          encoding:NSUTF8StringEncoding];
        if([popertyAttributes rangeOfString:@",R,"].location == NSNotFound) {
            [allProperties addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        }
    }
    free(properties);
    return [allProperties copy];
}

@end

