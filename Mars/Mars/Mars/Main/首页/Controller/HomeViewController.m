//
//  HomeViewController.m
//  Mars
//
//  Created by Macx on 16/1/28.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "HomeViewController.h"
#import "ToplistModel.h"
#import "BizareaModel.h"
#import "CommentModel.h"
#import "ToplistIndexModel.h"
#import "BizareaView.h"
#import "CommentView.h"
#import "ToplistView.h"
#import "TopicInfoController.h"
#import "BizareaInfoController.h"
#import "MJRefresh.h"
#import "ChooseCityView.h"

static NSString *bizareaIdentify = @"bizarea";
static NSString *commentIdentify = @"comment";

@interface HomeViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy)NSMutableArray *topicModelArr;
@property (nonatomic,copy)NSMutableArray *bizareaModelArr;
@property (nonatomic,copy)NSMutableArray *commentModelArr;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)MJRefreshGifHeader *mjHeader;
@property (nonatomic,strong)MJRefreshAutoNormalFooter *mjFooter;

@property (nonatomic,assign)BOOL isDownload1;   //判断3个模块是否都加载成功
@property (nonatomic,assign)BOOL isDownload2;
@property (nonatomic,assign)BOOL isDownload3;
@property (nonatomic,copy)NSString *locationName;//定位地点名字
@property (nonatomic,strong)ChooseCityView *choose;
@end

@implementation HomeViewController


/**

 1 http://www.yohomars.com/api/v1/topic/topic/info?app_version=1.1.0&client_secret=6f3d06a5702153f757d8ce1313087e76&client_type=iphone&id=125&os_version=9.2.1&screen_size=320x480&session_code=010024f1926716510bd396baf63f5034&v=1
 这段网址中session_code要经常通过抓包更新,否则会出错.
 
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [self _createTableView];
    
    if (_bizareaModelArr == nil) {
        _bizareaModelArr = [NSMutableArray array];
        _topicModelArr = [NSMutableArray array];
        _commentModelArr = [NSMutableArray array];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kCityChoosed]) {
        
        [self _createChooseCityView];
    }
    else {
        
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:kCityChoosed]);
        _locationName = [[NSUserDefaults standardUserDefaults] objectForKey:kCityChoosed];
        [self baseCityNameDownloadData:_locationName];
        [self _createChooseCityNaviBarButton];
    }
    
}

#pragma mark - download main data

- (void)mainViewToplistDataWithUrl:(NSURL *)url {
    
    _isDownload1 = NO;
    
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
//                NSInteger count = list.count > 6 ? 6 : list.count;
                //保证每次都只有5个data
                if (_topicModelArr.count > 0) {
                    [_topicModelArr removeAllObjects];
                }
                
                for (int i = 0; i < 5; i++) {
                    
                    ToplistModel *model = [[ToplistModel alloc] init];
                    
                    model.storeID = [list[i] objectForKey:@"id"];
                    NSString *str = [list[i] objectForKey:@"cover"];
                    str = [self imageUrlDeleteImageView:str];
                    model.cover = str;
                    model.storeDescription = [list[i] objectForKey:@"description"];
                    
                    [_topicModelArr addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [_tableView.mj_header endRefreshing];
                    [_tableView reloadData];
                    _isDownload1 = YES;
                    NSLog(@"mainViewToplistDataWithUrl加载完数据刷新tableview");
                });
            }
        }
        
    }];
    
    [datatask resume];
}

- (void)mainViewBizareaDataWithUrl:(NSURL *)url {

    _isDownload2 = NO;
    
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
                if (_bizareaModelArr.count > 0) {
                    [_bizareaModelArr removeAllObjects];
                }
                
                for (int i = 0; i < list2.count; i++) {
                    BizareaModel *model = [[BizareaModel alloc]init];
                    model.bizareaID = [list2[i] objectForKey:@"id"];
                    model.name = [list2[i] objectForKey:@"name"];
                    model.englishName = [list2[i] objectForKey:@"english_name"];
                    model.placeDesc = [list2[i] objectForKey:@"description"];
                    NSString *str = [list2[i] objectForKey:@"headpic"];
                    model.headPic = [self imageUrlDeleteImageView:str];

                    NSMutableArray *storesEnglishName = [NSMutableArray array];
                    NSMutableArray *storesHeadPic = [NSMutableArray array];
                    NSMutableArray *storesName = [NSMutableArray array];
                    NSMutableArray *storesTagName = [NSMutableArray array];
                    NSMutableArray *storesScore = [NSMutableArray array];
                    NSMutableArray *storesIcon = [NSMutableArray array];
                    NSMutableArray *storesDescription = [NSMutableArray array];
                    NSMutableArray *storesAddress = [NSMutableArray array];
                    NSMutableArray *storesIsFavorite = [NSMutableArray array];
                    NSMutableArray *storesPics = [NSMutableArray array];
                    
                    NSArray *stores = [list2[i] objectForKey:@"stores"];

                    if (stores) {
                        for (int j = 0; j < stores.count; j++) {
                            
                            [storesEnglishName addObject:[stores[j] objectForKey:@"store_english_name"]];
                            
                            [storesName addObject:[stores[j] objectForKey:@"store_name"]];
                            
                            NSString *headpic = [stores[j] objectForKey:@"headpic"];
                            
                            [storesHeadPic addObject:[self imageUrlDeleteImageView:headpic]];
                            
                            [storesTagName addObject:[((NSArray *)[stores[j] objectForKey:@"category"])[0] objectForKey:@"tag_name"]];
                            [storesScore addObject:[stores[j] objectForKey:@"score"]];
                            [storesIcon addObject:[self imageUrlDeleteImageView:[stores[j] objectForKey:@"icon"]]];
                            [storesDescription addObject:[stores[j] objectForKey:@"description"]];
                            [storesAddress addObject:[stores[j] objectForKey:@"address"]];
                            [storesIsFavorite addObject:[stores[j] objectForKey:@"is_fav"]];
                            
                            NSArray *pics = [stores[j] objectForKey:@"pics"];
                            NSMutableArray *onePics = [NSMutableArray array];
                            
                            for (int z = 0; z < pics.count; z++) {
                                [onePics addObject:[self imageUrlDeleteImageView:[pics[z] objectForKey:@"url"]]];
                            }
                            [storesPics addObject:onePics];
                        }
                        
                        model.storesEnglishName = storesEnglishName;
                        model.storesHeadpic = storesHeadPic;
                        model.storesName = storesName;
                        model.storesTagName = storesTagName;
                        model.storesScore = storesScore;
                        model.storesIcon = storesIcon;
                        model.storesDescription = storesDescription;
                        model.storesAddress = storesAddress;
                        model.storesIsFavorite = storesIsFavorite;
                        model.storesPics = storesPics;
                    }
                    [_bizareaModelArr addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [_tableView.mj_header endRefreshing];
                    [_tableView reloadData];
                    _isDownload2 = YES;
                    NSLog(@"mainViewBizareaDataWithUrl加载完数据刷新tableview");
                });
            }
        }
    }];
    
    [task resume];
}

- (void)mainViewCommentDataWithUrl:(NSURL *)url {

    _isDownload3 = NO;
    
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
//                    [_mjFooter endRefreshing];
                    [_tableView reloadData];
                    _isDownload3 = YES;
                    NSLog(@"mainViewCommentDataWithUrl加载完数据刷新tableview");
                });
            }
            
        }
    }];
    [task resume];
}

- (void)pullingDownDownload {

    [self mainViewToplistDataWithUrl:[NSURL URLWithString:mainTopicUrlStringShangHai]];
    [self mainViewBizareaDataWithUrl:[NSURL URLWithString:mainBizareaUrlStringShangHai]];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerActionPullingDown:) userInfo:nil repeats:YES];
}

- (void)pullingUpDownload {
    [self mainViewCommentDataWithUrl:[NSURL URLWithString:mainCommentUrlStringShangHai]];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerActionPullingUp:) userInfo:nil repeats:YES];
}
#pragma mark - buttonAction
- (void)chooseCity:(UIButton *)button {

    if (button.tag == 60) {
        _locationName = @"北京";
    }
    
    if (button.tag == 61) {
        _locationName = @"上海";
    }
    
    if (button.tag == 62) {
        _locationName = @"东京";

    }
    if (button.tag == 63) {
        _locationName = @"首尔";

    }
    [self baseCityNameDownloadData:_locationName];
    
    button.superview.hidden = YES;
    
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [self transitionSelectCity];
    
    [self _createChooseCityNaviBarButton];
    
    [[NSUserDefaults standardUserDefaults] setObject:_locationName forKey:kCityChoosed];

    
//    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerActionFirstDownload:) userInfo:nil repeats:YES];
   
}

- (void)baseCityNameDownloadData :(NSString *)cityName {

    if ([cityName isEqualToString:@"北京"]) {
        [self mainViewToplistDataWithUrl:[NSURL URLWithString:mainTopicUrlStringBeiJing]];
        [self mainViewBizareaDataWithUrl:[NSURL URLWithString:mainBizareaUrlStringBeiJing]];
        [self mainViewCommentDataWithUrl:[NSURL URLWithString:mainCommentUrlStringBeiJing]];
    }
    else if ([cityName isEqualToString:@"上海"]) {
        [self mainViewToplistDataWithUrl:[NSURL URLWithString:mainTopicUrlStringShangHai]];
        [self mainViewBizareaDataWithUrl:[NSURL URLWithString:mainBizareaUrlStringShangHai]];
        [self mainViewCommentDataWithUrl:[NSURL URLWithString:mainCommentUrlStringShangHai]];
        
    }
    else if ([cityName isEqualToString:@"东京"]) {
        [self mainViewToplistDataWithUrl:[NSURL URLWithString:mainTopicUrlStringTokyo]];
        [self mainViewBizareaDataWithUrl:[NSURL URLWithString:mainBizareaUrlStringTokyo]];
        [self mainViewCommentDataWithUrl:[NSURL URLWithString:mainCommentUrlStringTokyo]];
        
    }
    else if ([cityName isEqualToString:@"首尔"]) {
        [self mainViewToplistDataWithUrl:[NSURL URLWithString:mainTopicUrlStringSeoul]];
        [self mainViewBizareaDataWithUrl:[NSURL URLWithString:mainBizareaUrlStringSeoul]];
        [self mainViewCommentDataWithUrl:[NSURL URLWithString:mainCommentUrlStringSeoul]];
        
    }

}

#pragma mark - timerAction

- (void)timerActionPullingDown:(NSTimer *)timer {
    if (_isDownload1 && _isDownload2) {
        
        [timer timeInterval];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_mjHeader endRefreshing];
        });
    }
}

- (void)timerActionPullingUp:(NSTimer *)timer {
    if (_isDownload3) {
        [timer timeInterval];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_mjFooter endRefreshing];
        });
    }
}

//- (void)timerActionFirstDownload:(NSTimer *)timer {
//
//
//
//}

#pragma mark - reture ture imageurl

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

#pragma mark - transition 
- (void)transitionSelectCity {
    CATransition *ca= [CATransition animation];
    
    ca.type= @"cube";
    
    ca.subtype= kCATransitionFromRight;
    
    ca.duration= 0.3;
    
//    ca.startProgress=0.5;
    
    [self.view.layer addAnimation:ca forKey:nil];

}

#pragma mark - CreateView

- (void)_createChooseCityNaviBarButton {

    UIView *custom = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    
    custom.backgroundColor = [UIColor whiteColor];
    
    UIImageView *location = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    
    location.image = [UIImage imageNamed:@"tab_location_ic"];
    
    [custom addSubview:location];
    
    UILabel *place = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 30)];

    place.text = _locationName;
    place.textColor = [UIColor blackColor];
    place.textAlignment = NSTextAlignmentCenter;
    place.font = [UIFont systemFontOfSize:17];
    
    [custom addSubview:place];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    
    button.backgroundColor = [UIColor clearColor];
    
    [custom addSubview:button];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:custom];
    
    [button addTarget:self action:@selector(_createChooseCityView) forControlEvents:UIControlEventTouchUpInside];

}

- (void)_createChooseCityView {

    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    if (_choose == nil) {
        
        _choose = [[NSBundle mainBundle] loadNibNamed:@"ChooseCityView" owner:self options:nil].lastObject;
        _choose.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
        //        [[UIApplication sharedApplication].keyWindow addSubview:_choose];
        
        [self.view addSubview:_choose];
        
        for (int i = 0; i < 4; i++) {
            [((UIButton *)[_choose viewWithTag:60 + i]) addTarget:self action:@selector(chooseCity:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    _choose.hidden = NO;
    [self transitionSelectCity];
    
    [_topicModelArr removeAllObjects];
    [_bizareaModelArr removeAllObjects];
    [_commentModelArr removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
}

- (void)_createTableView {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - CGRectGetMinY(self.navigationController.navigationBar.frame))];
    
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:bizareaIdentify];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:commentIdentify];
    
    [self.view addSubview:_tableView];
    
//下拉刷新
    _mjHeader = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullingDownDownload)];
    
    _tableView.mj_header = _mjHeader;
    
    NSMutableArray *imageArr = [NSMutableArray array];
    for (int i = 0; i < 23; i++) {
        [imageArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"refresh%d",i]]];
    }
    
    [_mjHeader setImages:imageArr forState:MJRefreshStateRefreshing];
    
//    [_mjHeader beginRefreshing];
    
    _mjHeader.lastUpdatedTimeLabel.hidden = YES;
    _mjHeader.stateLabel.hidden = YES;
    
//上拉刷新
    
    _mjFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullingUpDownload)];
    
    _tableView.mj_footer = _mjFooter;
    

}

- (void)_createToplistView:(UIView *)superView withToplistModelArray:(NSArray *)modelArr {
    
    for (UIView *view in superView.subviews) {
        if ([view isKindOfClass:[ToplistView class]]) {
            [view removeFromSuperview];
        }
    }
    
    ToplistView *toplistView = [[ToplistView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    
    [superView addSubview:toplistView];
    
    toplistView.toplistModelArray = modelArr;

//这里开始做block,点击事件触发时,弹出视图并且加载网络.
        
    toplistView.block = ^(NSString *scrollViewIndexUrlString){

        [self toplistIndexDataDownload:scrollViewIndexUrlString];
    
    };
}

- (void)_createEyeIconView:(UIView *)superView {
    for (UIView *view in superView.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    
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
    
    bizareaView.bizereaStoreShowBlock = ^(NSDictionary *dic){
        BizareaInfoController *vc = [[BizareaInfoController alloc] init];
        vc.bizareaModel = dic[@"data"];
        vc.indexSelect = [dic[@"index"] integerValue];

        [self.navigationController pushViewController:vc animated:YES];


    };
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

#pragma mark - index data download
- (void)toplistIndexDataDownload:(NSString *)urlString {
    
//    dispatch_async(dispatch_get_main_queue(), ^{
    
        TopicInfoController *vc = [[TopicInfoController alloc] init];
        
    
        
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
            //    NSLog(@"%@",urlString);
            NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (!data || error) {
                    NSLog(@"toplistIndexDataDownload中加载数据失败");
                    return ;
                }
                
                NSError *jsonError = NULL;
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                
                if (jsonError) {
                    NSLog(@"jsonError = %@",jsonError);
                    return;
                }
                if (dic) {
                    NSDictionary *dataDic = dic[@"data"];
                    if (dataDic) {
                        ToplistIndexModel *model = [[ToplistIndexModel alloc] init];
                        model.cover = [self imageUrlDeleteImageView:dataDic[@"cover"]];
                        model.storeDescription = dataDic[@"description"];
                        model.title = dataDic[@"title"];
                        NSArray *stores = dataDic[@"stores"];
                        
                        if (stores) {
                            NSMutableArray *storesName = [NSMutableArray array];
                            NSMutableArray *storesEnglishName = [NSMutableArray array];
                            NSMutableArray *storesIcon = [NSMutableArray array];
                            NSMutableArray *storesHeadpic = [NSMutableArray array];
                            NSMutableArray *storesScore = [NSMutableArray array];
                            NSMutableArray *storesTagName = [NSMutableArray array];
                            NSMutableArray *storesBizinfo = [NSMutableArray array];
                            NSMutableArray *storesPics = [NSMutableArray array];
                            NSMutableArray *storesDesc = [NSMutableArray array];
                            NSMutableArray *storesAddress = [NSMutableArray array];
                            
                            for (int i = 0; i < stores.count; i++) {
                                [storesDesc addObject:[stores[i] objectForKey:@"desc"]];
                                [storesAddress addObject:[stores[i] objectForKey:@"address"]];
                                [storesName addObject:[stores[i] objectForKey:@"store_name"]];
                                [storesEnglishName addObject:[stores[i] objectForKey:@"store_english_name"]];
                                [storesIcon addObject:[self imageUrlDeleteImageView:[stores[i] objectForKey:@"icon"]]];
                                [storesHeadpic addObject:[self imageUrlDeleteImageView:[stores[i] objectForKey:@"headpic"]]];
                                [storesScore addObject:[stores[i] objectForKey:@"score"]];
                                [storesTagName addObject:[((NSArray *)[stores[i] objectForKey:@"category"])[0] objectForKey:@"tag_name"]];
                                [storesBizinfo addObject:[[stores[i] objectForKey:@"bizinfo"] objectForKey:@"english_name"]];
                                NSArray *pics = [stores[i] objectForKey:@"pics"];
                                if (pics) {
                                    NSMutableArray *picsArr = [NSMutableArray array];
                                    for (int j = 0; j < pics.count; j++) {
                                        [picsArr addObject:[self imageUrlDeleteImageView:[pics[j] objectForKey:@"url"]]];
                                    }
                                    [storesPics addObject:picsArr];
                                }
                            }
                            model.storesName = storesName;
                            model.storesEnglishName = storesEnglishName;
                            model.storesIcon = storesIcon;
                            model.storesHeadpic = storesHeadpic;
                            model.storesScore = storesScore;
                            model.storesTagName = storesTagName;
                            model.storesBizinfo = storesBizinfo;
                            model.storesPics = storesPics;
                            model.storesDesc = storesDesc;
                            model.storesAddress = storesAddress;
                        }
                       
                        vc.toplistIndexModel = model;
                        NSLog(@"toplistIndexDataDownload加载完数据,数据从main页面传递至topicInfo界面");
                    }
                }
            }];
            [task resume];
            
//        });
        [self.navigationController pushViewController:vc animated:YES];
//    });
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//一个scrollview,一个eyeicon
    if (_bizareaModelArr.count && _commentModelArr.count) {
        
        _tableView.mj_footer.hidden = NO;
        _tableView.mj_header.hidden = NO;
        
        return 1 + 1 + _bizareaModelArr.count + _commentModelArr.count;
    }
    _tableView.mj_footer.hidden = YES;
    _tableView.mj_header.hidden = YES;
    return 0;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    NSLog(@"indexPath = %ld",indexPath.row);
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        return 120;
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
