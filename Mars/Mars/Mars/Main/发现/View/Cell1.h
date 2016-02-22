//
//  Cell1.h
//  Mars
//
//  Created by Macx on 16/2/20.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Cell1Model;
@interface Cell1 : UITableViewCell
{
    __weak IBOutlet UIImageView *_imgView1;
    
    __weak IBOutlet UIImageView *_imgView2;
    __weak IBOutlet UIImageView *_imgView3;
    __weak IBOutlet UIImageView *_imgView4;
    __weak IBOutlet UIImageView *_imgView5;
    __weak IBOutlet UILabel *_label;
}
@property (nonatomic, strong)Cell1Model *model;
@end
