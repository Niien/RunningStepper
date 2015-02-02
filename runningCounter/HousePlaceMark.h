//
//  HousePlaceMark.h
//  HouseFinder
//
//  Created by Chir on 2009/12/6.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface HousePlaceMark : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *subtitlestring;
	NSString *titlestring;
}


@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
-(id)initWithCoordinate:(CLLocationCoordinate2D) currentCoordinate withTitle:(NSString*) title withSubTitle: (NSString*) subtitle;
- (id)setTitle:(NSString*)title subTitle: (NSString*)subtitle ;
- (NSString *)subtitle;
- (NSString *)title;


@end
