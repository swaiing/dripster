//
//  DetailPhoneNumberCell.h
//  CoffeeShop
//
//  Created by Stephen Wai on 8/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailActionCell : UITableViewCell

@property (nonatomic) NSString *num;
@property (nonatomic) IBOutlet UIButton *callBtn;
@property (nonatomic) NSString *address;
@property (nonatomic) IBOutlet UIButton *directionsBtn;

- (IBAction)callNumber:(id)sender;
- (IBAction)getDirections:(id)sender;

@end
