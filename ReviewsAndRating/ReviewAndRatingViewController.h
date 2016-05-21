//
//  ReviewAndRatingViewController.h
//  IShop
//
//  Created by Avnish Sharma on 7/21/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewAndRatingViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *mArrayResponse;
}
@property(nonatomic ,retain)IBOutlet UITextView *txtViewReview;
@property(nonatomic ,retain)IBOutlet UIView *viewWriteReview,*viewCustomerReview;
@property(nonatomic ,retain)NSString *strProductID;
@property(nonatomic ,retain)IBOutlet UITextField *txtNickName,*txtSummaryReview,*txtReview;
@property(nonatomic ,retain)IBOutlet UITableView *tableViewCustomerReviews;
@property(nonatomic ,retain)IBOutlet NSMutableArray *mArrayRating;

@end
