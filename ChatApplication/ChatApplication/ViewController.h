//
//  ViewController.h
//  ChatApplication
//
//  Created by Faizan on 9/20/15.
//  Copyright (c) 2015 Postagain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    NSString *strName;
   
}
@property (weak, nonatomic) IBOutlet UIButton *btnJoinRoom;
- (IBAction)roomAction:(id)sender;

@end

