//
//  MenuViewController.m
//  snitch
//
//  Created by Keith Elliott on 5/5/13.
//  Copyright (c) 2013 gittielabs. All rights reserved.
//

#import "MenuViewController.h"
#import "TipManager.h"

@interface MenuViewController ()
@property(nonatomic, strong) NSArray *menus;
@end

@implementation MenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
			self.tableView = [[[NSBundle mainBundle] loadNibNamed:@"MenuViewController" owner:self options:nil] objectAtIndex:0];
			self.tableView.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.menus = @[@"All", @"Nuisance", @"Domestic Dispute", @"Assualt", @"Battery", @"Homicide", @"Shooting", @"Uncategorized"];
	
	self.view.frame = CGRectMake(0, 0, 50.0, 50.0);
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
    return self.menus.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
	cell.textLabel.text = [self.menus objectAtIndex:indexPath.row];
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *category = [self.menus objectAtIndex:indexPath.row];
	[[NSNotificationCenter defaultCenter] postNotificationName:CATEGORY_SELECTION_CHANGED object:self userInfo:@{@"Category": category}];
}

@end
