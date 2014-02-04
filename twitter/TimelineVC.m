//
//  TimelineVC.m
//  twitter
//
//  Created by Timothy Lee on 8/4/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "TimelineVC.h"
#import "TweetCell.h"
#import "TweetVC.h"
#import "ComposeVC.h"
#import "UIImageView+AFNetworking.h"

@interface TimelineVC ()

@property (nonatomic, strong) NSMutableArray *tweets;
@property (strong, nonatomic) NSTimer *timer;

- (void)onSignOutButton;
- (void)reload:(NSInteger)sinceId;

@end

@implementation TimelineVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self reload:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];
    
    self.navigationItem.title = @"Home";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNewTweetButton)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    UINib *tweetNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:tweetNib forCellReuseIdentifier:@"TweetCell"];

    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(pullTweets) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)stopRefresh
{
    [self.refreshControl endRefreshing];
}

- (void)pullTweets
{
    [self reload:0];
    [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:2];
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
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TweetCell";
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Tweet *tweet = self.tweets[indexPath.row];
    cell.tweetText.text = tweet.text;
    [cell.tweetText sizeToFit];
    
    NSURL *url = [[NSURL alloc] initWithString:tweet.profile_image_url];
    [cell.displayImageUrl setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    cell.screenName.text = tweet.screen_name;
    cell.name.text = tweet.name;
    
    cell.replyButton.tag = indexPath.row;
    [cell.replyButton addTarget:self action:@selector(onReplyButton:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.retweetButton.tag = indexPath.row;
    [cell.retweetButton addTarget:self action:@selector(retweetAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.favoriteButton.tag = indexPath.row;
    [cell.favoriteButton addTarget:self action:@selector(favoriteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (tweet.favorited) {
        [cell.favoriteButton setSelected:YES];
    }
    if (tweet.retweeted) {
        [cell.retweetButton setSelected:YES];
    }
    
    UIView *retweetedByView = (UIView *)[self.view viewWithTag:42];
    if(tweet.retweeted_by){
        cell.retweetedBy.text = tweet.retweeted_by;
        retweetedByView.hidden = NO;
    } else {
        CGRect newFrame = retweetedByView.frame;
        newFrame.size.width = 0;
        newFrame.size.height = 0;

        [retweetedByView setFrame:newFrame];
        retweetedByView.hidden = YES;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView_
{
    CGFloat actualPosition = scrollView_.contentOffset.y;
    CGFloat contentHeight = self.tweets.count * 90;
    if (actualPosition >= contentHeight && ![self.timer isValid]) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(reloadNextTweets:) userInfo:nil repeats:NO];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TweetVC *tweetViewControler = [[TweetVC alloc] init];
    tweetViewControler.tweet = self.tweets[indexPath.row];
    [self.navigationController pushViewController:tweetViewControler animated:YES];
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */


-(void)sendDataToTimeline:(Tweet *)publishTweet
{
    [self.tweets insertObject:publishTweet atIndex:0];
    [self.tableView reloadData];
}


#pragma mark - Private methods

- (void)onNewTweetButton {
    ComposeVC *composeView = [[ComposeVC alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:composeView];
    composeView.delegate=self;
    composeView.user = [User currentUser];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)onReplyButton:(UIButton*)sender {
    ComposeVC *composeView = [[ComposeVC alloc] init];
    composeView.user = [User currentUser];
    composeView.tweet = [self.tweets objectAtIndex:sender.tag];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:composeView];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)favoriteAction:(UIButton*)sender {
    sender.selected = !sender.selected;
    Tweet *tweet = [self.tweets objectAtIndex:sender.tag];
    NSString *tweetId = [tweet objectForKey:@"id_str"];
    if (sender.selected) {
        //Destroy fav
        [self favorite:tweetId undoFavorite:YES];
        [sender setSelected:NO];
        
    } else {
        //Create fav
        [self favorite:tweetId undoFavorite:NO];
        [sender setSelected:YES];
    }
}

- (void)retweetAction:(UIButton*)sender {
    sender.selected = !sender.selected;
    Tweet *tweet = [self.tweets objectAtIndex:sender.tag];
    NSString *tweetId = [tweet objectForKey:@"id_str"];
    if (sender.selected) {
        //destroy retweet
        NSDictionary *current_user_retweet = [tweet objectForKey:@"current_user_retweet"];
        NSString *tweetId = [current_user_retweet objectForKey:@"id_str"];
        [self retweet:tweetId undoRetweet:YES];
        [sender setSelected:NO];
    } else {
        //create retweet
        [self retweet:tweetId undoRetweet:NO];
        [sender setSelected:YES];
    }
}

- (void)onSignOutButton {
    [User setCurrentUser:nil];
}

- (void)reload:(NSInteger)sinceId {
    [[TwitterClient instance] homeTimelineWithCount:20 sinceId:sinceId maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@", response);
        if (sinceId>0) {
            [self.tweets addObjectsFromArray:[Tweet tweetsWithArray:response]];
        } else {
            self.tweets = [Tweet tweetsWithArray:response];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
        NSLog(@"%@", error);
    }];
}

- (void)reloadNextTweets:(NSTimer *)timer {
    Tweet *lastTweet = [self.tweets lastObject];
    long long tweetId = [[lastTweet objectForKey:@"id"] longLongValue];
    [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:tweetId success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@", response);
        if (tweetId>0) {
            [self.tweets addObjectsFromArray:[Tweet tweetsWithArray:response]];
        } else {
            self.tweets = [Tweet tweetsWithArray:response];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
        NSLog(@"%@", error);
    }];
}


- (void)retweet:(NSString *)tweetId undoRetweet:(BOOL)undoRetweet {
    [[TwitterClient instance] postRetweet:tweetId undo:undoRetweet success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@", response);
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
        NSLog(@"%@", error);
    }];
}

- (void)favorite:(NSString *)tweetId undoFavorite:(BOOL)undoFavorite {
    [[TwitterClient instance] postFavorite:tweetId undo:undoFavorite success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@", response);
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
        NSLog(@"%@", error);
    }];
}

@end
