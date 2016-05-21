//
//  ViewController.h
//  Cartrize
//
//  Created by Admin on 19/07/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *zipCodetf;
}
-(IBAction)continueAction:(id)sender;
@end
