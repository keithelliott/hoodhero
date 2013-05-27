//
//  SMSViewController.m
//  snitch
//
//  Created by Keith Elliott on 5/5/13.
//  Copyright (c) 2013 gittielabs. All rights reserved.
//

#import "SMSViewController.h"
#import "SMSCell.h"
#import "SnitchTableCell.h"
#import "TipManager.h"
#import "Tip.h"

@interface SMSViewController ()
@property(nonatomic, strong) UITapGestureRecognizer* tapGesture;
@property(copy, nonatomic) NSString *smsMessage;
@property(nonatomic, strong) NSDateFormatter *dFormatter;
@end

@implementation SMSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

		self.dFormatter = [[NSDateFormatter alloc] init];
		[self.dFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    self.tapGesture =	[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnywhere:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if(indexPath.row == 0)
		return 208;
	else
		return 103;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.row == 0){
		SnitchTableCell * cell = (SnitchTableCell*)[tableView dequeueReusableCellWithIdentifier:@"snitchCell"];
		cell.message.text = self.tip.message;
		cell.category.text = [Tip stringFromCategory:self.tip.category];
		cell.timestamp.text = [self.dFormatter stringFromDate:self.tip.timestamp];
		
		return cell;
	}
  else{
		SMSCell *cell = (SMSCell*)[tableView dequeueReusableCellWithIdentifier:@"smsCell"];
		cell.smsInput.delegate = self;
		return cell;
	}

}

#pragma mark - Text Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{

	[self.view addGestureRecognizer:self.tapGesture];
	
	return YES;
}

-(void)didTapAnywhere:(UITapGestureRecognizer*)recognizer{
	[self.view removeGestureRecognizer:self.tapGesture];
	[self.view endEditing:YES];
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
	 self.smsMessage = textView.text;
	return YES;
}


- (IBAction)sendSMS:(id)sender {
	if(self.index == nil || self.smsMessage == nil){
		[self dismissViewControllerAnimated:YES completion:nil];
		
	}
	else{
	
		[[NSNotificationCenter defaultCenter] postNotificationName:SEND_SMS_NOW object:self userInfo:@{@"message" : self.smsMessage, @"index" : self.index}];
	
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}
@end
