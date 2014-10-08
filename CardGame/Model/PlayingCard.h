//
//  PlayingCard.h
//  lec1
//
//  Created by Nicholas Blackburn on 9/29/14.
//  Copyright (c) 2014 Nicholas Blackburn. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *) validSuits;
+ (NSUInteger) maxRank;

- (NSInteger) smokeOrFire;
- (NSString *) contents;

@end
