//
//  LastCell.h
//  Mars
//
//  Created by Macx on 16/2/19.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LastCell : UITableViewCell
{
    
    __weak IBOutlet UIImageView *_imageView1;
    __weak IBOutlet UIImageView *_imageView2;
    __weak IBOutlet UIImageView *_imageView3;
    __weak IBOutlet UIImageView *_imageView4;
}

@property (nonatomic,strong)NSMutableArray *arr4;
@end
