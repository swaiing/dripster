//
//  Location.m
//  CoffeeShop
//
//  Created by Stephen Wai on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Location.h"

@implementation Location

@synthesize artisan;
@synthesize yelpId;
@synthesize closed;
@synthesize mobileUrl;
@synthesize name;
@synthesize ratingImageUrl;
@synthesize imageUrl;
@synthesize phone;
@synthesize displayPhone;
@synthesize reviewCount;
@synthesize rating;
@synthesize distance;
@synthesize snippetText;
@synthesize latitude;
@synthesize longitude;
@synthesize address;
@synthesize displayAddress;
@synthesize city;
@synthesize stateCode;
@synthesize postalCode;
@synthesize neighborhoods;
@synthesize coordinate;
@synthesize beanTags;
@synthesize storeTags;

- (id) initWithName:(NSString *)aName address:(NSString *)anAddress coordinate:(CLLocationCoordinate2D)aCoordinate
{
    if ((self = [super init])) {
        name = [aName copy];
        address = [anAddress copy];
        coordinate = aCoordinate;
        latitude = [NSNumber numberWithDouble:aCoordinate.latitude];
        longitude = [NSNumber numberWithDouble:aCoordinate.longitude];
        
        //latitude = [aLatitude copy];
        //longitude = [aLongitude copy];
        //CLLocationCoordinate2D coord;
        //coord.latitude = latitude.doubleValue;
        //coord.longitude = longitude.doubleValue;
        //coordinate = coord;
    }
    return self;
}

- (id) initWithPoint:(NSNumber *)aLatitude longitude:(NSNumber *)aLongitude;
{
    if ((self = [super init])) {
        latitude = [aLatitude copy];
        longitude = [aLongitude copy];
    }
    return self;
}

- (NSString *) title {
    if ([name isKindOfClass:[NSNull class]])
        return @"Unknown charge";
    else
        return name;
}

- (NSString *) subtitle {
    return [address objectAtIndex:0];
}

@end
