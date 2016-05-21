//
//  PaymentTypeViewController.h
//  IShop
//
//  Created by Avnish Sharma on 7/17/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PayPalMobile.h"


@interface PaymentTypeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,PayPalPaymentDelegate, PayPalFuturePaymentDelegate,UIPopoverControllerDelegate>
{
    NSString *strShippingRate;
    int iRequest;
    
    
    NSString *strIncrement_id;
   // BOOL isPresent;

}
@property (nonatomic, retain)NSMutableDictionary *mDictPaymentResponse,*mDictProductDetail;
@property(nonatomic ,retain)IBOutlet UITableView *tableViewPaymentTypeList;
@property(nonatomic ,retain)NSMutableArray *mArrayPaymentType;

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, assign, readwrite) BOOL isPresent;
@property(nonatomic,strong)NSString *strPresent;

@end
