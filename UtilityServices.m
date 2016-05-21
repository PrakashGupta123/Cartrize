//
//  UtilityServices.m
//  IShop
//
//  Created by Avnish Sharma on 6/25/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import "UtilityServices.h"
#import "ASIFormDataRequest.h"

@implementation UtilityServices

-(void)getFavoriteHistory:(NSMutableDictionary *)mDictParam
{
    NSURL *url = [NSURL URLWithString:get_user_all_favorite];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.timeOutSeconds = 120;
    
    
    [request setPostValue:[mDictParam valueForKey:@"customer_id"] forKey:@"customer_id"];
    
    [request setDidFinishSelector:@selector(requestFinishedForService:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

-(void)test
{
    //NSLog(@"Testing");
}
#pragma mark - ASIHTTP Response

-(void)requestFinishedForService:(ASIHTTPRequest *)request
{
    
    NSString *string =[request responseString];
    NSData *data = [request responseData];
    
    //NSLog(@"string -- %@",string);
    //NSLog(@"data -- %@",data);
    
    NSMutableDictionary *mutableDictResponce = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    
    //NSMutableArray *mArrayResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    
    NSString *strAlert = [mutableDictResponce valueForKey:@"error"];
    
    if ([[mutableDictResponce objectForKey:@"error"] isEqualToString:@""] || [mutableDictResponce objectForKey:@"error"] == nil)
    {
        
    }
    
    else if(![[mutableDictResponce objectForKey:@"error"] isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:strAlert delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Check your network connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}


@end
