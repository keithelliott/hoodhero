//
//  Tip.h
//  snitch
//
//  Created by Keith Elliott on 5/5/13.
//  Copyright (c) 2013 gittielabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PFObject;

typedef enum {
	HH_ALL = 0, HH_NUISANCE = 1, HH_DOMESTIC_DISPUTE = 2, HH_ASSUALT = 3, HH_BATTERY = 4, HH_HOMICIDE = 5, HH_SHOOTING = 6, HH_UNCATEGORIZED = 7
} HHTipCategory;

@interface Tip : NSObject
@property (copy, nonatomic) NSString *location;
@property HHTipCategory category;
@property (copy, nonatomic) NSString *message;
@property (strong, nonatomic) NSDate *timestamp;
@property BOOL resolved;
@property (copy, nonatomic) NSString *tipId;
@property (copy, nonatomic) NSString *toRecipient;
@property (copy, nonatomic) NSString *fromRecipient;

-(id)initWithParseObject:(PFObject*)object;

+(NSString*)stringFromCategory:(HHTipCategory)category;
+(HHTipCategory)categoryFromString:(NSString*)category;
@end
