//
//  DetailStaticTableViewController.h
//  CoffeeShop
//
//  Created by Stephen Wai on 8/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "DetailMapViewCell.h"
#import "DetailAddressCell.h"
#import "DetailActionCell.h"
#import "DetailFeaturesCell.h"
#import "TableMapViewController.h"

@interface DetailStaticTableViewController : UITableViewController

// instance vars
@property (nonatomic) Location *location;

// UI outlets
@property (nonatomic) IBOutlet DetailMapViewCell *mapCell;
@property (nonatomic) IBOutlet DetailAddressCell *addressCell;
@property (nonatomic) IBOutlet DetailActionCell *phoneCell;
@property (nonatomic) IBOutlet DetailFeaturesCell *featuresCell;
@property (nonatomic) IBOutlet UIButton *phoneBtn;

- (IBAction)close:(id)sender;
- (UIButton *)leftBarYelpButton;
- (IBAction)launchYelp:(id)sender;

@end
