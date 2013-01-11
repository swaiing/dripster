//
//  DetailMapViewCell.h
//  CoffeeShop
//
//  Created by Stephen Wai on 8/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Location.h"

#define METERS_PER_MILE 1609.344

@interface DetailMapViewCell : UITableViewCell <MKMapViewDelegate>

@property (nonatomic) IBOutlet MKMapView *mapView;

- (void) annotateMapRegion:(Location *)location;

@end
