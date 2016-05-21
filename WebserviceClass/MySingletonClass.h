//
//  MySingletonClass.h
//  SnapChat
//
//  Created by Gurpreet Chawla on 3/13/13.
//  Copyright (c) 2013 Gurpreet Chawla. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^StringConsumer)(NSArray*,NSError*);

@interface MySingletonClass : NSObject

+(MySingletonClass *)sharedSingleton;
- (void )getDataFromJson:(NSString *)postString getData:(StringConsumer) consumer;





@end
