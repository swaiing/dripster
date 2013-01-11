//
//  DetailPhoneNumberCell.m
//  CoffeeShop
//
//  Created by Stephen Wai on 8/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailActionCell.h"

@implementation DetailActionCell

@synthesize num;
@synthesize callBtn;
@synthesize address;
@synthesize directionsBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        directionsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        callBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// dial phone number
- (IBAction)callNumber:(id)sender
{
    // validate phone number
    // TODO: validate using regex
    if (num.length != 10) {
        NSLog(@"Phone number invalid: %@", num);
        return;
    }
    
    // dial number
    NSString *formattedNumber = [NSString stringWithFormat:@"tel://%@", num];
    NSLog(@"Dialing phone: %@", formattedNumber);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:formattedNumber]];
}

// launch native maps app
- (IBAction)getDirections:(id)sender;
{
    NSString *encodedAddr =  [address stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    NSString* urlText = [NSString stringWithFormat:@"http://maps.apple.com/maps?q=%@", encodedAddr];
    NSLog(@"Mapping URL: %@", encodedAddr);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
}

@end
