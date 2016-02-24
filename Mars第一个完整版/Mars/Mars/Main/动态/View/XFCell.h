//
//  XFCell.h
//  Mars
//
//  Created by Macx on 16/2/23.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewsModel;
@interface XFCell : UITableViewCell
{
    __weak IBOutlet UIImageView *_img1;
    
    __weak IBOutlet UIImageView *_img2;
    __weak IBOutlet UILabel *_title;
}

@property (nonatomic, strong)NewsModel *model;
@end
