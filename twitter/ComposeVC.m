//
//  ComposeVC.m
//  twitter
//
//  Created by Utkarsh Sengar on 2/1/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "ComposeVC.h"
#import "UIImageView+AFNetworking.h"
#import "Tweet.h"

@interface ComposeVC ()
@property (nonatomic, strong) Tweet *publishTweet;
@end

@implementation ComposeVC

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
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];
    
    self.navigationItem.title = @"";
    
    self.name.text = [self.user objectForKey:@"name"];
    self.screenName.text = [self.user objectForKey:@"screen_name"];
    
    if (self.tweet) {
        self.text.text = self.tweet.screen_name;
    }
    
    NSURL *url = [[NSURL alloc] initWithString:[self.user objectForKey:@"profile_image_url"]];
    [self.displayImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweetButton)];
    [self.text performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0];
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTweetButton {
    NSInteger in_reply_to_status_id = [[self.tweet objectForKey:@"id"] integerValue];  //create ID in tweet
    [[TwitterClient instance] postTweet:self.text.text in_reply_to_status_id:in_reply_to_status_id success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@", response);
        self.publishTweet = [[Tweet alloc] initWithDictionary:response];
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate sendDataToTimeline:self.publishTweet];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
        NSLog(@"%@", error);
    }];
}

- (void)onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"%d", [textView.text length]);
    //self.countLabel = [NSString stringWithFormat:@"%d", ]
}

@end
