//
//  ChatImageCell.h
//  ChatApplication
//
//  Created by Faizan on 9/20/15.
//  Copyright (c) 2015 Postagain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <ParseUI/ParseUI.h>
@interface ChatImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet PFImageView *imgViewCapture;

@end
