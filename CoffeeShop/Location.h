//
//  Location.h
//  CoffeeShop
//
//  Created by Stephen Wai on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Location : NSObject <MKAnnotation>

@property (nonatomic) BOOL artisan;
@property (nonatomic) BOOL closed;
@property (nonatomic, copy) NSString *yelpId;
@property (nonatomic, copy) NSString *mobileUrl;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *ratingImageUrl;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *displayPhone;
@property (nonatomic, copy) NSNumber *reviewCount;
@property (nonatomic, copy) NSNumber *rating;
@property (nonatomic, copy) NSNumber *distance;
@property (nonatomic, copy) NSString *snippetText;
@property (nonatomic, copy) NSNumber *latitude;
@property (nonatomic, copy) NSNumber *longitude;
@property (nonatomic, copy) NSArray *address;
@property (nonatomic, copy) NSArray *displayAddress;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *stateCode;
@property (nonatomic, copy) NSString *postalCode;
@property (nonatomic, copy) NSArray *neighborhoods;

@property (nonatomic, copy) NSArray *beanTags;
@property (nonatomic, copy) NSArray *storeTags;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id) initWithName:(NSString *)aName address:(NSString *)anAddress coordinate:(CLLocationCoordinate2D)aCoordinate;
- (id) initWithPoint:(NSNumber *)aLatitude longitude:(NSNumber *)aLongitude;

@end
