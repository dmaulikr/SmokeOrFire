//
//  Card_GameViewController.m
//  CardGame
//
//  Created by Nicholas Blackburn on 9/29/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "Card_GameViewController.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "Utilities.h"

@interface Card_GameViewController ()
@property (nonatomic) int flipCount;
@property (nonatomic, strong) PlayingCardDeck *deck;

/* Buttons */
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *displayCard;
@property (strong, nonatomic) IBOutlet UIButton *fireButton;    // TODO: change my fucking name
@property (strong, nonatomic) IBOutlet UILabel *CorrectOrDrinkLabel;

@property (strong, nonatomic) UIButton *firstCard;

/* Choices */
@property (nonatomic) NSInteger smokeOrFire;

@property (nonatomic, strong) PlayingCard *currentCard;

@end

@implementation Card_GameViewController
{
    NSInteger gameState;
}

#pragma mark - Initializers

- (void) viewDidLoad
{
    self.smokeOrFire = -1;
    self.deck = [[PlayingCardDeck alloc] init];
    [self.displayCard setContentMode:UIViewContentModeScaleAspectFit];
    [self.displayCard setBackgroundImage:[UIImage imageNamed:@"cardBack"] forState:UIControlStateNormal];
    self.displayCard.userInteractionEnabled = NO;
    self.firstCard.userInteractionEnabled = NO;
    self.CorrectOrDrinkLabel.hidden = YES;
    
    gameState = SMOKEFIRE;
}

- (void) initButtons
{
    switch (gameState) {
        case SMOKEFIRE:
            // Do some stuff
            [self.leftButton setTitle:@"Smoke" forState:UIControlStateNormal];
            // TODO: set the color of the text, etc
            
            // TODO: set right button shit
            
            break;
        case HIGHLOW:
            [self.leftButton setTitle:@"Higher" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

#pragma mark - Helpers


// TODO: need to hide flipCount
- (void) setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    NSLog(@"flipCount = %d", self.flipCount);
}

- (void) flipCard
{
    
    // use drawRandomCard
    // flip the card from the image side to the actual card side
    // displaying *the contents*
    
    if ([_displayCard.currentTitle length] )
    {
        
        [_displayCard setBackgroundImage:[UIImage imageNamed:@"cardBack"]
                          forState:UIControlStateNormal];
        [_displayCard setTitle:@"" forState:UIControlStateNormal];
    }
    else
    {
        NSLog(@"%@", [UIImage imageNamed:@"cardFront"]);
        [_displayCard setBackgroundImage:[UIImage imageNamed:@"cardFront"]
                          forState:UIControlStateNormal];
        
        self.currentCard = (PlayingCard *)[self.deck drawRandomCard];
        
        /*  for debugging
         
         if ([newCard smokeOrFire] == SMOKE)
         NSLog(@"Smoke");
         else
         NSLog(@"Fire");
         */
        
        
        [_displayCard setTitle:[self.currentCard contents] forState:UIControlStateNormal];
    }
    self.flipCount++;
}

// Returns yes if guessed correctly, no otherwise
- (BOOL) checkSmokeOrFire
{
    [self performSelector:@selector(moveCardToPositionIndex:) withObject:SMOKEFIRE afterDelay:1.0];
    
    BOOL status = self.smokeOrFire == [self.currentCard smokeOrFire];
    
    if (status)
        self.CorrectOrDrinkLabel.text = @"CORRECT";
    else
        self.CorrectOrDrinkLabel.text = @"Take a drink";

  // not working properly if use sizeToFit
    [self.CorrectOrDrinkLabel sizeToFit];
    self.CorrectOrDrinkLabel.hidden = NO;
    
    return status;
}

#pragma mark - Button Presses

- (IBAction)leftButtonPressed:(UIButton *)sender
{
    switch (gameState) {
        case SMOKEFIRE:
            [self flipCard];
            self.smokeOrFire = SMOKE;
            [self checkSmokeOrFire];
            break;
        case HIGHLOW:
            NSLog(@"I'm a guru");
        default:
            break;
    }
    
    // TODO
    // wait 2 seconds, then automatically flip the card back over
    // without using a new card
    // move the image to the top right corner
    // now do higher or lower
}

- (IBAction)rightButtonPressed:(UIButton *)sender
{
    [self flipCard];
    self.smokeOrFire = FIRE;
    [self checkSmokeOrFire];
    
    // TODO: switch this shit. Look at the method above for reference
}

- (void) moveCardToPositionIndex:(NSInteger)index
{
    self.CorrectOrDrinkLabel.hidden = YES;
    
    switch (index) {
        case SMOKEFIRE:
        {
            CGRect btFrame = self.displayCard.frame;
            btFrame.origin.x = 15;
            btFrame.origin.y = 30;
            [self.displayCard setBackgroundImage:[UIImage imageNamed:@"cardBack"] forState:UIControlStateNormal];
            [self.displayCard setTitle:@"" forState:UIControlStateNormal];
            
            self.firstCard = [[UIButton alloc] initWithFrame:btFrame];
            [self.firstCard setBackgroundImage:[UIImage imageNamed:@"cardFront"] forState:UIControlStateNormal];
            [self.firstCard setTitle:[self.currentCard contents] forState:UIControlStateNormal];
            self.firstCard.titleLabel.textColor = [UIColor blackColor];
            NSLog(@"%@", [self.currentCard contents]);
            [self.view addSubview:self.firstCard];
            
            gameState = HIGHLOW;
            [self initButtons];
            break;
        }
        default:
            break;
    }
    
}


@end