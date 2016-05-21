//
//  CartrizeWebservices.h
//  Cartrize
//
//  Created by Admin on 21/07/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface CartrizeWebservices : NSObject
+(void)PostMethodWithApiMethod:(NSString *)Strurl Withparms:(NSDictionary *)params WithSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

+(void)GetMethodWithApiMethod:(NSString *)Strurl WithSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

@end
