//
//  TweetVC.h
//  twitter
//
//  Created by Utkarsh Sengar on 2/1/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetVC : UIViewController

@property (nonatomic, weak) Tweet *tweet;
@property (nonatomic, weak) IBOutlet UILabel *text;
@property (nonatomic, weak) IBOutlet UIImageView *profile_image_url;
@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *screen_name;
@property (nonatomic, weak) IBOutlet UILabel *total_retweets;
@property (nonatomic, weak) IBOutlet UILabel *total_favorites;

- (IBAction)favoriteAction:(id)sender;
- (IBAction)replyAction:(id)sender;
- (IBAction)retweetAction:(id)sender;

@property (nonatomic, weak) IBOutlet UIButton *retweetButton;
@property (nonatomic, weak) IBOutlet UIButton *favoriteButton;

@end
