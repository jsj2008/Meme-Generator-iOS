//
//  Plist.h
//  IOSBoilerplate
//
//  Created by Lee Wei Yeong on 21/03/2012.
//  Copyright (c) 2012 IC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Plist : NSObject
+ (id)readPlist:(NSString *)fileName;
+ (NSArray *)getArray:(NSString *)fileName;
+ (NSDictionary *)getDictionary:(NSString *)fileName;
+ (void)writePlist:(id)plist fileName:(NSString *)fileName;
@end
