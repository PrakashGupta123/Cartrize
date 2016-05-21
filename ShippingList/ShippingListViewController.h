//
//  ShippingListViewController.h
//  IShop
//
//  Created by Avnish Sharma on 8/6/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+PendingTextFieldWithImage.h"
#import "IQActionSheetPickerView.h"
#import "VSPDropDownView.h"

@interface ShippingListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate,IQActionSheetPickerViewDelegate,vSpDropDownDelegate>
{
    BOOL AB;
    NSInteger SelectedSection;
    IBOutlet UITextField *txtTime;
    IBOutlet UITextField *txtDate;
    IBOutlet UITextView *txtViewDetail;
    IBOutlet UIButton *btnSelectDatel;
    NSString *strTimeId;
    
    
    
    NSString *strDayName;
    NSMutableArray *arrTimeAvail;
    NSString *strDate;
    VSPDropDownView *dropDown;
}
@property (strong, nonatomic) IBOutlet UIDatePicker *date_Picker;
@property (strong, nonatomic) IBOutlet UIView *view_For_datePicker;

@property(nonatomic ,retain)IBOutlet UITableView *tableViewShipList;
@property(nonatomic ,retain)NSMutableArray *mArrayUPSShipping,*RowArray;

- (IBAction)action_On_datePicker_Cancel:(id)sender;
- (IBAction)action_On_datePicker_Done:(id)sender;
- (IBAction)action_On_OpenDatePicker_Done:(id)sender;
- (IBAction)action_On_OpenTimePicker_Done:(id)sender;

- (IBAction)nextViewController:(id)sender;



@end
