//
//  ComposeVC.h
//  twitter
//
//  Created by Utkarsh Sengar on 2/1/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Tweet.h"

@interface ComposeVC : UIViewController <UITextViewDelegate>
@property (nonatomic, weak) User *user;
@property (nonatomic, weak) Tweet *tweet;
@property (nonatomic, weak) IBOutlet UITextView *text;
@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *screenName;
@property (nonatomic, weak) IBOutlet UIImageView *displayImage;

@property(nonatomic,assign)id delegate;
@end

//ComposeVCDelegate
@protocol senddataProtocol <NSObject>

//didComposeTweet
-(void)sendDataToTimeline:(Tweet *)publishTweet;

@end
