//
//  BottomGrayView.m
//  Mars
//
//  Created by Macx on 16/2/23.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "BottomGrayView.h"

@implementation BottomGrayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.2];
    }
    return self;
}

@end
