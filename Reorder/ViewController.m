//
//  ViewController.m
//  Reorder
//
//  Created by Lance Sigersmith on 12/9/18.
//  Copyright © 2018 Lance Sigersmith. All rights reserved.
//

#import "ViewController.h"
#import "Tile.h"

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)closeFinish:(id)sender {
    finished.hidden = YES;
}
- (IBAction)changeLevel:(id)sender {
    NSInteger tag = [sender tag];
    switch (tag) {
        case 3:
            level = 3;
            break;
        case 4:
            level = 4;
            break;
        case 5:
            level = 5;
            break;
        case 6:
            level = 6;
            break;
        default:
            break;
    }
    
    [self viewDidLoad];
}
- (void)checkOrder {
    int correct = 0;
    NSInteger limit = (level * level) + 1;
    for (int i=1; i<limit; i++) {
        Tile *tileH = [board viewWithTag:i];
        if ((tileH.position == i)) {
            correct ++;
            NSLog(@"tag %d", i);
            NSLog(@"position %ld", (long)tileH.position);
        }
    }
    NSLog(@"%d", correct);
    if (correct == ((level * level))) {
        NSLog(@"YOU WIN");
        UILabel *movesLbl = [finished viewWithTag:2];
        movesLbl.text = [NSString stringWithFormat:@"%ld", (long) moves];
        UILabel *timeLbl = [finished viewWithTag:1];
        timeLbl.text = [NSString stringWithFormat:@"%ld", (long) time];
        finished.hidden = NO;
        [self.view bringSubviewToFront:finished];
        [stopwatch invalidate];
        stopwatch = nil;
    }
}
- (void)moveTile: (id)sender {
    NSLog(@"tap tpa tap");
    
    Tile *tappedTile = (Tile *)[sender view];
    NSInteger emptyPositionT = emptyPosition;
    NSInteger tappedPosition = tappedTile.position;
    NSLog(@"Empty Position: %ld", (long)emptyPosition);
    NSLog(@"Tapped Position: %ld", (long)tappedPosition);
    
    if (tappedTile.position == emptyPosition-1 || tappedTile.position == emptyPosition+1 || tappedTile.position == emptyPosition+level || tappedTile.position == emptyPosition-level) {
        Tile *empty = [board viewWithTag:(level * level)];
        CGRect emptyRect = empty.frame;
        CGRect tappedRect = tappedTile.frame;
        
        empty.frame = tappedRect;
        tappedTile.frame = emptyRect;
        
        emptyPosition = tappedPosition;
        empty.position = tappedPosition;
        tappedTile.position = emptyPositionT;
        
        moves++;
    }
    [self checkOrder];
}

- (void)updateTime {
    time++;
    timeL.text = [NSString stringWithFormat:@"%ld", (long)time];
}
- (void)validatePositions {
    //for (int i=1; i<((level*level) + 1); i++) {
        //NSLog(@"Validate:%ld", (long)testInt);
        //NSLog(@"%d", i);
        //NSLog(@"RANDS: %@", rands);
    NSLog(@"We valid");
    NSLog(@"L %ld", (long)level);
    int limit = (level * level);
    NSLog(@"%i", limit);
    int inversions = 0;
    int i = 0;
    for (NSNumber *num in rands) {
        NSLog(@"%@", num);
        if ([num intValue] == limit) {
            NSLog(@"BLANK");
        } else {
            for (NSNumber *num2 in rands) {
                NSLog(@"NUM2: %@", num2);
                if ([rands indexOfObject:num2] < i) {NSLog(@"Num comes before/invalid: %@", num2);} else {
                    if ([num2 intValue] == ((level * level)+1)) {NSLog(@"nope nope");}
                    if ([num intValue] > [num2 intValue]) {
                    inversions++;
                    NSLog(@"Inversion:%@ > %@", num, num2);
                }
                }
            }
        }
        i++;
    }
    NSLog(@"INV: %i", inversions);
    if (inversions % 2 == 0) {
        NSLog(@"Solvable");
    } else {
        NSLog(@"Not Solvable");
        [self viewDidLoad];
    }
}
- (void)viewDidLoad {
    
    finished.hidden = YES;
    moves = 0;
    time = 0;
    if ([self.view viewWithTag:100]) {
        [[self.view viewWithTag:100] removeFromSuperview];
        for (UIView *view in [board subviews]) {
            [view removeFromSuperview];
        }
    }
    int maxy = (CGRectGetMaxY([self view].frame)) - [self view].frame.size.width;
    int y = maxy - 100;
    board = [[UIView alloc] initWithFrame:CGRectMake(0, y, [self view].frame.size.width, [self view].frame.size.width)];
    board.tag = 100;
    //board.backgroundColor = [UIColor blackColor];//[UIColor colorWithRed:.233 green:.172 blue:.117 alpha:0.5];
    [self.view addSubview:board];
    
    int width = ([self view].frame.size.width / (level));
    int xt = 4;
    int yt = 0;
    rands = [[NSMutableArray alloc] init];
    NSUInteger rand = 0;
    NSInteger total = (level * level) + 1;
    for (int i=1; i<total; i++) {
        //CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
        Tile *tile = [[Tile alloc] initWithFrame:CGRectMake(xt, yt, width - 8, width)];
        //tile.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor blackColor]);
        tile.layer.borderWidth = 1.0f;
        tile.backgroundColor = [UIColor colorWithRed:.233 green:.172 blue:.117 alpha:0.5];
        tile.layer.cornerRadius = 5;
        
        BOOL t = FALSE;
        while (t == FALSE) {
        NSInteger limit = level * level;
        rand = arc4random_uniform(limit) + 1;
            if ([rands containsObject:[NSNumber numberWithInteger:rand]]) {} else {
                t = TRUE;
                [rands addObject:[NSNumber numberWithInteger:rand]];
                NSLog(@"got one");
                NSLog(@"%lu", (unsigned long)rand);
            }
        }
        
        tile.tag = (int) rand;
        tile.position = i;
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(tile.frame.size.width / 2, (tile.frame.size.width / 2) - 20, tile.frame.size.width, tile.frame.size.height)];
        NSInteger emptySpot = level * level;
        if (rand==emptySpot) {
            tile.backgroundColor = [UIColor whiteColor];
            emptyPosition = i;
        } else {
            lbl.text = [NSString stringWithFormat:@"%ld", (unsigned long)rand];
        }

        if (i % level == 0) {
            xt = 4;
            yt = yt + width + 4;
        } else {
            xt = xt + width;
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moveTile:)];
        if (rand != emptySpot) {
            [tile addGestureRecognizer:tap];
        }
        
        [board addSubview:tile];
        [tile addSubview:lbl];
        
        //[self view].backgroundColor = [UIColor brownColor];
        [stopwatch invalidate];
        stopwatch = nil;
        stopwatch = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        if (!testInt) {
            testInt = 0;
        }
        testInt++;
        
    }
    [self validatePositions];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


@end
