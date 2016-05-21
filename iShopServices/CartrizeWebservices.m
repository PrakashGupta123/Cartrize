//
//  CartrizeWebservices.m
//  Cartrize
//
//  Created by Admin on 21/07/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import "CartrizeWebservices.h"
#import "JSON.h"
#import "AppDelegate.h"
//http://cartrize.com/iosapi_cartrize.php?methodName




//#define serviceURL @"http://192.168.88.139/cartrizenew/iosapi_cartrize.php?methodName="


//#define serviceURL @"http://cartrize.com/iosapi_cartrize.php?methodName="

//by me
//#define serviceURL @"http://cartrize.com/iosapi_cartrize_new.php?methodName="
#define serviceURL @"http://cartrize.com/iosapi_cartrize.php?methodName="
//

//#define BASEURL @"http://192.168.88.139/cartrizenew/"
#define BASEURL @"http://cartrize.com/"

//#define serviceURL @"http://192.168.88.139/cartrizenew/iosapi_cartrize.php?methodName="
//#define BASEURL @"http://192.168.88.139/cartrizenew/"

@implementation CartrizeWebservices
// Class method for call service For (PostType)
+(void)PostMethodWithApiMethod:(NSString *)Strurl Withparms:(NSDictionary *)params WithSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    NSString * path= [@"" stringByAppendingFormat:@"%@%@",serviceURL,Strurl];
    
    NSLog(@"%@",path);
    
    AFHTTPClient *httpclient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
   
    [httpclient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpclient requestWithMethod:@"POST" path:path parameters:params];
    ////NSLog(@"hgjhgjhgjh %@",request);
    [request setTimeoutInterval:120];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpclient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *strResponse = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        success (strResponse);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         NSLog(@"%@",error.localizedDescription);
         failure(error);
     }];
    [operation start];
}


// Class method for call service For (GetType)
+(void)GetMethodWithApiMethod:(NSString *)Strurl WithSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    NSString *strPath = [@"" stringByAppendingFormat: @"%@%@",serviceURL ,Strurl];
    NSLog(@"Get API path is %@",strPath);
    AFHTTPClient * httpClient = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:BASEURL]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:strPath parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *strResponse = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        success (strResponse);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    [operation start];
}

@end
