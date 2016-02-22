//
//  MyCell.h
//  Mars
//
//  Created by Macx on 16/2/19.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCell : UITableViewCell
{
    __weak IBOutlet UIImageView *_imageView1;
    __weak IBOutlet UILabel *_label1;
    
    __weak IBOutlet UIImageView *_imageView2;
    __weak IBOutlet UILabel *_label2;
    __weak IBOutlet UIImageView *_imageView3;
    __weak IBOutlet UILabel *_label3;
    __weak IBOutlet UIImageView *_imageView4;
    __weak IBOutlet UILabel *_label4;
    __weak IBOutlet UIImageView *_imageView5;
    
    __weak IBOutlet UILabel *_label5;
    __weak IBOutlet UIImageView *_imageView6;
    __weak IBOutlet UILabel *_label6;
    __weak IBOutlet UIImageView *_imageView7;
    __weak IBOutlet UILabel *_label7;
    __weak IBOutlet UIImageView *_imageView8;
    __weak IBOutlet UILabel *_label8;
    __weak IBOutlet UIImageView *_imageView9;
    __weak IBOutlet UILabel *_label9;
}

@property (nonatomic,strong)NSMutableArray *arr3;
@end
