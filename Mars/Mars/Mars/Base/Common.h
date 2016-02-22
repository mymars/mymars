//
//  Common.h
//  Mars
//
//  Created by Macx on 16/1/28.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#ifndef Common_h
#define Common_h




#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define mainTopicUrlString @"http://www.yohomars.com/api/v1/topic/topics/topiclist?app_version=1.1.0&city_id=890&client_secret=94fd1ba885c653d4edf37f20c6449be3&client_type=iphone&limit=6&os_version=9.2.1&page=1&rand=1&screen_size=320x480&session_code=010024f16074694d2b8692dfe4704488&v=1"
#define mainBizareaUrlString @"http://www.yohomars.com/api/v1/bizarea/bizareas/index?app_version=1.1.0&city_id=890&client_secret=680c99d0980b872ca908989b1e6e6952&client_type=iphone&limit_1=3&limit_2=6&os_version=9.2.1&radius=1&screen_size=320x480&session_code=010024f11dfcb4e9e654557476530243&v=1"
#define mainCommentUrlString @"http://www.yohomars.com/api/v1/comment/comments/commentlist?app_version=1.1.0&city_id=890&client_secret=f4e1aafad89442cbccafd3228ecf5b10&client_type=iphone&is_auth=0&limit=20&os_version=9.2.1&page=1&screen_size=320x480&session_code=010024f1613c19f19ee65e8d7c9cd383&show_comments=0&type=0&v=1"

#import "UIView+ext.h"
#import "UIImageView+WebCache.h"


#endif /* Common_h */
