//
//  NewViewController.m
//  DongHua
//
//  Created by mac on 14-8-26.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "NewViewController.h"
#import "MainViewController.h"
#import "TwoViewController.h"
@interface NewViewController ()

@end

@implementation NewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.rippleImageName = @"background.jpg";  //REQUIRED BEFORE CALL [super viewDidLoad]
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"单击突出";
            break;
        case 1:
            cell.textLabel.text = @"长按抖动";
            break;
        case 2:
            cell.textLabel.text = @"拖动换位";
            break;
        case 3:
            cell.textLabel.text = @"拖动换位-自动";
            break;
        case 4:
            cell.textLabel.text = @"抖动+换位";
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 4)
    {
        MainViewController * mainVC = [[MainViewController alloc]init];
        mainVC.flag = indexPath.row;
        [self.navigationController pushViewController:mainVC animated:YES];
    }
    else
    {
        TwoViewController * TwoVC = [[TwoViewController alloc]init];
        [self.navigationController pushViewController:TwoVC animated:YES];
        
        
    }
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
