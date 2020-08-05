//
//  sbXPC.m
//  sbXPC
//
//  Created by 李玉峰 on 2020/8/5.
//  Copyright © 2020 李玉峰. All rights reserved.
//

#import "sbXPC.h"

@implementation sbXPC

// This implements the example protocol. Replace the body of this class with the implementation of this service's protocol.
- (void)upperCaseString:(NSString *)aString withReply:(void (^)(NSString *))reply {
    NSString *response = [aString uppercaseString];
    reply(response);
}

- (void)test:(void (^)(BOOL))cb {
    cb(YES);
}


@end
