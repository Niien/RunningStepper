//
//  HousePlaceMark.m
//  HouseFinder
//
//  Created by Chir on 2009/12/6.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HousePlaceMark.h"

@implementation HousePlaceMark

@synthesize coordinate;

- (NSString *)subtitle{

	return subtitlestring;
}
- (NSString *)title{
	
	return titlestring;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) currentCoordinate withTitle:(NSString*) title withSubTitle: (NSString*) subtitle {
	coordinate=currentCoordinate;
	titlestring=title;
	subtitlestring=subtitle;
	return self;
}

- (id)setTitle:(NSString*)title subTitle: (NSString*)subtitle  {
	titlestring=title;
	subtitlestring=subtitle;
	return self;
}


@end
