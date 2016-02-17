//
//  CommentModel.h
//  Mars
//
//  Created by Macx on 16/2/16.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property (nonatomic,copy)NSString *nickName;       //nickname用户名
@property (nonatomic,copy)NSString *publishTimeStr; //publish_time_str多久前发出
@property (nonatomic,copy)NSString *storeName;      //store_name
@property (nonatomic,copy)NSString *storeEnglishName;//store_english_name
@property (nonatomic,copy)NSString *imgUrl;         //img数组内的url,是评论model的图片
@property (nonatomic,copy)NSString *userHeadpic;
@property (nonatomic,copy)NSString *commentDescription;

@end
