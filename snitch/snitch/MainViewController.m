//
//  MainViewController.m
//  snitch
//
//  Created by Keith Elliott on 5/4/13.
//  Copyright (c) 2013 gittielabs. All rights reserved.
//

#import "MainViewController.h"
#import "SnitchCell.h"
#import "TipManager.h"
#import "MenuViewController.h"
#import "SMSViewController.h"
#import <Parse/Parse.h>

@interface MainViewController ()
@property(nonatomic, strong) NSMutableArray *tips;
@property(nonatomic, strong) NSDateFormatter *dFormatter;
@property(nonatomic, strong) UIPopoverController *popover;
@end

@implementation MainViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	self.tips = [[NSMutableArray alloc] init];
	[self.collectionView registerClass:[SnitchCell class] forCellWithReuseIdentifier:@"SnitchCell"];
	self.collectionView.backgroundColor = [UIColor lightGrayColor];
	
	self.dFormatter = [[NSDateFormatter alloc] init];
	[self.dFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redisplayCollectionView:) name:TIPS_UPDATED_FROM_PARSE object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCollectionWithCategory:) name:CATEGORY_SELECTION_CHANGED object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendSMS:) name:SEND_SMS_NOW object:nil];
	
	self.tips =  [[NSMutableArray alloc] initWithArray: [[TipManager sharedTipManager] allTips]];

}

-(void)sendSMS:(NSNotification *) notification{
	NSInteger row = [[notification.userInfo valueForKey:@"index"] integerValue];
	NSString *message = [[notification.userInfo valueForKey:@"message"] description];
	
	Tip* tip = (Tip*)[self.tips objectAtIndex: row];
	[PFCloud callFunctionInBackground:@"sendSMS"
										 withParameters:@{ @"from": tip.toRecipient,
																 @"to" : tip.fromRecipient,
															 @"message": message}
															block:^(NSString *result, NSError *error) {
																if (!error) {
																		// result is @"Hello world!"
																}
	}];
}

-(void)redisplayCollectionView:(NSNotification *) notification{
	self.tips =  [[NSMutableArray alloc] initWithArray: [[TipManager sharedTipManager] allTips]];
	[self.collectionView reloadData];
}

-(void)updateCollectionWithCategory:(NSNotification *) notification{
	NSString *category = [notification.userInfo valueForKey:@"Category"];
	
	HHTipCategory enumCategory = [Tip categoryFromString:category];
	
	self.tips = [[NSMutableArray alloc] initWithArray:[[TipManager sharedTipManager] tipsFromCategory:enumCategory]];
	[self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collection view delegates
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
		return self.tips.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
	return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	
	SnitchCell *cell = (SnitchCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"SnitchCell" forIndexPath:indexPath];
	
	Tip* tip = (Tip*)[self.tips objectAtIndex:indexPath.row];
	cell.message.text = tip.message;
	cell.location.text = tip.location;
	[cell.status setSelected: tip.resolved];
	cell.timeStamp.text = [self.dFormatter stringFromDate:tip.timestamp];
	cell.snitchType.text = [Tip stringFromCategory:tip.category];
	cell.tag = indexPath.row;
	cell.delegate = self;
	return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	SMSViewController *smsVC = (SMSViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"sendSMS"];
	
	smsVC.modalPresentationStyle = UIModalPresentationFormSheet;
	smsVC.index = [NSNumber numberWithInteger:indexPath.row];
	smsVC.tip = (Tip*)[self.tips objectAtIndex:indexPath.row];
	smsVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentViewController:smsVC animated:YES completion:nil];
	
	smsVC.view.superview.frame = CGRectMake(0, 0, 291, 400);//it's important to do this after
	
	smsVC.view.superview.center = self.view.center;

}

#pragma mark - Status Delegate
-(void)updateStatusWithState:(BOOL)selected andIndex:(NSInteger)row{
	Tip* tip = (Tip*)[self.tips objectAtIndex:row];
	tip.resolved = !selected;
	
	PFObject *tipObj = [PFQuery getObjectOfClass:@"SMS" objectId:tip.tipId];
	[tipObj setObject:[NSNumber numberWithBool:tip.resolved] forKey:@"resolved"];
	[tipObj saveInBackground];
	
	NSIndexPath *ip = [NSIndexPath indexPathForRow:row inSection:0];
	
	[self.collectionView reloadItemsAtIndexPaths:@[ip]];
}

@end
