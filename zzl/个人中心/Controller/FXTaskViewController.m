
//
//  FXTaskViewController.m
//  zzl
//
//  Created by Mr_Du on 2017/11/14.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXTaskViewController.h"
#import "FXTaskCell.h"
#import "FXTaskModel.h"
@interface FXTaskViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong) NSArray * cellConfigArr;
@end

@implementation FXTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"任务中心";
    [self.view addSubview:self.tableView];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self loadTastListData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellConfigArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * reuseId = @"cell";
    FXTaskCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[FXTaskCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    NSInteger index;
    if (indexPath.section==1) {
        index = indexPath.row+4;
    }else{
        index = indexPath.row;
    }
    cell.model = self.cellConfigArr[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return Py(10);
    }
    return 0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @" ";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Py(60);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FXTaskModel *model = self.cellConfigArr[indexPath.row];
    if ([model.status isEqualToString:@"1"]) {
        [self loadRawAwardDataWithType:model.sign_type];
    }
}

#pragma mark 获取用户任务列表
- (void)loadTastListData{
    NSString *path = @"load_sign";
    NSDictionary *params = @{@"uid":KUID};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            self.cellConfigArr = [FXTaskModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark 领取任务奖励
- (void)loadRawAwardDataWithType:(NSString *)type{
    NSString *path = @"raw_award1";
    NSDictionary *params = @{@"uid":KUID,@"type":type};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            [MBProgressHUD showSuccess:@"领取成功" toView:self.tableView];
            [self loadTastListData];
            
            NSInteger mark = [dic[@"data"][@"ward_id"] integerValue];
            switch (mark) {
                case 1:
                    [MobClick event:@"pay_one_game"];
                    break;
                case 2:
                    [MobClick event:@"task_center_shared"];
                    break;
                case 3:
                    [MobClick event:@"get_one_baby"];
                    break;
                case 4:
                    [MobClick event:@"get_three_baby"];
                    break;
                case 5:
                    [MobClick event:@"get_10baby"];
                    break;
                case 9:
                    [MobClick event:@"shared_friends_10"];
                    break;
                case 7:
                    [MobClick event:@"everyday_pay"];
                    break;
                case 8:
                    [MobClick event:@"signin_seven_days"];
                    break;
                default:
                    break;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserData" object:nil];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark lazy load

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BGColor;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorColor =DYGColorFromHex(0xe6e6e6);
    }
    return _tableView;
}
-(NSArray *)cellConfigArr{
    if (!_cellConfigArr) {
        _cellConfigArr = [NSArray array];
                           
    }
    return _cellConfigArr;
}



@end
