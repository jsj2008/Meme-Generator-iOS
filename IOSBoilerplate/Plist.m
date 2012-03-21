//
//  Plist.m
//  IOSBoilerplate
//
//  Created by Lee Wei Yeong on 21/03/2012.
//  Copyright (c) 2012 IC. All rights reserved.
//

#import "Plist.h"

@implementation Plist
+ (id)readPlist:(NSString *)fileName {
    NSData *plistData;
    NSString *error;
    NSPropertyListFormat format;
    id plist;
    NSString *localizedPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    plistData = [NSData dataWithContentsOfFile:localizedPath];
    plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
    if (!plist) {
        NSLog(@"Error reading plist from file '%s', error = '%s'", [localizedPath UTF8String], [error UTF8String]);
        [error release];
    }
    return plist;
}
+ (NSArray *)getArray:(NSString *)fileName {
    return (NSArray *)[self readPlist:fileName];
}
+ (NSDictionary *)getDictionary:(NSString *)fileName {
    return (NSDictionary *)[self readPlist:fileName];
}
+ (void)writePlist:(id)plist fileName:(NSString *)fileName {
    NSData *xmlData;
    NSString *error;
    NSString *localizedPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    xmlData = [NSPropertyListSerialization dataFromPropertyList:plist format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    if (xmlData) {
        [xmlData writeToFile:localizedPath atomically:YES];
    } else {
        NSLog(@"Error writing plist to file '%s', error = '%s'", [localizedPath UTF8String], [error UTF8String]);
        [error release];
    }
}
@end
