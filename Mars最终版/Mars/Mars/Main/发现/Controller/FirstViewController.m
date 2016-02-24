//
//  FirstViewController.m
//  Mars
//
//  Created by Macx on 16/2/20.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "FirstViewController.h"
#import "Cell1.h"
#import "Cell1Model.h"
@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *arr;


}
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self _createTableView];
    [_tableView registerNib:[UINib nibWithNibName:@"Cell1" bundle:nil] forCellReuseIdentifier:@"identity11"];
    [self _requestData];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)_requestData {
    arr = [NSMutableArray array] ;


    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"http://www.yohomars.com/api/v1/store/stores/storelist?app_version=1.0.2&biz_area_id=&category_id=9&city_id=2&client_secret=4cf3c828b5da14f73125cd1b13910ed1&client_type=iphone&limit=10&order_by=&os_version=9.2.1&page=1&screen_size=320x568&session_code=00ffc80fe84d2d5ec42d133ca04bfdd1&v=1"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
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
            
            NSArray *list = [dic[@"data"] objectForKey:@"list"] ;
            
            if (list) {
                for (int i = 0; i < list.count; i++) {
                   
                    Cell1Model *model = [[Cell1Model alloc] init];
                    model.img1 = [self imageUrlDeleteImageView:[list[i] objectForKey:@"icon"]];

                    model.img2 = [self imageUrlDeleteImageView:[list[i] objectForKey:@"headpic"]];
                    model.title = [[list[i] objectForKey:@"bizinfo"] objectForKey:@"english_name"];
                    NSArray *array = [list[i] objectForKey:@"pics"];

                    if (array.count == 3) {
                        model.img3 = [self imageUrlDeleteImageView:[array[0] objectForKey:@"url"]];
                        model.img4 = [self imageUrlDeleteImageView:[array[1] objectForKey:@"url"]];
                        model.img5 = [self imageUrlDeleteImageView:[array[2] objectForKey:@"url"]];
                    }
               
                    [arr addObject:model];
                }

            
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                        // 进入刷新状态后会自动调用这个block
                        [_tableView reloadData];
                        [self performSelector:@selector(_delay) withObject:nil afterDelay:1];
                    }];
                    
                    [_tableView.mj_header beginRefreshing];
                    
//                    [_activityView stopAnimating];
                    NSLog(@"mainViewCommentDataWithUrl加载完数据刷新tableview");

                });
            }
            
        }
    }];
    [task resume];
    
    
}
- (void)_delay {
    [_tableView.mj_header endRefreshing];
}

- (void)_createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
   
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = NO;

    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma mark - UITableViewDegelate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    Cell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"identity11" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.model = arr[indexPath.row];

    return cell;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 350;
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
