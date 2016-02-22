//
//  HomeViewController.m
//  Mars
//
//  Created by Macx on 16/1/28.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "HomeViewController.h"
<<<<<<< Updated upstream
#import "ToplistModel.h"
#import "BizareaModel.h"
#import "CommentModel.h"
#import "ToplistIndexModel.h"
#import "BizareaView.h"
#import "CommentView.h"
#import "ToplistView.h"
#import "TopicInfoController.h"
#import "BizareaInfoController.h"

static NSString *bizareaIdentify = @"bizarea";
static NSString *commentIdentify = @"comment";

@interface HomeViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy)NSMutableArray *topicModelArr;
@property (nonatomic,copy)NSMutableArray *bizareaModelArr;
@property (nonatomic,copy)NSMutableArray *commentModelArr;
@property (nonatomic,strong)UITableView *tableView;
=======
>>>>>>> Stashed changes

@interface HomeViewController ()

@end

@implementation HomeViewController

<<<<<<< Updated upstream

/**
 *
 *
 1 http://www.yohomars.com/api/v1/topic/topic/info?app_version=1.1.0&client_secret=6f3d06a5702153f757d8ce1313087e76&client_type=iphone&id=125&os_version=9.2.1&screen_size=320x480&session_code=010024f1926716510bd396baf63f5034&v=1
 这段网址中session_code要经常通过抓包更新,否则会出错.
 2检查所有代码,保证是在主线程中进行ui刷新,防止不定期的崩溃
 
 *  @param storeID <#storeID description#>
 *
 *  @return <#return value description#>
 */

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
//                NSInteger count = list.count > 6 ? 6 : list.count;
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
                    
                    [_tableView reloadData];
                    NSLog(@"mainViewToplistDataWithUrl加载完数据刷新tableview");
                });
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

//-------------------------------以上是3个模块加载maindata--------------------------------

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

#pragma mark - CreateView

- (void)_createTableView {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - self.tabBarController.tabBar.height - CGRectGetMinY(self.navigationController.navigationBar.frame))];
    
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:bizareaIdentify];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:commentIdentify];
    
    [self.view addSubview:_tableView];
    

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
        self.tabBarController.tabBar.hidden = YES;

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _createTableView];
    self.navigationController.navigationBar.translucent = NO;
    
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


=======
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

>>>>>>> Stashed changes
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
