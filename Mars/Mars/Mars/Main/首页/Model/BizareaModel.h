//
//  BizareaModel.h
//  Mars
//
//  Created by Macx on 16/2/2.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import <Foundation/Foundation.h>
//首页商圈店铺model

@interface BizareaModel : NSObject
@property (nonatomic,copy)NSString *storeID;    //id
@property (nonatomic,copy)NSString *name;       //name
@property (nonatomic,copy)NSString *englishName;//english_name
@property (nonatomic,copy)NSString *headPic;    //headpic
@property (nonatomic,copy)NSArray *storesEnglishName;//store_english_name合集
@property (nonatomic,copy)NSArray *storesName;  //store_name合集
@property (nonatomic,copy)NSArray *storesHeadpic;  //headpic合集
@end
