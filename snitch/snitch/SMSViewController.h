//
//  SMSViewController.h
//  snitch
//
//  Created by Keith Elliott on 5/5/13.
//  Copyright (c) 2013 gittielabs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Tip;
@interface SMSViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate,UITableViewDataSource, UITableViewDelegate>
- (IBAction)sendSMS:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSNumber *index;
@property (strong, nonatomic) Tip* tip;
@end
