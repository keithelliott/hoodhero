//
//  TipManager.h
//  snitch
//
//  Created by Keith Elliott on 5/5/13.
//  Copyright (c) 2013 gittielabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tip.h"

extern NSString * const TIPS_UPDATED_FROM_PARSE;
extern NSString * const CATEGORY_SELECTION_CHANGED;
extern NSString * const SEND_SMS_NOW;

@interface TipManager : NSObject
+(TipManager*) sharedTipManager;
-(NSArray*)resolvedTips;
-(NSArray*)activeTips;
-(NSArray*)tipsFromCategory:(HHTipCategory)category;
-(NSArray*)allTips;
-(void)addTip:(Tip*)tip;
-(void)loadTipsFromParse;
@end
