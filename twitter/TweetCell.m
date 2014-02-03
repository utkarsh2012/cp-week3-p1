//
//  TweetCell.m
//  twitter
//
//  Created by Timothy Lee on 8/6/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "TweetCell.h"

@implementation TweetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)favoriteAction:(id)sender {
    UIButton *favoriteButton = (UIButton *)sender;
    favoriteButton.selected = !favoriteButton.selected;
    
    if (favoriteButton.selected) {
        //selected
        
    } else {
        // unselected
    }
}

- (IBAction)retweetAction:(id)sender {
    UIButton *retweetButton = (UIButton *)sender;
    retweetButton.selected = !retweetButton.selected;
    
    if (retweetButton.selected) {
        //selected
        
    } else {
        // unselected
    }
}


- (IBAction)replyAction:(id)sender {
    //UIButton *replyButton = (UIButton *)sender;
}


@end
