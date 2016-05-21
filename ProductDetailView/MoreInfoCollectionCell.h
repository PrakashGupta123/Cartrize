//
//  MoreInfoCollectionCell.h
//  IShop
//
//  Created by Vivek  on 30/05/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface MoreInfoCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet AsyncImageView *imageThumb;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbloutofstock;


@end
