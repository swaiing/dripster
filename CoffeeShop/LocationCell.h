//
//  LocationCell.h
//  CoffeeShop
//
//  Created by Stephen Wai on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationCell : UITableViewCell

@property (nonatomic) IBOutlet UILabel *name;
@property (nonatomic) IBOutlet UILabel *address;
@property (nonatomic) IBOutlet UILabel *reviewCount;
@property (nonatomic) IBOutlet UILabel *distance;
@property (nonatomic) IBOutlet UIImageView *ratingImg;
@property (nonatomic) IBOutlet UIImageView *img;

@end
