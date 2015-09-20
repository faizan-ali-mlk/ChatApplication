//
//  ChatViewController.m
//  ChatApplication
//
//  Created by Faizan on 9/20/15.
//  Copyright (c) 2015 Postagain. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatTextCell.h"
#import "ChatImageCell.h"



@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tblViewChat.estimatedRowHeight = 40.0;
    self.tblViewChat.rowHeight = UITableViewAutomaticDimension;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow :) name:UIKeyboardWillChangeFrameNotification object:nil];
    
   
    [[ NSNotificationCenter  defaultCenter] addObserver:self  selector:@selector(keyboardWillHide :) name: UIKeyboardWillHideNotification object: nil ];
    
    objChatArray = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Chats"];
    [query setLimit: 5000];
    [SVProgressHUD show];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            objChatArray = [objects mutableCopy];
            [self.tblViewChat reloadData];
            [self.tblViewChat scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:objChatArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        else
        {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [self performSelector:@selector(loadData) withObject:nil afterDelay:5];
        [SVProgressHUD dismiss];
    }];
    

    // Do any additional setup after loading the view.
}
-(void)loadData
{
    PFObject *lastChat = [objChatArray lastObject];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Chats"];
    [query whereKey:@"createdAt" greaterThan:lastChat.createdAt];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            [objChatArray addObjectsFromArray:objects];
            [self.tblViewChat reloadData];
             [self.tblViewChat scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:objChatArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        else
        {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [self performSelector:@selector(loadData) withObject:nil afterDelay:5];
        
    }];
}
- ( void ) keyboardWillShow :( NSNotification  *) Notification {
    NSDictionary  * info = [Notification userInfo];
    NSValue  * kbFrame = [info objectForKey: UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval  animationDuration = [[info objectForKey: UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    
    CGFloat height = keyboardFrame.size.height;
    
    NSLog ( @ "Updating constraints." );
    // Because the "space" is actually the difference between the bottom lines of the 2 views,
    // We need to set a negative constant value here.
    self.keyboarContraint.constant = height;
    
    [UIView animateWithDuration: animationDuration animations: ^ {
        [ self .view layoutIfNeeded];
    }];
}

- ( void ) keyboardWillHide :( NSNotification  *) Notification {
    NSDictionary  * info = [Notification userInfo];
    NSTimeInterval  animationDuration = [[info objectForKey: UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.keyboarContraint.constant = 0;
    [UIView animateWithDuration: animationDuration animations: ^ {
        [ self .view layoutIfNeeded];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return objChatArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *objChat = [objChatArray objectAtIndex:indexPath.row];
    
    if(objChat[@"Chat"])
    {
        ChatTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatTextCell" forIndexPath:indexPath];
        NSString *name = objChat[@"Name"];
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: %@",objChat[@"Name"],objChat[@"Chat"]]] ;
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]} range:NSMakeRange(0, name.length+1)];

        
        cell.lblChat.attributedText = attributedText;
        [cell.lblChat sizeToFit];
    
        return cell;
    }
    else
    {
        ChatImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatImageCell" forIndexPath:indexPath];
        cell.lblName.text = objChat[@"Name"];
        cell.imgViewCapture.image = [UIImage imageNamed:@"placeholder.jpg"];
        cell.imgViewCapture.file = (PFFile*)objChat[@"Image"];
        [cell.imgViewCapture loadInBackground];
        //cell.imageView.image = [UIImage imageNamed:@"Camera.jpg"];
        
        return cell;
    }
}

- (IBAction)cameraAction:(id)sender
{
    UIActionSheet *popupMenu = [[UIActionSheet alloc] initWithTitle:@"image selection" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"take photo", @"choose from gallary", nil];
    popupMenu.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupMenu showInView:self.view];

}

- (IBAction)sendAction:(id)sender
{
    PFObject *objChat = [PFObject objectWithClassName:@"Chats"];
    objChat[@"Name"] = self.strName;
    objChat[@"Chat"] = self.txtFieldChat.text;
    [objChat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [objChatArray addObject:objChat];
            [self.tblViewChat reloadData];
            [self.tblViewChat scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:objChatArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            self.txtFieldChat.text = @"";
            [self.txtFieldChat resignFirstResponder];
        } else {
            //This block never executes.
        }
    }];

   
    
    
}
#pragma mark HelpingMethods
-(void)takePhoto:(id)delegate {
    
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Alert!"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    else
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = delegate;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [delegate presentViewController:picker animated:YES completion:NULL];
    }
    
}
-(void)selectPhoto:(id)delegate{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Alert!"
                                                              message:@"Photo gallary is not available"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
        
    }
    else
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = delegate;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [delegate presentViewController:picker animated:YES completion:NULL];
    }
    
    
}
#pragma mark ActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {
        
        NSLog(@"Take Photo");
        [self takePhoto:self];
    }
    else if (buttonIndex == 1)
    {
        
        NSLog( @"Gallary Choose");
        [self selectPhoto:self];
        
    }
    else if (buttonIndex == 2)
    {
        
        NSLog( @"Cancel Button Clicked");
        
    }
    
}


#pragma mark ImagePickerViewDelegates
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *selectedImage =  [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData *imageData = UIImageJPEGRepresentation(selectedImage,0);
        PFFile *objFile = [PFFile fileWithData:imageData];
        [objFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
            [SVProgressHUD dismiss];
            
            PFObject *objChat = [PFObject objectWithClassName:@"Chats"];
            objChat[@"Name"] = self.strName;
            objChat[@"Image"] = objFile;
            [objChat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [objChatArray addObject:objChat];
                    [self.tblViewChat reloadData];
                     [self.tblViewChat scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:objChatArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                } else
                {
                    //This block never executes.
                }
            }];
           
        } progressBlock:^(int percentDone)
        {
            [SVProgressHUD showProgress:percentDone];
            // Update your progress spinner here. percentDone will be between 0 and 100.
        }];
       

        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
@end
