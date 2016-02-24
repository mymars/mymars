//
//  ToplistView.m
//  Mars
//
//  Created by Macx on 16/2/17.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "ToplistView.h"
#import "ToplistModel.h"

@implementation ToplistView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        [self _createScrollView:self];
    }

    return self;
}

- (void)_createScrollView:(UIView *)superView {
    
    UIScrollView *_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 100)];
    
    CGFloat imageViewWidth = kScreenWidth - 100;
    CGFloat spaceWidth = 10;                        //间隔宽度
    
    _scrollView.contentSize = CGSizeMake(imageViewWidth * 5 + spaceWidth * 7, 0);
    
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView.backgroundColor = [UIColor clearColor];
    
    [superView addSubview:_scrollView];
    
    for (int i = 0; i < 5; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewWidth * i + spaceWidth * (i + 1), 0, imageViewWidth, 100)];
        
        imageView.tag = 100 + i;
        
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        
        [imageView addGestureRecognizer:tap];
        
        [_scrollView addSubview:imageView];
        
    }
}

-(void)setToplistModelArray:(NSArray *)toplistModelArray {

    if (toplistModelArray != _toplistModelArray) {
        _toplistModelArray = toplistModelArray;
        
        if (toplistModelArray.count > 4) {
            
            for (int i = 0; i < 5; i++) {
        
                [((UIImageView *)[self viewWithTag:100 + i]) sd_setImageWithURL:[NSURL URLWithString:((ToplistModel *)_toplistModelArray[i]).cover]];
            }
        }
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    for (int i = 0; i < 5; i++) {
        
        UIImageView *imageView = [self viewWithTag:100 + i];
        
        CGPoint point = [tap locationInView:imageView];
        
        if (point.x >= 0 && point.x <= imageView.bounds.size.width) {
      
            if (_toplistModelArray.count == 0) {
                
            }
            else {
                
                NSString *storeID = ((ToplistModel *)_toplistModelArray[i]).storeID;
                
                NSString *urlString = [NSString stringWithFormat:@"http://www.yohomars.com/api/v1/topic/topic/info?app_version=1.1.0&client_secret=%@&client_type=iphone&id=%@&os_version=9.2.1&screen_size=320x480&session_code=010024f1f93417b8c879922cdf649e64&v=1", [self clientSecret:storeID], storeID];

//http://www.yohomars.com/api/v1/topic/topic/info?app_version=1.1.0&client_secret=%@&client_type=iphone&id=%@&os_version=9.2.1&screen_size=320x480&session_code=010024f1b6b4fded0e8cd238c4c0b42c&v=1
                if (self.block) {
                    self.block(urlString);
                }
            }
        }
    }
}

- (NSString *)clientSecret:(NSString *)storeID {
    
    NSDictionary *dicConfig = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ClientSecretShangHai.plist" ofType:nil]];
    
    NSString *str = dicConfig[storeID];
    
    if (str.length == 0) {
        NSLog(@"出现了未知storeid以及对应密码");
    }
    
    return str.length > 0 ? str : nil;
}

@end
