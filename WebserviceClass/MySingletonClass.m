//
//  MySingletonClass.m
//  SnapChat
//
//  Created by Gurpreet Chawla on 3/13/13.
//  Copyright (c) 2013 Gurpreet Chawla. All rights reserved.
//

#import "MySingletonClass.h"
#import "ConstantClass.h"

@implementation MySingletonClass


+ (MySingletonClass *)sharedSingleton
{
    static MySingletonClass * _sharedMySingleton;
    
    @synchronized(self)
    {
        if (!_sharedMySingleton)
            _sharedMySingleton = [[MySingletonClass alloc] init];
        
        return _sharedMySingleton;
    }
}

- (void )getDataFromJson:(NSString *)postString getData:(StringConsumer) consumer
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",webServiceUrl,postString]]];
    //NSLog(@"this is request%@",request);
    
    [request setHTTPMethod:@"POST"];
    //  [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]  completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
        NSInteger statusCode = [HTTPResponse statusCode];
        
        if (statusCode==200)
        {
            NSError* error;
           // NSString *responseString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
           //  //NSLog(@"this is response string%@",responseString);
            NSArray *json = [NSJSONSerialization
                             JSONObjectWithData:data //1
                             options:kNilOptions
                             error:&error];
            
            consumer(json,nil);
            
        }
        else{
            
            //NSLog(@"Error Description %@",[error localizedDescription]);
            consumer(nil,error);
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
    }];
}


@end
