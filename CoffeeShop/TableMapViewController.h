//
//  ViewController.h
//  CoffeeShop
//
//  Created by Stephen Wai on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "EGORefreshTableHeaderView.h"
#import "Location.h"

#define METERS_PER_MILE 1609.344
#define LATITUDE_METERS_PER_DEGREE 110574
#define LONGITUDE_METERS_PER_DEGREE 111320
#define DEFAULT_FRACTION_DELTA 0.5
#define MAX_TABLE_CAPACITY 30

// dark shades of brown
#define DARK_SHADE [UIColor colorWithRed:117.0/255.0 green:62.0/255.0 blue:16.0/255.0 alpha:1.0]
#define LIGHT_SHADE [UIColor colorWithRed:252.0/255.0 green:244.0/255.0 blue:237.0/255.0 alpha:1.0]

@interface TableMapViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,
                                                      MKMapViewDelegate,EGORefreshTableHeaderDelegate>


// instance vars
@property (nonatomic) NSMutableArray *locations;
@property (nonatomic) Location *selectedLocation;
@property (nonatomic) NSSet *VALID_RATINGS;

// UI outlets
@property (nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (nonatomic) IBOutlet UIView *swappableView;
@property (nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) IBOutlet UITableView *tblView;

// pull to refresh
@property (nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic) BOOL reloading;

@property (nonatomic) Location *regionCenter;
@property (nonatomic) Location *regionSpanDelta;


// UI actions
- (IBAction)swapViews:(id)sender;
+ (UIButton *)createLeftBarYelpButton;
- (UIButton *)leftBarYelpButton;
+ (BOOL)isYelpInstalled;
- (IBAction)launchYelp:(id)sender;

@end