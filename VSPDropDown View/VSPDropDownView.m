//
//  VSPDropDownView.m
//  Things2Do
//
//  Created by Vivek on 10/12/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import "VSPDropDownView.h"
#import "QuartzCore/QuartzCore.h"

@interface VSPDropDownView ()
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) UIButton *btnSender;
@property(nonatomic, retain) NSMutableArray *arraylist;
@end

@implementation VSPDropDownView
@synthesize delegate;

- (id)showDropDown:(UIButton *)button andWithHeight:(CGFloat)height andWithArray:(NSMutableArray *)arr andWithDirection:(NSString *)direction
{
    _btnSender = button;
    _animationDirection = direction;
    self.table = (UITableView *)[super init];
    if (self) {
        // Initialization code
        CGRect btn = button.frame;
        _arraylist = [NSMutableArray arrayWithArray:arr];
        
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, -5);
        }else if ([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, 5);
        }
        
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, 0)];
        _table.delegate = self;
        _table.dataSource = self;
        _table.layer.cornerRadius = 5;
        _table.backgroundColor = [UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.separatorColor = [UIColor grayColor];
        
        _table.backgroundColor=[UIColor clearColor];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        if ([direction isEqualToString:@"up"])
        {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y-height, btn.size.width,height);
        }
        else if([direction isEqualToString:@"down"])
        {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, height);
        }
        _table.frame = CGRectMake(0, 0, btn.size.width, height);
        [UIView commitAnimations];
        [button.superview addSubview:self];
        [self addSubview:_table];
    }
    return self;
    
}
-(void)hideDropDown:(UIButton *)button
{
    CGRect btn = button.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    if ([_animationDirection isEqualToString:@"up"])
    {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
    }
    else if ([_animationDirection isEqualToString:@"down"])
    {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
    }
    _table.frame = CGRectMake(0, 0, btn.size.width, 0);
    [UIView commitAnimations];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arraylist count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //tableView.scrollEnabled = NO;
    [tableView setShowsHorizontalScrollIndicator:NO];
    [tableView setShowsVerticalScrollIndicator:NO];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        //        cell.backgroundColor = [UIColor grayColor];
        
    }
    
    cell.textLabel.textColor = [UIColor colorWithRed:255.0f/255.0f green:102.0f/255.0f blue:102.0f/200.0f alpha:1.0];
    cell.textLabel.text = [[_arraylist objectAtIndex:indexPath.row] valueForKey:@"times"];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor lightGrayColor];
    cell.selectedBackgroundView = view;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [delegate getStrData:[_arraylist objectAtIndex:indexPath.row] ];
    [self hideDropDown:_btnSender];
    
    // UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    
    // _btnSender.tag=indexPath.row;
    
    //  [_btnSender setTitle:c.textLabel.text forState:UIControlStateNormal];
    
    //    for (UIView *subview in _btnSender.subviews) {
    //
    //        if ([subview isKindOfClass:[UIImageView class]]) {
    //            [subview removeFromSuperview];
    //        }
    //    }
    //    _imgView.image = c.imageView.image;
    //    _imgView = [[UIImageView alloc] initWithImage:c.imageView.image];
    //    _imgView.frame = CGRectMake(5, 5, 25, 25);
    //    [_btnSender addSubview:_imgView];
    [self myDelegate];
}

- (void) myDelegate
{
    [self.delegate VSPDropDownDelegateMethod:self];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
