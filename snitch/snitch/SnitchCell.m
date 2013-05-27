//
//  SnitchCell.m
//  snitch
//
//  Created by Keith Elliott on 5/5/13.
//  Copyright (c) 2013 gittielabs. All rights reserved.
//

#import "SnitchCell.h"

@implementation SnitchCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
			self = [[[NSBundle mainBundle] loadNibNamed:@"SnitchCell" owner:self options:nil] objectAtIndex:0];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)toggleStatus:(id)sender {
	BOOL selected = ((UIButton*)sender).selected;
	
	[self.delegate updateStatusWithState:selected andIndex:self.tag];
}
@end
