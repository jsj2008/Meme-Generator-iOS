//
//  NSURLConnectionWithTag.m
//  IOSBoilerplate
//
//  Created by Lee Wei Yeong on 21/03/2012.
//  Copyright (c) 2012 IC. All rights reserved.
//

#import "NSURLConnectionWithTag.h"

@implementation NSURLConnectionWithTag

@synthesize tag;

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately tag:(NSNumber*)_tag {
    self = [super initWithRequest:request delegate:delegate startImmediately:startImmediately];
    if (self) {
        self.tag = _tag;
    }
    return self;
}
@end
