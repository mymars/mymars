//
//  MyScrollView.m
//  Mars
//
//  Created by Macx on 16/2/18.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "MyScrollView.h"
#import "Model2.h"
#import "DiscoverViewController.h"
@implementation MyScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _arr = [NSMutableArray array];
    }
    return self;
}

-(void)setArr2:(NSMutableArray *)arr2 {
    if (arr2 != _arr2) {
        _arr2 = arr2;
        Model2 *model = [[Model2 alloc] init];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 100)];
        
        CGFloat imageViewWidth = kScreenWidth - 120;
        CGFloat spaceWidth = 10;                        //间隔宽度
        
        _scrollView.contentSize = CGSizeMake(imageViewWidth * 6 + spaceWidth * 7, 0);
        
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        _scrollView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_scrollView];
        
        for (int i = 0; i < 6; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewWidth * i + spaceWidth * (i + 1), 0, imageViewWidth, 140)];
            
            imageView.backgroundColor = [UIColor clearColor];
            
            imageView.tag = 100 + i;

            //        [imageView sd_setImageWithURL:[NSURL URLWithString:_arr[i]]];
            
                    imageView.userInteractionEnabled = YES;
            
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
            
                    [imageView addGestureRecognizer:tap];
            
            [_scrollView addSubview:imageView];

            if (arr2.count == 6) {
                model = arr2[i];

                [imageView sd_setImageWithURL:[NSURL URLWithString:model.imgName]];
            }
            
    
            
        }

      
    }
}

- (void)tapAction {
  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tap" object:self];
    
}
@end
