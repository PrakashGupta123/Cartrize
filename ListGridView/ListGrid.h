//
//  ListGrid.h
//  IShop
//
//  Created by Hashim on 5/3/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListGrid : UICollectionViewCell

@property(nonatomic,retain)IBOutlet UILabel *titlelalbe;
@property(nonatomic,retain)IBOutlet UIImageView *img;
@property(nonatomic,retain)IBOutlet UILabel *priceLbl;
@property(nonatomic,retain)IBOutlet UIButton *btnFavourite;

@property(nonatomic,retain)IBOutlet UILabel *lblimgDiscount;

@end
