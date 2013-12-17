//
//  AGModelStarter.m
//  AGModelStarterDemo
//
//  Created by Adrian Geana on 10/21/13.
//  Copyright (c) 2013 Adrian Geana. All rights reserved.
//


#import <objc/runtime.h>
#import "AGModelStarter.h"


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

// From here : http://stackoverflow.com/a/8380836/450896
static const char * getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            return "";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "";
}

-(NSArray *)allPropertyNames {
    Class objectClass = [self class];
    u_int count = 0;
    objc_property_t* properties = class_copyPropertyList(objectClass, &count);
    NSMutableArray *allProperties = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++) {
        const char *propertyName = property_getName(properties[i]);
        [allProperties addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
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
        NSString *popertyAttributes = [NSString stringWithCString:property_getAttributes(properties[i])
                                                          encoding:NSUTF8StringEncoding];
        if([popertyAttributes rangeOfString:@",R,"].location == NSNotFound) {
            [allProperties addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        }
    }
    free(properties);
    return [allProperties copy];
}

-(BOOL)hasPropertyNamed:(NSString *)property {
    return [[self allPropertyNames] containsObject:property];
}

-(Class)classOfPropertyNamed:(NSString *)property {
    if(![self hasPropertyNamed:property]) {
        return nil;
    }
    Class objectClass = [self class];
    u_int count = 0;
    objc_property_t* properties = class_copyPropertyList(objectClass, &count);
    for (int i = 0; i < count ; i++) {
        const char *propertyName = property_getName(properties[i]);
        if([[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding] isEqualToString:property]) {
            NSString *className = [NSString stringWithCString:getPropertyType(properties[i])
                                                     encoding:NSUTF8StringEncoding];
            if(![className isEqualToString:@"id"] && ![className isEqualToString:@""]) {
                return NSClassFromString(className);
            }
        }
    }
    return nil;
}

@end

