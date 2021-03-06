//
//  TweetVC.m
//  twitter
//
//  Created by Utkarsh Sengar on 2/1/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "TweetVC.h"
#import "ComposeVC.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"

@interface TweetVC ()

@end

@implementation TweetVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Tweet";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];
    
    self.navigationItem.title = @"Tweet";
    
    self.text.text = self.tweet.text;
    [self.text sizeToFit];
    self.name.text = self.tweet.name;
    self.screen_name.text = self.tweet.screen_name;
    self.total_retweets.text = self.tweet.total_retweets;
    self.total_favorites.text = self.tweet.total_favorites;
    
    if (self.tweet.favorited) {
        [self.favoriteButton setSelected:YES];
    }
    if (self.tweet.retweeted) {
        [self.retweetButton setSelected:YES];
    }
    
    NSURL *url = [[NSURL alloc] initWithString:self.tweet.profile_image_url];
    [self.profile_image_url setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReplyButton)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onReplyButton {
    ComposeVC *composeView = [[ComposeVC alloc] init];
    composeView.user = [User currentUser];
    composeView.tweet = self.tweet;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:composeView];
    [self presentViewController:navigationController animated:YES completion:nil];
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
    [self onReplyButton];
}

@end
