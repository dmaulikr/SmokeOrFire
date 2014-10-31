//
//  Card_GameViewController.h
//  CardGame
//
//  Created by Nicholas Blackburn on 9/29/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Card_GameViewController : UIViewController

enum GameState
{
    SMOKEFIRE   = 0,
    HIGHLOW     = 1,
    INOUT,
    SUIT,
    GIVETAKE,
};

@end
