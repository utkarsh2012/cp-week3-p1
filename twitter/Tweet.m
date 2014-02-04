//
//  Tweet.m
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (NSString *)text {
    if ([self.data valueOrNilForKeyPath:@"retweeted_status"]) {
        return [[self.data valueOrNilForKeyPath:@"retweeted_status"] valueOrNilForKeyPath:@"text"];
    }
    return [self.data valueOrNilForKeyPath:@"text"];
}

- (NSString *)profile_image_url {
    if ([self.data valueOrNilForKeyPath:@"retweeted_status"]) {
        NSDictionary *user = [[self.data valueOrNilForKeyPath:@"retweeted_status"] valueOrNilForKeyPath:@"user"];
        return [user valueOrNilForKeyPath:@"profile_image_url"];
    }
    NSDictionary *user = [self.data valueOrNilForKeyPath:@"user"];
    return [user valueOrNilForKeyPath:@"profile_image_url"];
}

- (NSString *)name {
    if ([self.data valueOrNilForKeyPath:@"retweeted_status"]) {
        NSDictionary *user = [[self.data valueOrNilForKeyPath:@"retweeted_status" ] valueOrNilForKeyPath:@"user"];
        return [user valueOrNilForKeyPath:@"name"];
    }
    NSDictionary *user = [self.data valueOrNilForKeyPath:@"user"];
    return [user valueOrNilForKeyPath:@"name"];
}

- (NSString *)screen_name {
    if ([self.data valueOrNilForKeyPath:@"retweeted_status"]) {
        NSDictionary *user = [[self.data valueOrNilForKeyPath:@"retweeted_status"] valueOrNilForKeyPath:@"user"];
        return [user valueOrNilForKeyPath:@"screen_name"];
    }
    NSDictionary *user = [self.data valueOrNilForKeyPath:@"user"];
    return [@"@" stringByAppendingString: [user valueOrNilForKeyPath:@"screen_name"] ];
}

- (NSString *)retweeted_by {
    if ([self.data valueOrNilForKeyPath:@"retweeted_status"]) {
        NSDictionary *user = [self.data valueOrNilForKeyPath:@"user"];
        return [user valueOrNilForKeyPath:@"name"];
    }
    return nil;
}

- (NSString *)total_retweets {
    return [[self.data valueOrNilForKeyPath:@"retweet_count"] stringValue];
}

- (NSString *)total_favorites {
    return [[self.data valueOrNilForKeyPath:@"favorite_count"] stringValue];
}

- (BOOL)favorited {
    NSInteger favoritedVal = [[self.data valueOrNilForKeyPath:@"favorited"] intValue];
    if (favoritedVal==1) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)retweeted {
    NSInteger retweetedVal = [[self.data valueOrNilForKeyPath:@"retweeted"] intValue];
    if (retweetedVal==1) {
        return YES;
    } else {
        return NO;
    }
}

//favorited and retweeted

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *params in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:params]];
    }
    return tweets;
}

@end
