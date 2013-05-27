//
//  SnitchCell.h
//  snitch
//
//  Created by Keith Elliott on 5/5/13.
//  Copyright (c) 2013 gittielabs. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol StatusDelegate
-(void)updateStatusWithState:(BOOL)selected andIndex:(NSInteger)row;
@end

@interface SnitchCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *snitchType;
@property (strong, nonatomic) IBOutlet UILabel *location;
@property (strong, nonatomic) IBOutlet UILabel *timeStamp;
@property (strong, nonatomic) IBOutlet UITextView *message;
@property (strong, nonatomic) IBOutlet UIButton *status;

@property (weak, nonatomic) id<StatusDelegate> delegate;

- (IBAction)toggleStatus:(id)sender;

@end
