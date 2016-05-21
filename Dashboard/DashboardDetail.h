//
//  DashboardDetail.h
//  IShop
//
//  Created by Admin on 16/07/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface DashboardDetail : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>{
    IBOutlet UIScrollView *scroll;
    IBOutlet UITextView *shippingAdd;
    IBOutlet UITextView *billingAdd;
    IBOutlet UITextView *PaymentMethod;
    IBOutlet UILabel *headerLbl;
    NSMutableArray *itemArray;
    NSMutableArray *titleArray;
    NSMutableArray *paymentDetail;
    IBOutlet UITableView *tab;
    IBOutlet UILabel *sh_namelbl;
    IBOutlet UILabel *sh_addLbl;
    IBOutlet UILabel *sh_cityLbl;
    IBOutlet UILabel *sh_countryLbl;
    IBOutlet UILabel *sh_telLbl;
    IBOutlet UILabel *bi_namelbl;
    IBOutlet UILabel *bi_addLbl;
    IBOutlet UILabel *bi_cityLbl;
    IBOutlet UILabel *bi_countryLbl;
    IBOutlet UILabel *bi_telLbl;
    
    IBOutlet UILabel *lblSubTotal;
    IBOutlet UILabel *lblShippingAndHandling;
    IBOutlet UILabel *lblDiscount;
    IBOutlet UILabel *lblgrandTotal;
    
    IBOutlet UILabel *lblItemOrder;
    IBOutlet UIImageView *imgItemOrder,*imgTblBackground;
    
    IBOutlet UILabel *lblPayMentMethod,*lblShippingMethod;
    
    IBOutlet UILabel *lblDiscountCode;

    
    /*ViewPayment*/
    IBOutlet UILabel *lblPayMentType1;
    IBOutlet UILabel *lblPayMentType2;
    IBOutlet UILabel *lblPayMentType3;
    IBOutlet UILabel *lblPayMentType4;
}

@property(nonatomic ,retain)NSMutableArray *responseArray;
@property(nonatomic,retain)MBProgressHUD *progressHud;
@property(nonatomic,retain)UIWindow *window;
@property(nonatomic,retain)NSString *orderId;
@property(nonatomic,retain)NSString *statusStr;

@property(nonatomic ,retain)IBOutlet UIView *viewBilling,*viewPayment;
@property(nonatomic ,retain)IBOutlet UITableView *tableViewItemOrder;

@property(nonatomic ,retain)IBOutlet UISegmentedControl *sagment;


-(IBAction)backAction:(id)sender;
@end
