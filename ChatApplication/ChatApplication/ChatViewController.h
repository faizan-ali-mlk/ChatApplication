//
//  ChatViewController.h
//  ChatApplication
//
//  Created by Faizan on 9/20/15.
//  Copyright (c) 2015 Postagain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <SVProgressHUD.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ChatViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    NSMutableArray *objChatArray ;
}
@property (nonatomic,strong)NSString *strName;

@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldChat;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;

@property (weak, nonatomic) IBOutlet UITableView *tblViewChat;
- (IBAction)cameraAction:(id)sender;
- (IBAction)sendAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboarContraint;
@end
