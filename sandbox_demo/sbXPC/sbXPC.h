//
//  sbXPC.h
//  sbXPC
//
//  Created by 李玉峰 on 2020/8/5.
//  Copyright © 2020 李玉峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sbXPCProtocol.h"

// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
@interface sbXPC : NSObject <sbXPCProtocol>
@end
