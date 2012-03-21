//
//  NSURLConnectionWithTag.h
//  IOSBoilerplate
//
//  Created by Lee Wei Yeong on 21/03/2012.
//  Copyright (c) 2012 IC. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSURLConnectionWithTag : NSURLConnection;
@property (nonatomic, retain) NSNumber *tag;
- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately tag:(NSNumber*)_tag;
@end
