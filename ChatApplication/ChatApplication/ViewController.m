//
//  ViewController.m
//  ChatApplication
//
//  Created by Faizan on 9/20/15.
//  Copyright (c) 2015 Postagain. All rights reserved.
//

#import "ViewController.h"
#import "ChatViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ChatViewController"])
    {
        ChatViewController *objView = segue.destinationViewController;
        objView.strName = strName;
    }
}
- (IBAction)roomAction:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"What is your name"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:@"Confirm",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
   
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@", [alertView textFieldAtIndex:0].text);
    if(buttonIndex ==1)
    {
        strName = [alertView textFieldAtIndex:0].text;
        if(strName.length>0)
        {
           
            
            
            [self performSegueWithIdentifier:@"ChatViewController" sender:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please enter your name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    
}
@end
