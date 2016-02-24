//
//  TrendsViewController.m
//  Mars
//
//  Created by Macx on 16/1/28.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "TrendsViewController.h"
#import "XFCell.h"
#import "NewsModel.h"
@interface TrendsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *arr;
}
@end

@implementation TrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _createTableView];
    [self _requestData];
}

- (void)_requestData {
    arr = [NSMutableArray array] ;
    
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"http://www.yohomars.com/api/v1/bizarea/bizareas/index?app_version=1.0.2&city_id=2&client_secret=b2d3c06e5c660df3a1484dd8bd0f5517&client_type=iphone&limit_1=3&limit_2=6&os_version=9.2.1&radius=1&screen_size=320x568&session_code=00ffc80f207f8153b7c0cea94759ce74&v=1"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!data || error) {
            NSLog(@"mainViewCommentDataWithUrl中加载数据失败");
            return ;
        }
        
        NSError *jsonError = NULL;
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        //                NSLog(@"dic = %@",dic);
        if (jsonError) {
            //            NSLog(@"jsonError = %@",jsonError);
            return;
        }
        
        if (dic) {
            
            //            NSString *url = [self imageUrlDeleteImageView:[data objectForKey:@"headpic"]];
            //                        NSLog(@"%@",url);
            //            [_imgView sd_setImageWithURL:[NSURL URLWithString:url]];
            NSArray *list1 = [dic[@"data"] objectForKey:@"list_2"] ;
            
            NSDictionary *data = list1[0];
       
            NSArray *list = data[@"stores"];
            
            if (list) {
                for (int i = 0; i < list.count; i++) {
                    NewsModel *model = [[NewsModel alloc] init];
                    model.img1 = [self imageUrlDeleteImageView:[list[i] objectForKey:@"icon"]];
                    
                    model.img2 = [self imageUrlDeleteImageView:[list[i] objectForKey:@"headpic"]];
                    
                    model.title = [list[i] objectForKey:@"store_name"];
//                    model.title1 = [list[i] objectForKey:@"description"];
//                    model.title = [list[i] objectForKey:@"store_english_name"];
//                    NSLog(@"%@",model.title1);
//                    NSArray *array = [list[i] objectForKey:@"pics"];
//                    
//                    if (array.count == 3) {
//                        model.img3 = [self imageUrlDeleteImageView:[array[0] objectForKey:@"url"]];
//                        model.img4 = [self imageUrlDeleteImageView:[array[1] objectForKey:@"url"]];
//                        model.img5 = [self imageUrlDeleteImageView:[array[2] objectForKey:@"url"]];
//                    }
//                    
                    [arr addObject:model];
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                        // 进入刷新状态后会自动调用这个block
                        [_tableView reloadData];
                        [self performSelector:@selector(_delay) withObject:nil afterDelay:1];
                    }];
                    
                    [_tableView.mj_header beginRefreshing];
                    
                    NSLog(@"mainViewCommentDataWithUrl加载完数据刷新tableview");
                    
                });
            }
            
        }
    }];
    [task resume];
    
    
    
}

- (void)_createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"XFCell" bundle:nil] forCellReuseIdentifier:@"identity100"];
//    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_delay {
    [_tableView.mj_header endRefreshing];
}
#pragma  - mark UITableViewDelegate 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arr.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XFCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identity100" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = arr[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 270;
    
}

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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
