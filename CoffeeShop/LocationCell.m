//
//  LocationCell.m
//  CoffeeShop
//
//  Created by Stephen Wai on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationCell.h"

@implementation LocationCell

@synthesize name;
@synthesize address;
@synthesize reviewCount;
@synthesize distance;
@synthesize ratingImg;
@synthesize img;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
