//
//  ChangingHeightLabel.m
//  Mars
//
//  Created by Macx on 16/2/22.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "ChangingHeightLabel.h"

@implementation ChangingHeightLabel

- (instancetype)initWithFrame:(CGRect)frame withString:(NSString *)text withFlag:(BOOL)isClick withSuperView:(UIView *)superView
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:17];
        self.numberOfLines = 0;
        
        [superView addSubview:self];
        
        self.text = text;
        
        CGFloat heightBase = [@"测试用的单行文字高度" boundingRectWithSize:CGSizeMake(kScreenWidth, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size.height;
        CGFloat height = [text boundingRectWithSize:CGSizeMake(kScreenWidth, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size.height;
        
        NSInteger x = height / heightBase;
        if (x <= 3) {
            self.height = height;
        }
        if (x > 3) {
            
            self.height = isClick ? height : 65;
            
            UIImageView *clickImage = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 10) / 2.0, 65, 10, 10)];
            clickImage.image = isClick ? [UIImage imageNamed:@"small_arrow_up_icon"] : [UIImage imageNamed:@"small_arrow_icon"];
            
            clickImage.bottom = superView.bottom - 10;
            
            [superView addSubview:clickImage];
        }
    }
    return self;
}

@end
