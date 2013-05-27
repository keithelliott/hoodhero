//
//  Tip.m
//  snitch
//
//  Created by Keith Elliott on 5/5/13.
//  Copyright (c) 2013 gittielabs. All rights reserved.
//

#import "Tip.h"
#import <Parse/Parse.h>

@implementation Tip
-(id)initWithParseObject:(PFObject *)object{
	self = [super init];
	if(self){
		self.message = [[object valueForKey:@"body"] description];
		self.timestamp = (NSDate*)[object valueForKey:@"createdAt"];
		self.toRecipient = [[object valueForKey:@"to"] description];
		self.fromRecipient = [[object valueForKey:@"From"] description];
		self.tipId = [object objectId];
		
		id resolved = [object valueForKey:@"resolved"];
		if(resolved){
			self.resolved = [resolved boolValue];
		}
		else{
			self.resolved = NO;
		}
	}
	
	return self;
}

+(NSString*)stringFromCategory:(HHTipCategory)category{
	switch (category) {
		case HH_NUISANCE:
			return @"NUISANCE";
		case HH_DOMESTIC_DISPUTE:
			return @"Domestic Dispute";
		case HH_ASSUALT:
			return @"Assualt";
		case HH_BATTERY:
			return @"Battery";
		case HH_HOMICIDE:
			return @"Homicide";
		case HH_SHOOTING:
			return @"Shooting";
		case HH_ALL:
			return @"All";
		default:
			return @"Uncategorized";
	}
}

+(HHTipCategory)categoryFromString:(NSString*)category{
	if([category isEqualToString:@"Nuisance"])
		return HH_NUISANCE;
	
	if([category isEqualToString:@"Domestic Dispute"])
			return HH_DOMESTIC_DISPUTE;

	if([category isEqualToString:@"Assualt"])
			return HH_ASSUALT;

	if([category isEqualToString:@"Battery"])
			return HH_BATTERY;
	if([category isEqualToString:@"Homicide"])
			return HH_HOMICIDE;
	
	if([category isEqualToString:@"Shooting"])
			return HH_SHOOTING;

	if([category isEqualToString:@"All"])
		return HH_ALL;
	
	return HH_UNCATEGORIZED;

}
@end
