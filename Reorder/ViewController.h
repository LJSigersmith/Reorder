//
//  ViewController.h
//  Reorder
//
//  Created by Lance Sigersmith on 12/9/18.
//  Copyright © 2018 Lance Sigersmith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    UIView *board;
    NSInteger emptyPosition;
    NSInteger level;
    
    NSInteger moves;
    NSInteger time;
    
    NSTimer *stopwatch;
    
    IBOutlet UIView *finished;
    IBOutlet UILabel *timeL;
    IBOutlet UIButton *x;
    
    NSInteger testInt;
    NSMutableArray *rands;
}

-(IBAction)changeLevel:(id)sender;
-(IBAction)closeFinish:(id)sender;
@end

