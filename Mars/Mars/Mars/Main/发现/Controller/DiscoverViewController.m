//
//  DiscoverViewController.m
//  Mars
//
//  Created by Macx on 16/1/28.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "DiscoverViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"
#import "MyScrollView.h"
#import "Model2.h"
#import "Model3.h"
#import "Model4.h"
#import "MyCell.h"
#import "LastCell.h"

@interface DiscoverViewController ()
{
    NSMutableArray *imageArr;
    NSMutableArray *imageArr2;
    NSMutableArray *imageArr3;
    UIActivityIndicatorView *_activityView;

}
@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_activityView];
    _activityView.color = [UIColor grayColor];
    self.navigationItem.rightBarButtonItem = item;
    [_activityView startAnimating];
    _tableView.separatorStyle = NO;
    
    [_tableView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellReuseIdentifier:@"identifity2"];
    [_tableView registerNib:[UINib nibWithNibName:@"LastCell" bundle:nil] forCellReuseIdentifier:@"identifity3"];
    _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_1-_h.png"]];
    [self _requestData2];
    [self _requestData3];
    [self _requestData4];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detail) name:@"tap" object:nil];
    
}

- (void)detail {
    SecondViewController *secVC = [[SecondViewController alloc] init];
    
    [self.navigationController pushViewController:secVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_requestData2 {
    imageArr3 = [NSMutableArray array];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"http://www.yohomars.com/api/v1/topic/topics/topiclist?app_version=1.0.2&city_id=5121&client_secret=8a31009256b74c7dd338f589c9aef9ed&client_type=iphone&limit=6&os_version=9.2.1&page=1&rand=1&screen_size=320x568&session_code=00ffc80fef07e9fe6701fc8da1e6e5c2&v=1"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!data || error) {
            NSLog(@"mainViewCommentDataWithUrl中加载数据失败");
            return ;
        }
        
        NSError *jsonError = NULL;
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        //        NSLog(@"dic = %@",dic);
        if (jsonError) {
            //            NSLog(@"jsonError = %@",jsonError);
            return;
        }

        if (dic) {
            
            NSArray *list = [dic[@"data"] objectForKey:@"list"];
            
            if (list) {
                for (int i = 0; i < list.count; i++) {
                    Model2 *model2 = [[Model2 alloc] init];
                    model2.imgName = [self imageUrlDeleteImageView:[list[i] objectForKey:@"cover"]];
                    [imageArr3 addObject:model2];
                    
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

- (void)_requestData3 {
    imageArr = [NSMutableArray array];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"http://www.yohomars.com/api/v1/bizarea/bizareas/bizlist?app_version=1.0.2&city_id=5121&client_secret=1d2a61b6995a48dadfd1f0a68629b263&client_type=iphone&limit_1=9&limit_2=10&os_version=9.2.1&page=1&screen_size=320x568&session_code=00ffc80fbb169f3968e97e1aa4e27ae5&show_stores=0&v=1"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!data || error) {
            NSLog(@"mainViewCommentDataWithUrl中加载数据失败");
            return ;
        }
        
        NSError *jsonError = NULL;
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
//        NSLog(@"dic = %@",dic);
        if (jsonError) {
//            NSLog(@"jsonError = %@",jsonError);
            return;
        }
        if (dic) {
            
            NSArray *list = [dic[@"data"] objectForKey:@"list"];

            if (list) {
                for (int i = 0; i < list.count; i++) {
                    Model3 *model3 = [[Model3 alloc] init];
                    model3.title = [list[i] objectForKey:@"english_name"];
                    
                    model3.image =[self imageUrlDeleteImageView:[list[i] objectForKey:@"headpic"]];

                    [imageArr addObject:model3];

                }
//                MyCell *cell = [[MyCell alloc] init];
//                cell.arr3 = imageArr;

                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [_tableView reloadData];
                    
                    NSLog(@"mainViewCommentDataWithUrl加载完数据刷新tableview");
                    [_activityView stopAnimating];
                });
            }
            
        }
    }];
    [task resume];
  
  
}

- (void)_requestData4 {
    imageArr2 = [NSMutableArray array];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"http://www.yohomars.com/api/v1/line/lines/linelist?app_version=1.0.2&city_id=5121&client_secret=295fa0ebe34dfa5bb768afe0d54ea89c&client_type=iphone&limit=20&os_version=9.2.1&page=1&screen_size=320x568&session_code=00ffc80fbb169f3968e97e1aa4e27ae5&v=1"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!data || error) {
            NSLog(@"mainViewCommentDataWithUrl中加载数据失败");
            return ;
        }
        
        NSError *jsonError = NULL;
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        //        NSLog(@"dic = %@",dic);
        if (jsonError) {
            //            NSLog(@"jsonError = %@",jsonError);
            return;
        }

        if (dic) {
            
            NSArray *list = [dic[@"data"] objectForKey:@"list"];
            
            if (list) {
                for (int i = 0; i < list.count; i++) {
                    Model4 *model4 = [[Model4 alloc] init];
                    model4.imageName = [self imageUrlDeleteImageView:[list[i] objectForKey:@"line_pic"]];
                    [imageArr2 addObject:model4];
                    
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
    

#pragma - mark  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifity0"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifity1"];
        MyScrollView *scrollView = [[MyScrollView alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth, 100)];
        
        for (UIView *view in cell.contentView.subviews) {
            if ([view isKindOfClass:[MyScrollView class]]) {
                [view removeFromSuperview];
            }
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:scrollView];
        scrollView.arr2 = imageArr3;
        return cell;
    }
    else if (indexPath.row == 2) {
        MyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifity2"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.arr3 = [imageArr mutableCopy];

        return cell;
       
    }

    else {
        LastCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifity3"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.arr4 = [imageArr2 mutableCopy];

        return cell;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 150;
    } else if (indexPath.row == 1) {
        return 150;
    } else if (indexPath.row == 2) {
        return 350;
    } 
    return 550;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        FirstViewController *firVC = [[FirstViewController alloc] init];
        [self.navigationController pushViewController:firVC animated:YES];
    }
    
    if (indexPath.row == 2) {
        ThirdViewController *thirdVC = [[ThirdViewController alloc] init];
        [self.navigationController pushViewController:thirdVC animated:YES];
    }
    
    if (indexPath.row == 3) {
        FourthViewController *fourVC = [[FourthViewController alloc] init];
        [self.navigationController pushViewController:fourVC animated:YES];
    }
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
