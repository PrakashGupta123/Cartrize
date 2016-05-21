//
//  AppDelegate.h
//  IShop
//
//  Created by Hashim on 4/29/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplashViewController.h"
#import "FHSTwitterEngine.h"
#import "SplashViewController.h"
@class GTMOAuth2Authentication;

@interface AppDelegate : UIResponder <UIApplicationDelegate,FHSTwitterEngineAccessTokenDelegate>
{
    BOOL isCheckOut;
    NSHTTPCookie *cookie;
}
@property(nonatomic,assign) float PricePayment;

@property(nonatomic,retain)FHSTwitterEngine *twitterEngine;
@property (strong, nonatomic) NSMutableArray *arrBackUp;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) UINavigationController *navigatoin;
@property (strong,nonatomic) SplashViewController *splashView;
@property (nonatomic,retain) NSString *strPassword,*strwebservice;
@property (nonatomic, retain) NSMutableArray *arrAddToBag;
@property (nonatomic, retain) NSMutableArray *arrFavourite;
@property BOOL isUserLogin,isCartID;
@property (nonatomic,retain) NSString *strCartId, *selectedCateId;
@property BOOL isPaymentComplete;
@property (nonatomic,retain) NSMutableDictionary *dictUserInfo;
@property (nonatomic,retain) NSString *strCustomerPassword;
@property (nonatomic,strong) NSMutableArray *MoreInfoarray_Recent;
@property (nonatomic,retain)  NSMutableArray *dataArray;
@property (nonatomic,retain)  NSMutableArray *dataArray2;
@property (nonatomic,retain) NSString *CurrentCurrency;
@property (nonatomic,retain) NSString *currencySymbol;
@property (nonatomic,strong) NSString *currencyValue;
@property (nonatomic,strong) NSString *strSearchName;
@property (nonatomic) int isSelecteGrid;
@property BOOL isCheck;
@property BOOL ChangeCurrency;
@property BOOL isCheckSearchType,IsCalled;
@property(nonatomic,assign)BOOL isFBCheck;
@property(nonatomic ,readwrite)int requestFor;
@property(nonatomic ,retain)NSMutableArray *mArrayCMSPages;

@property(strong ,nonatomic)IBOutlet NSMutableDictionary *mDictShipping;


@property (nonatomic,retain) NSString *selectedCurrentCurrency;
@property (nonatomic,retain) NSString *selectedCurrentSize;

+(AppDelegate*)appDelegate;

-(void)getFavoriteHistory;
-(void)getCheckOutHistory;
//-(void)getCheckOutHistory:(NSString*)cartID


@end
