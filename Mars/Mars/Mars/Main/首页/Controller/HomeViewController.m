//
//  HomeViewController.m
//  Mars
//
//  Created by Macx on 16/1/28.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "HomeViewController.h"
#import "UIImageView+WebCache.h"
#import "ToplistModel.h"
#import "BizareaModel.h"
#import "CommentModel.h"
#import "BizareaView.h"
#import "CommentView.h"
#import "ToplistView.h"

static NSString *bizareaIdentify = @"bizarea";
static NSString *commentIdentify = @"comment";

@interface HomeViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy)NSMutableArray *topicModelArr;
@property (nonatomic,copy)NSMutableArray *bizareaModelArr;
@property (nonatomic,copy)NSMutableArray *commentModelArr;
@property (nonatomic,strong)UITableView *tableView;


@end

@implementation HomeViewController


/**
 *  主页面中scrollview的图片加载完毕后,应当将图片存起来,下次从下方拖动回第一行时再次加载回来,现在有个问题就是页面拉下去拉回来后,原来加载的图片没有了
 *
 *  @param storeID <#storeID description#>
 *
 *  @return <#return value description#>
 */

//- (NSString *)clientSecret:(NSString *)storeID {
//    
//    NSDictionary *dicConfig = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ClientSecretShangHai.plist" ofType:nil]];
//    
//    NSString *str = dicConfig[storeID];
//    
//    if (str.length == 0) {
//        NSLog(@"出现了未知storeid以及对应密码");
//    }
//    
//    return str.length > 0 ? str : nil;
//}

- (void)mainViewToplistDataWithUrl:(NSURL *)url {
    
    NSURLSessionDataTask *datatask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!data || error) {
            NSLog(@"mainViewToplistDataWithUrl中加载数据失败");
            return ;
        }
        
        NSError *jsonError = NULL;
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        
        if (jsonError) {
            NSLog(@"jsonError = %@",jsonError);
            return;
        }
        if (dic) {
            NSArray *list = [dic[@"data"] objectForKey:@"list"];
            if (list) {
                
                for (int i = 0; i < 6; i++) {
//                    NSLog(@"%@",[list[i] objectForKey:@"id"]);
                    NSString *str = [list[i] objectForKey:@"cover"];
                    
                    str = [self imageUrlDeleteImageView:str];
                    
                    ToplistModel *model = [[ToplistModel alloc] init];
                    
                    model.storeID = [list[i] objectForKey:@"id"];
                    model.cover = str;
                    
                    [_topicModelArr addObject:model];
                    
//                    NSURL *url = [NSURL URLWithString:str];
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                        [((UIImageView *)[self.view viewWithTag:100 + i]) sd_setImageWithURL:url];
//                    });
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [_tableView reloadData];
                        NSLog(@"mainViewToplistDataWithUrl加载完数据刷新tableview");
                    });
//                    
                }
            }
        }
        
    }];
    
    [datatask resume];
}

- (void)mainViewBizareaDataWithUrl:(NSURL *)url {

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!data || error) {
            NSLog(@"mainViewBizareaDataWithUrl中加载数据失败");
            return ;
        }
        
        NSError *jsonError = NULL;
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        
        if (jsonError) {
            NSLog(@"jsonError = %@",jsonError);
            return;
        }
        if (dic) {
            NSArray *list2 = [dic[@"data"] objectForKey:@"list_2"];
            if (list2) {
                for (int i = 0; i < list2.count; i++) {
                    BizareaModel *model = [[BizareaModel alloc]init];
                    model.bizareaID = [list2[i] objectForKey:@"id"];
                    model.name = [list2[i] objectForKey:@"name"];
                    model.englishName = [list2[i] objectForKey:@"english_name"];
                    NSString *str = [list2[i] objectForKey:@"headpic"];
                    model.headPic = [self imageUrlDeleteImageView:str];
                    
                    NSMutableArray *storesEnglishName = [NSMutableArray array];
                    NSMutableArray *storesHeadPic = [NSMutableArray array];
                    NSMutableArray *storesName = [NSMutableArray array];
                    
                    NSArray *stores = [list2[i] objectForKey:@"stores"];

                    if (stores) {
                        for (int j = 0; j < stores.count; j++) {
                            
                            [storesEnglishName addObject:[stores[j] objectForKey:@"store_english_name"]];
                            
                            [storesName addObject:[stores[j] objectForKey:@"store_name"]];
                            
                            NSString *headpic = [stores[j] objectForKey:@"headpic"];
                            
                            [storesHeadPic addObject:[self imageUrlDeleteImageView:headpic]];
                        }
                        model.storesEnglishName = storesEnglishName;
                        model.storesHeadpic = storesHeadPic;
                        model.storesName = storesName;
                    }
                    [_bizareaModelArr addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [_tableView reloadData];
                    NSLog(@"mainViewBizareaDataWithUrl加载完数据刷新tableview");
                });
            }
        }
    }];
    
    [task resume];
}

- (void)mainViewCommentDataWithUrl:(NSURL *)url {

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!data || error) {
            NSLog(@"mainViewCommentDataWithUrl中加载数据失败");
            return ;
        }
        
        NSError *jsonError = NULL;
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        
        if (jsonError) {
            NSLog(@"jsonError = %@",jsonError);
            return;
        }
        if (dic) {

            NSArray *list = [dic[@"data"] objectForKey:@"list"];
            if (list) {
                for (int i = 0; i < list.count; i++) {
                    CommentModel *model = [[CommentModel alloc] init];
                    model.publishTimeStr = [list[i] objectForKey:@"publish_time_str"];
                    NSString *str = [((NSArray *)[list[i] objectForKey:@"img"])[0] objectForKey:@"url"];
                    model.imgUrl = [self imageUrlDeleteImageView:str];
                    model.commentDescription = [list[i] objectForKey:@"description"];
                    model.storeEnglishName = [[list[i] objectForKey:@"store"] objectForKey:@"store_english_name"];
                    model.storeName = [[list[i] objectForKey:@"store"] objectForKey:@"store_name"];
                    model.nickName = [[list[i] objectForKey:@"user"] objectForKey:@"nickname"];
                    str = [[list[i] objectForKey:@"user"] objectForKey:@"headpic"];
                    model.userHeadpic = [self imageUrlDeleteImageView:str];
                    
                    [_commentModelArr addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [_tableView reloadData];
                    NSLog(@"mainViewCommentDataWithUrl加载完数据刷新tableview");
                });
            }
            
        }
    }];
    [task resume];
}

//-------------------------------以上是3个模块加载data--------------------------------

- (NSString *)imageUrlDeleteImageView:(NSString *)str {
//取下来的网址是http://img01.yohomars.com/mars/2016/01/19/80d4ee3c3cbf6e8be71d7bab73dfe657.jpg?imageView/{mode}/w/{width}/h/{height}
    if (str.length == 0) {
        return @"";
    }

    if ([str rangeOfString:@"?imageView/{mode}/w/{width}/h/{height}"].location != NSNotFound) {
        
        NSString *strDelete = @"?imageView/{mode}/w/{width}/h/{height}";
        
        NSString *subStr = [str substringToIndex:str.length - strDelete.length];
        
        return subStr;
    }
    else {
        return str;
    }
}

//- (void)postRequestString:(NSString *)urlString {
//    
//    //获取_scrollview上的专题列表data
//    
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
//
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
//    
//    request.HTTPMethod = @"POST";
//    
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
//    
//    [task resume];
//    
//}

#pragma mark - CreateView

- (void)_createTableView {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - self.tabBarController.tabBar.height - CGRectGetMinY(self.navigationController.navigationBar.frame))];
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:bizareaIdentify];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:commentIdentify];
    
    [self.view addSubview:_tableView];
    

}

//- (void)_createScrollView:(UIView *)superView {
//
//    UIScrollView *_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 80)];
//    
//    CGFloat imageViewWidth = kScreenWidth - 100;
//    CGFloat spaceWidth = 10;                        //间隔宽度
//    
//    _scrollView.contentSize = CGSizeMake(imageViewWidth * 6 + spaceWidth * 7, 0);
//    
//    _scrollView.showsVerticalScrollIndicator = NO;
//    _scrollView.showsHorizontalScrollIndicator = NO;
//    
//    _scrollView.backgroundColor = [UIColor clearColor];
//    
//    [superView addSubview:_scrollView];
//    
//    for (int i = 0; i < 6; i++) {
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewWidth * i + spaceWidth * (i + 1), 0, imageViewWidth, 80)];
//        
//        imageView.backgroundColor = [UIColor redColor];
//        
//        imageView.tag = 100 + i;
//        
//        imageView.userInteractionEnabled = YES;
//        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//        
//        [imageView addGestureRecognizer:tap];
//        
//        [_scrollView addSubview:imageView];
//        
//    }
//
//
//}
- (void)_createToplistView:(UIView *)superView withToplistModelArray:(NSArray *)modelArr {
    
    for (UIView *view in superView.subviews) {
        if ([view isKindOfClass:[ToplistView class]]) {
            [view removeFromSuperview];
        }
    }
    
    ToplistView *toplistView = [[ToplistView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    
    [superView addSubview:toplistView];
    
    toplistView.toplistModelArray = modelArr;
}

- (void)_createEyeIconView:(UIView *)superView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    imageView.image = [UIImage imageNamed:@"FOCUS.png"];
    
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 100, 40)];
    
    label.text = @"随便看看";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:18];
    
    [view addSubview:label];
    
    [superView addSubview:view];
}

- (void)_createBizareaView:(UIView *)superView withBizareaModel:(BizareaModel *)model {

    for (UIView *view in superView.subviews) {
        if ([view isKindOfClass:[BizareaView class]]) {
            [view removeFromSuperview];
        }
    }
    
    BizareaView *bizareaView = [[NSBundle mainBundle] loadNibNamed:@"Bizarea" owner:self options:nil].lastObject;
    
    CGFloat height = model.storesHeadpic.count < 4 ? 250 : 340;
    
    bizareaView.frame = CGRectMake(10, 0, kScreenWidth - 20, height);
    
    [superView addSubview:bizareaView];
    
    bizareaView.bizareaModel = model;
}

- (void)_createCommentView:(UIView *)superView withCommentModel:(CommentModel *)model {

    for (UIView *view in superView.subviews) {
        if ([view isKindOfClass:[CommentView class]]) {
            [view removeFromSuperview];
        }
    }
    
    CommentView *commentView = [[NSBundle mainBundle] loadNibNamed:@"CommentView" owner:self options:nil].lastObject;

    commentView.frame = CGRectMake(0, 0, kScreenWidth, 120);
    
    [superView addSubview:commentView];
    
    commentView.commentModel = model;


}

#pragma mark - Tap Action

//- (void)tapAction:(UITapGestureRecognizer *)tap {
//
//    for (int i = 0; i < 6; i++) {
//        
//        UIImageView *imageView = [self.view viewWithTag:100 + i];
//        
//        CGPoint point = [tap locationInView:imageView];
//        
//        if (point.x >= 0 && point.x <= imageView.bounds.size.width) {
//            NSLog(@"%d",i);
//            
//            if (_topicModelArr.count == 0) {
//                
//            }
//            else {
//            
//                NSString *storeID = ((ToplistModel *)_topicModelArr[i]).storeID;
//                
//                NSString *urlString = [NSString stringWithFormat:@"http://www.yohomars.com/api/v1/topic/topic/info?app_version=1.0.2&client_secret=%@&client_type=iphone&id=%@&os_version=9.2&screen_size=320x480&session_code=010024f105c73c448946c26bd951f6aa&v=1", [self clientSecret:storeID], storeID];
//
//                [self postRequestString:urlString];
//                
//                NSLog(@"%@",urlString);
//
//            }
//        }
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _createTableView];
    
    if (_bizareaModelArr == nil) {
        _bizareaModelArr = [NSMutableArray array];
        _topicModelArr = [NSMutableArray array];
        _commentModelArr = [NSMutableArray array];
    }

    [self mainViewToplistDataWithUrl:[NSURL URLWithString:mainTopicUrlString]];
    [self mainViewBizareaDataWithUrl:[NSURL URLWithString:mainBizareaUrlString]];
    [self mainViewCommentDataWithUrl:[NSURL URLWithString:mainCommentUrlString]];
    
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//一个scrollview,一个eyeicon
    return 1 + 1 + _bizareaModelArr.count + _commentModelArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        
        [self _createToplistView:cell.contentView withToplistModelArray:_topicModelArr];
        
        cell.backgroundColor = [UIColor clearColor];
     
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    if (indexPath.row == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self _createEyeIconView:cell.contentView];
        
        return cell;
    }
    if (indexPath.row > 1 && indexPath.row <= _bizareaModelArr.count + 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bizareaIdentify forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        [self _createBizareaView:cell.contentView withBizareaModel:_bizareaModelArr[indexPath.row - 2]];
        
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentIdentify forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    [self _createCommentView:cell.contentView withCommentModel:_commentModelArr[indexPath.row - _bizareaModelArr.count - 2]];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        return 100;
    }
    if (indexPath.row == 1) {
        return 40;
    }
    if (indexPath.row > 1 && indexPath.row <= _bizareaModelArr.count + 1) {

        return ((BizareaModel *)_bizareaModelArr[indexPath.row - 2]).storesHeadpic.count < 4 ? 260 : 350;
    }
    return 120;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
