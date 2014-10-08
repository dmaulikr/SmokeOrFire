//
//  Card.h
//  Card
//
//  Created by Nicholas Blackburn on 9/23/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString * contents;

@property (nonatomic, getter = isChosen) BOOL chosen;
@property (nonatomic, getter = isMatched) BOOL matched;

- (int)match:(NSArray *)otherCards;


@end
