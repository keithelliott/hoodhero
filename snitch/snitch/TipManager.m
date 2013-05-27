//
//  TipManager.m
//  snitch
//
//  Created by Keith Elliott on 5/5/13.
//  Copyright (c) 2013 gittielabs. All rights reserved.
//

#import "TipManager.h"
#import <Parse/Parse.h>

NSString * const TIPS_UPDATED_FROM_PARSE = @"TIPS_UPDATED_FROM_PARSE";
NSString * const CATEGORY_SELECTION_CHANGED = @"CATEGORY_SELECTION_CHANGED";
NSString * const SEND_SMS_NOW = @"SEND_SMS_NOW";

@interface TipManager ()
@property (strong, nonatomic)NSMutableArray *tips;
@end

@implementation TipManager
+(TipManager*)sharedTipManager{
	static TipManager* _tipManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
    _tipManager = [[TipManager alloc] init];
	});
	
	return _tipManager;
}

-(id)init{
	self = [super init];
	if(self){
		self.tips = [[NSMutableArray alloc] init];
		[self loadTipsFromParse];
	}
	
	return self;
}

-(void)loadTipsFromParse{
	PFQuery *query = [PFQuery queryWithClassName:@"SMS"];
	query.cachePolicy = kPFCachePolicyNetworkElseCache;
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (!error) {
			[self.tips removeAllObjects];
			for(PFObject* sms in objects){
				int myRandomNumber;
				myRandomNumber = arc4random() % 7 + 1;
				
				Tip *tip = [[Tip alloc] initWithParseObject:sms];
				tip.category = (HHTipCategory)myRandomNumber;
				tip.location = @"6th & Market, Wilmginton, DE";
				[self addTip:tip];
			}
			
			[[NSNotificationCenter defaultCenter] postNotificationName:TIPS_UPDATED_FROM_PARSE object:self];
			
		} else {
				// The network was inaccessible and we have no cached data for
				// this query.
		}
	}];
}

-(NSArray*)resolvedTips{
	NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
	
	[self.tips enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		Tip *tip = (Tip*)obj;
		if(tip.resolved){
			[tmpArray addObject:tip];
		}
	}];
	
	return tmpArray;
}

-(NSArray*)activeTips{
	NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
	
	[self.tips enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		Tip *tip = (Tip*)obj;
		if(!tip.resolved){
			[tmpArray addObject:tip];
		}
	}];
	
	return tmpArray;
}

-(NSArray*)allTips{
	return self.tips;
}

-(NSArray*)tipsFromCategory:(HHTipCategory)category{
	NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
	
	if(category == HH_ALL)
		return self.tips;
	
	[self.tips enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		Tip *tip = (Tip*)obj;
		if(tip.category == category){
			[tmpArray addObject:tip];
		}
	}];
	
	return tmpArray;
}

-(void)addTip:(Tip *)tip{
	if(![self.tips containsObject:tip])
		[self.tips addObject:tip];
}

@end
