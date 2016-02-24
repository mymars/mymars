//
//  ToplistIndexView.h
//  Mars
//
//  Created by Macx on 16/2/18.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ToplistIndexModel;
typedef void(^TopicInfoImageShowBlock) (NSDictionary *);
@interface ToplistIndexView : UIView
@property (nonatomic,strong)ToplistIndexModel *toplistIndexModel;
@property (nonatomic,assign)NSInteger indexCount;     //第几个店铺
@property (nonatomic,copy)TopicInfoImageShowBlock topicInfoImageShowBlock;
@end
