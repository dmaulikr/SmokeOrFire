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

/* Buttons */
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *displayCard;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) IBOutlet UILabel *CorrectOrDrinkLabel;
@property (strong, nonatomic) IBOutlet UIButton *PlayAgainButton;

/* Card Images (at top of screen) */
@property (strong, nonatomic) UIButton *firstCard;
@property (strong, nonatomic) UIButton *secondCard;
@property (strong, nonatomic) UIButton *thirdCard;
@property (strong, nonatomic) UIButton *fourthCard;

/* Thumb Label View Images (underneath Card Images) */
@property (strong, nonatomic) IBOutlet UIImageView *ThumbView1;
@property (strong, nonatomic) IBOutlet UIImageView *ThumbView2;
@property (strong, nonatomic) IBOutlet UIImageView *ThumbView3;
@property (strong, nonatomic) IBOutlet UIImageView *ThumbView4;

/* Additional Suit Images */
@property (strong, nonatomic) IBOutlet UIButton *firstSuit;
@property (strong, nonatomic) IBOutlet UIButton *secondSuit;

/* Choices */
@property (nonatomic) NSInteger smokeOrFireGuess;
@property (nonatomic) NSInteger highOrLowGuess;
@property (nonatomic) NSInteger inOrOutGuess;
@property (nonatomic) NSString *suitGuess;

/* Cards*/
@property (nonatomic, strong) PlayingCard *currentCard;
@property (nonatomic, strong) NSMutableArray *cards;    // of PlayingCard

/* Deck */
@property (nonatomic, strong) PlayingCardDeck *deck;

/* Helper methods */
@property (nonatomic) int flipCount;
@property (nonatomic) BOOL correctLabelStatus;

@end

@implementation Card_GameViewController
{
    NSInteger gameState;
}

#pragma mark - Initializers

- (void) viewDidLoad
{
    /* initial gameState */
    gameState = SMOKEFIRE;
    [self initButtons];
    
    /* initialize variables */
    self.flipCount = 0;
    self.smokeOrFireGuess = -1;
    self.highOrLowGuess = -1;
    self.inOrOutGuess = -1;
    self.suitGuess = @"";
    
    /* initialize the deck */
    self.deck = [[PlayingCardDeck alloc] init];
    
    /* hide button or label */
    self.leftButton.hidden = NO;
    self.rightButton.hidden = NO;
    self.firstSuit.hidden = YES;
    self.secondSuit.hidden = YES;
    self.CorrectOrDrinkLabel.hidden = YES;
    self.PlayAgainButton.hidden = YES;
    self.firstCard.hidden = YES;
    self.secondCard.hidden = YES;
    self.thirdCard.hidden = YES;
    self.fourthCard.hidden = YES;
    self.ThumbView1.hidden = YES;
    self.ThumbView2.hidden = YES;
    self.ThumbView3.hidden = YES;
    self.ThumbView4.hidden = YES;
    
    /* disable user interaction */
    self.leftButton.userInteractionEnabled = YES;
    self.rightButton.userInteractionEnabled = YES;
    self.firstCard.userInteractionEnabled = NO;
    self.secondCard.userInteractionEnabled = NO;
    self.thirdCard.userInteractionEnabled = NO;
    self.fourthCard.userInteractionEnabled = NO;
    self.firstSuit.userInteractionEnabled = NO;
    self.secondSuit.userInteractionEnabled = NO;
    self.displayCard.userInteractionEnabled = NO;
    self.PlayAgainButton.userInteractionEnabled = NO;
    
    /* display cardBack */
    [self.displayCard setContentMode:UIViewContentModeScaleAspectFit];
    [self.displayCard setBackgroundImage:[UIImage imageNamed:@"cardBack"] forState:UIControlStateNormal];
    
    /* create an array to hold the history of cards */
    self.cards = [NSMutableArray array];
}

- (void) initButtons
{
    switch (gameState) {
        case SMOKEFIRE:
            self.leftButton.hidden = YES;
            self.rightButton.hidden = YES;
            
            /* Left Button init */
            [self.leftButton setTitle:@"Smoke" forState:UIControlStateNormal];
            [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            /* Right Button init */
            [self.rightButton setTitle:@"Fire" forState:UIControlStateNormal];
            [self.rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            self.leftButton.hidden = NO;
            self.rightButton.hidden = NO;
            
            break;
        case HIGHLOW:
            self.leftButton.hidden = YES;
            self.rightButton.hidden = YES;
            
            /* Higher Lower init */
            [self.leftButton setTitle:@"Higher" forState:UIControlStateNormal];
            [self.rightButton setTitle:@"Lower" forState:UIControlStateNormal];
            
            self.leftButton.hidden = NO;
            self.rightButton.hidden = NO;
            
            break;
        case INOUT:
            self.leftButton.hidden = YES;
            self.rightButton.hidden = YES;
            
            /* In Out init */
            [self.leftButton setTitle:@"Inside" forState:UIControlStateNormal];
            [self.rightButton setTitle:@"Outside" forState:UIControlStateNormal];
            
            self.leftButton.hidden = NO;
            self.rightButton.hidden = NO;
            
            break;
        case SUIT:
            self.leftButton.hidden = YES;
            self.rightButton.hidden = YES;
            
            self.firstSuit.userInteractionEnabled = YES;
            self.secondSuit.userInteractionEnabled = YES;
            /* Suit init
                left button */
            [self.leftButton setTitle:@"♥︎" forState:UIControlStateNormal];
            self.leftButton.font = [UIFont systemFontOfSize:28.0];
            [self.leftButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            self.leftButton.hidden = NO;
            
            /*  right button */
            [self.rightButton setTitle:@"♠︎" forState:UIControlStateNormal];
            self.rightButton.font = [UIFont systemFontOfSize:28.0];
            [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            /*  left middle button */
            [self.firstSuit setTitle:@"♦︎" forState:UIControlStateNormal];
            self.firstSuit.font = [UIFont systemFontOfSize:28.0];
            [self.firstSuit setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            /*  right middle button */
            [self.secondSuit setTitle:@"♣︎" forState:UIControlStateNormal];
            self.secondSuit.font = [UIFont systemFontOfSize:28.0];
            [self.secondSuit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            /* hidden status */
            self.leftButton.hidden = NO;
            self.rightButton.hidden = NO;
            self.firstSuit.hidden = NO;
            self.secondSuit.hidden = NO;
            
            break;
        case REPLAY:
            self.PlayAgainButton.hidden = NO;
            self.PlayAgainButton.userInteractionEnabled = YES;
            
            [self.leftButton setTitle:@"" forState:UIControlStateNormal];
            [self.rightButton setTitle:@"" forState:UIControlStateNormal];
            self.leftButton.hidden = YES;
            self.rightButton.hidden = YES;
            self.firstSuit.hidden = YES;
            self.secondSuit.hidden = YES;
            
            break;
        default:
            break;
    }
}

#pragma mark - Helpers


- (void) setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    NSLog(@"flipCount = %d", self.flipCount);
}

/*  flip the card from the back card image to the front card image, or vice versa
        --- uses drawRandomCard
    displays the contents of the card and set the appropriate text color */
- (void) flipCard
{
    /* flips card over */
    if ([self.displayCard.currentTitle length])
    {
        [self.displayCard setBackgroundImage:[UIImage imageNamed:@"cardBack"] forState:UIControlStateNormal];
        [self.displayCard setTitle:@"" forState:UIControlStateNormal];
    }
    else
    {
        NSLog(@"%@", [UIImage imageNamed:@"cardFront"]);
        [self.displayCard setBackgroundImage:[UIImage imageNamed:@"cardFront"] forState:UIControlStateNormal];
        
        /* draws random card from deck --- type: PlayingCard --- varName: currentCard */
        self.currentCard = (PlayingCard *)[self.deck drawRandomCard];
        
        /* displays contents and sets color */
        [self.displayCard setTitle:[self.currentCard contents] forState:UIControlStateNormal];
        [self setTextColor:self.displayCard];
    
        /* adds to mutable array for the history of cards */
        [self.cards addObject:[self.currentCard copy]];
    }
    
    self.flipCount++;
}

#pragma mark - Game Logic checks

// Returns BOOL --- checks value for the smoke or fire game logic
- (BOOL) checkSmokeOrFire
{
    if ([self.cards count] <= SMOKEFIRE)
        return NO;

    return (self.smokeOrFireGuess == [PlayingCard smokeOrFire:[self.cards objectAtIndex:SMOKEFIRE]]);
}

// Returns BOOL --- checks value for the higher or lower game logic
- (BOOL) checkHigherLower
{
    if ([self.cards count] <= HIGHLOW)
        return NO;
    
    return (self.highOrLowGuess == [PlayingCard highOrLow:[self.cards objectAtIndex:HIGHLOW] withPreviousCard:[self.cards objectAtIndex:SMOKEFIRE]]);
}

// Returns BOOL --- checks value for the in or out game logic
- (BOOL) checkInOut
{
    if ([self.cards count] <= INOUT)
        return NO;
    
    return (self.inOrOutGuess == [PlayingCard inOrOut:[self.cards objectAtIndex:INOUT] withSecondCard:[self.cards objectAtIndex:HIGHLOW] withFirstCard:[self.cards objectAtIndex:SMOKEFIRE]]);
}

// Returns BOOL --- checks value for the suit game logic
- (BOOL) checkSuit
{
    if ([self.cards count] <= SUIT)
        return NO;
    
    return ([self.currentCard.suit isEqualToString:self.suitGuess]);
}

#pragma mark - Button Presses

- (IBAction)leftButtonPressed:(UIButton *)sender
{
    self.leftButton.userInteractionEnabled = NO;
    self.rightButton.userInteractionEnabled = NO;
    
    switch (gameState) {
        case SMOKEFIRE:
            [self flipCard];
            self.smokeOrFireGuess = SMOKE;
            [self smokeOrFire];

            break;
        case HIGHLOW:
            NSLog(@"left button - state: highLow");
            [self flipCard];
            self.highOrLowGuess = HIGH;
            [self highOrLow];
            
            break;
        case INOUT:
            NSLog(@"left button - state: inOut");
            [self flipCard];
            self.inOrOutGuess = IN;
            [self inOrOut];
            
            break;
        case SUIT:
            NSLog(@"left button - state: suit");
            self.firstSuit.userInteractionEnabled = NO;
            self.secondSuit.userInteractionEnabled = NO;
            [self flipCard];
            self.suitGuess = @"♥︎";
            [self whichSuit];
            
            break;
        default:
            break;
    }
    
}

- (IBAction)rightButtonPressed:(UIButton *)sender
{
    self.leftButton.userInteractionEnabled = NO;
    self.rightButton.userInteractionEnabled = NO;
    
    switch (gameState) {
        case SMOKEFIRE:
            [self flipCard];
            self.smokeOrFireGuess = FIRE;
            [self smokeOrFire];
            
            break;
        case HIGHLOW:
            NSLog(@"right button - state: highLow");
            [self flipCard];
            self.highOrLowGuess = LOW;;
            [self highOrLow];
            
            break;
        case INOUT:
            NSLog(@"right button - state: inOut");
            [self flipCard];
            self.inOrOutGuess = OUT;
            [self inOrOut];
            
            break;
        case SUIT:
            NSLog(@"right button - state: suit");
            self.firstSuit.userInteractionEnabled = NO;
            self.secondSuit.userInteractionEnabled = NO;
            [self flipCard];
            self.suitGuess = @"♠︎";
            [self whichSuit];
            
            break;
        default:
            break;
    }
    
}

- (IBAction)firstSuitPressed:(UIButton *)sender
{
    self.firstSuit.userInteractionEnabled = NO;
    self.secondSuit.userInteractionEnabled = NO;
    self.leftButton.userInteractionEnabled = NO;
    self.rightButton.userInteractionEnabled = NO;
    NSLog(@"firstSuit button - state: suit");
    [self flipCard];
    self.suitGuess = @"♦︎";
    [self whichSuit];
}

- (IBAction)secondSuitPressed:(UIButton *)sender
{
    self.firstSuit.userInteractionEnabled = NO;
    self.secondSuit.userInteractionEnabled = NO;
    self.leftButton.userInteractionEnabled = NO;
    self.rightButton.userInteractionEnabled = NO;
    NSLog(@"secondSuit button - state: suit");
    [self flipCard];
    self.suitGuess = @"♣︎";
    [self whichSuit];
}

#pragma mark - Game Logic

/* Card image movement for each gameState */

- (void) smokeOrFire
{
    [self performSelector:@selector(moveCardToPositionIndex:) withObject:[NSNumber numberWithInt:SMOKEFIRE] afterDelay:2.0];
    [self setStatusLabelForCorrect:[self checkSmokeOrFire]];
    
//    [self.CorrectOrDrinkLabel sizeToFit];
    self.CorrectOrDrinkLabel.hidden = NO;
}

- (void) highOrLow
{
    [self performSelector:@selector(moveCardToPositionIndex:) withObject:[NSNumber numberWithInt:HIGHLOW] afterDelay:2.0];
    [self setStatusLabelForCorrect:[self checkHigherLower]];
    
//    [self.CorrectOrDrinkLabel sizeToFit];
    self.CorrectOrDrinkLabel.hidden = NO;
}

- (void) inOrOut
{
    [self performSelector:@selector(moveCardToPositionIndex:) withObject:[NSNumber numberWithInt:INOUT] afterDelay:2.0];
    [self setStatusLabelForCorrect:[self checkInOut]];
    
//    [self.CorrectOrDrinkLabel sizeToFit];
    self.CorrectOrDrinkLabel.hidden = NO;
}

- (void) whichSuit
{
    [self performSelector:@selector(moveCardToPositionIndex:) withObject:[NSNumber numberWithInt:SUIT] afterDelay:2.0];
    [self setStatusLabelForCorrect:[self checkSuit]];
    
//    [self.CorrectOrDrinkLabel sizeToFit];
    self.CorrectOrDrinkLabel.hidden = NO;
}

#pragma mark - Game State


/* Game State for SMOKEFIRE, HIGHLOW, INOUT, and SUIT */
- (void) moveCardToPositionIndex:(NSNumber *)num
{
    if (gameState != SUIT)
    {
        self.leftButton.userInteractionEnabled = YES;
        self.rightButton.userInteractionEnabled = YES;
    }
    
    NSInteger index = [num integerValue];
    self.CorrectOrDrinkLabel.hidden = YES;
    
    switch (index) {
        case SMOKEFIRE:
        {
            /* make Rect frame */
            CGRect btFrame = self.displayCard.frame;
            btFrame.origin.x = 15;
            btFrame.origin.y = 30;
            
            /* turn displayCard over to back side */
            [self.displayCard setBackgroundImage:[UIImage imageNamed:@"cardBack"] forState:UIControlStateNormal];
            [self.displayCard setTitle:@"" forState:UIControlStateNormal];
            
            /* initializes and moves card to first position */
            self.firstCard = [[UIButton alloc] initWithFrame:btFrame];
            [self.firstCard setBackgroundImage:[UIImage imageNamed:@"cardFront"] forState:UIControlStateNormal];
            [self.firstCard setTitle:[self.currentCard contents] forState:UIControlStateNormal];
            [self setTextColor:self.firstCard];
            self.firstCard.userInteractionEnabled = NO;
            [self.view addSubview:self.firstCard];
            
            /* initialzes and sets first thumb Image View */
            self.ThumbView1 = [[UIImageView alloc] initWithFrame:CGRectMake(29.5, 130, 30, 30)];
            if (self.correctLabelStatus == YES)
                self.ThumbView1.image = [UIImage imageNamed:@"ThumbUp"];
            else
                self.ThumbView1.image = [UIImage imageNamed:@"ThumbDown"];
            [self.view addSubview:self.ThumbView1];
            
            NSLog(@"%@", [self.currentCard contents]);
            
            /* change to next gameState */
            gameState = HIGHLOW;
            [self initButtons];
            
            break;
        }
        case HIGHLOW:
        {
            /* make Rect frame */
            CGRect btFrame = self.displayCard.frame;
            btFrame.origin.x = 90;
            btFrame.origin.y = 30;
            
            /* turn displayCard over to back side */
            [self.displayCard setBackgroundImage:[UIImage imageNamed:@"cardBack"] forState:UIControlStateNormal];
            [self.displayCard setTitle:@"" forState:UIControlStateNormal];
            
            /* initializes and moves card to second position */
            self.secondCard = [[UIButton alloc] initWithFrame:btFrame];
            [self.secondCard setBackgroundImage:[UIImage imageNamed:@"cardFront"] forState:UIControlStateNormal];
            [self.secondCard setTitle:[self.currentCard contents] forState:UIControlStateNormal];
            [self setTextColor:self.secondCard];
            self.secondCard.userInteractionEnabled = NO;
            [self.view addSubview:self.secondCard];
            
            /* initializes and sets second thumb Image View */
            self.ThumbView2 = [[UIImageView alloc] initWithFrame:CGRectMake(104.5, 130, 30, 30)];
            if (self.correctLabelStatus == YES)
                self.ThumbView2.image = [UIImage imageNamed:@"ThumbUp"];
            else
                self.ThumbView2.image = [UIImage imageNamed:@"ThumbDown"];
            [self.view addSubview:self.ThumbView2];

            NSLog(@"%@", [self.currentCard contents]);
            
            /* change to next gameState */
            gameState = INOUT;
            [self initButtons];
            
            break;
        }
        case INOUT:
        {
            /* make Rect frame */
            CGRect btFrame = self.displayCard.frame;
            btFrame.origin.x = 165;
            btFrame.origin.y = 30;
            
            /* turn displayCard over to back side */
            [self.displayCard setBackgroundImage:[UIImage imageNamed:@"cardBack"] forState:UIControlStateNormal];
            [self.displayCard setTitle:@"" forState:UIControlStateNormal];
            
            /* initializes and moves card to third position */
            self.thirdCard = [[UIButton alloc] initWithFrame:btFrame];
            [self.thirdCard setBackgroundImage:[UIImage imageNamed:@"cardFront"] forState:UIControlStateNormal];
            [self.thirdCard setTitle:[self.currentCard contents] forState:UIControlStateNormal];
            [self setTextColor:self.thirdCard];
            self.thirdCard.userInteractionEnabled = NO;
            [self.view addSubview:self.thirdCard];
            
            /* initializes and sets third thumb Image View */
            self.ThumbView3 = [[UIImageView alloc] initWithFrame:CGRectMake(180, 130, 30, 30)];
            if (self.correctLabelStatus == YES)
                self.ThumbView3.image = [UIImage imageNamed:@"ThumbUp"];
            else
                self.ThumbView3.image = [UIImage imageNamed:@"ThumbDown"];
            [self.view addSubview:self.ThumbView3];

            NSLog(@"%@", [self.currentCard contents]);
            
            /* change to next gameState */
            gameState = SUIT;
            [self initButtons];
            
            break;
        }
        case SUIT:
        {
            /* make Rect frame */
            CGRect btFrame = self.displayCard.frame;
            btFrame.origin.x = 240;
            btFrame.origin.y = 30;
            
            /* turns displayCard over to back side */
            [self.displayCard setBackgroundImage:[UIImage imageNamed:@"cardBack"] forState:UIControlStateNormal];
            [self.displayCard setTitle:@"" forState:UIControlStateNormal];
            
            /* initializes and moves card to fourth position */
            self.fourthCard = [[UIButton alloc] initWithFrame:btFrame];
            [self.fourthCard setBackgroundImage:[UIImage imageNamed:@"cardFront"] forState:UIControlStateNormal];
            [self.fourthCard setTitle:[self.currentCard contents] forState:UIControlStateNormal];
            [self setTextColor:self.fourthCard];
            self.fourthCard.userInteractionEnabled = NO;
            [self.view addSubview:self.fourthCard];
            
            /* initialzes and sets fourth thumb Image View */
            self.ThumbView4 = [[UIImageView alloc] initWithFrame:CGRectMake(255, 130, 30, 30)];
            if (self.correctLabelStatus == YES)
                self.ThumbView4.image = [UIImage imageNamed:@"ThumbUp"];
            else
                self.ThumbView4.image = [UIImage imageNamed:@"ThumbDown"];
            [self.view addSubview:self.ThumbView4];

            NSLog(@"%@", [self.currentCard contents]);
            
            /* change to next gameState */
            gameState = REPLAY;
            [self initButtons];
            
            break;
        }
        default:
            break;
    }
    
}
- (IBAction)PlayAgain:(id)sender {
    [self viewDidLoad];
}

/* Additional helper methods */
- (void) setStatusLabelForCorrect:(BOOL)correct
{
    if (correct)
    {
        self.CorrectOrDrinkLabel.text = @"CORRECT";
        self.correctLabelStatus = YES;
    }
    else
    {
        self.CorrectOrDrinkLabel.text = @"WRONG";
        self.correctLabelStatus = NO;
    }
}

- (void) clearStatusLabel
{
    self.CorrectOrDrinkLabel.text = @"";
}

- (void) setTextColor:(UIButton *)button
{
    if ([PlayingCard smokeOrFire:self.currentCard] == FIRE)
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    else
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}


@end