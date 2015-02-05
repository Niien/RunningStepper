//
//  ViewController.m
//  runningCounter
//
//  Created by Longfatown on 1/20/15.
//  Copyright (c) 2015 Longfatown. All rights reserved.
//
#import "location.h"
#import "ViewController.h"
#import "StepCounter.h"
@import AssetsLibrary;  //  儲存照片用
#import "myPlist.h"     // 顯示隊伍照片用

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate>
{
    //因為不能直接接parse下來的東西 所以設個用來接的變數
    NSString *username,*useradward,*userLV,*userPower;

    //接parse
    //====== Parse
    PFObject *addInfo;
    PFQuery *getInfo;
    //====== Parse
    
    StepCounter *stepCounter;
    
    //改變照片
    UIImagePickerController *imagePicker;
    
    CLLocationManager *locationManager;
    CLLocation *userLocation;
    NSArray *getData;
    //
    UIImageView *TeamImageView1;
    UIImageView *TeamImageView2;
    UIImageView *TeamImageView3;
    UIImageView *TeamImageView4;
    UIImageView *TeamImageView5;
    
    NSArray *TeamArray;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    locationManager = [CLLocationManager new];
    
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        
        [locationManager requestAlwaysAuthorization];
    }
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    
    
//======    預設圖片 / 改變圖片
    [self ChangeImageBtn];
    
    //有暫存 就套用
    NSUserDefaults *UserImageTmp = [NSUserDefaults standardUserDefaults];
    if ([UserImageTmp objectForKey:@"UserImageTmp"]) {
        NSLog(@"有暫存");
        NSString *Ttmp = [NSString stringWithFormat:@"%@",[UserImageTmp objectForKey:@"UserImageTmp"]];
        _UserImageView.image = [UIImage imageNamed:Ttmp];
        _UserImageView.contentMode = UIViewContentModeScaleAspectFit;}
    else {
        //若無暫存 就抓預設圖
        NSLog(@"無暫存");
        _UserImageView.image = [UIImage imageNamed:@"GG2.jpg"];
        _UserImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
//======    改變圖片結束
    
    
//======    個人素質Label
    stepCounter = [StepCounter shareStepCounter];
    [stepCounter startStepCounter];

    _UserLVLabel.text = [NSString stringWithFormat:@"累積能量：%ld",(long)stepCounter.power] ;
//    _UserPowerLabel.text = [NSString stringWithFormat:@"今天走了:%ld 步",(long)stepCounter.stepNB] ;//userPower;
    NSLog(@"VC %ld",(long)stepCounter.stepNB);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(powerLabel) name:@"StepCounter" object:nil];
    
//======    個人素質完成
    
    
    //for test
//    NSDictionary *dict = @{@"name":@"pikachu", @"image":@"5.png", @"iconName":@"5s.png", @"Lv":@"1", @"exp":@"0", @"id":@"5",@"attack":@"100",@"lat":@"24.965235", @"lon":@"121.193882"};
//    NSArray *arr = [[NSArray alloc]initWithObjects:dict, nil];
//    [[myPlist shareInstanceWithplistName:@"MyPokemon"]saveDataWithArray:arr];
    
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *usertmp = [NSUserDefaults standardUserDefaults];
    if ([usertmp objectForKey:@"username"] == nil) {
        _UserNameLabel.text = @"訓練師：Guest";
        _UserAdwardLabel.text = @"稱號：走走看看";
    }else{
        _UserNameLabel.text = [NSString stringWithFormat:@"訓練師：%@",[usertmp objectForKey:@"username"]];
        _UserAdwardLabel.text = [NSString stringWithFormat:@"稱號：%@",[usertmp objectForKey:@"useradward"]];
    }
    _UserLVLabel.text = [NSString stringWithFormat:@"累積能量：%ld",(long)stepCounter.power] ;
    _UserPowerLabel.text = [NSString stringWithFormat:@"今天走了：%ld 步",(long)stepCounter.stepNB];
    
    //
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 增加步數（精力）
-(void) powerLabel{
    _UserLVLabel.text = [NSString stringWithFormat:@"累積能量：%ld",(long)stepCounter.power];
    _UserPowerLabel.text = [NSString stringWithFormat:@"今天走了：%ld 步",(long)stepCounter.stepNB];
    
}

#pragma mark Parse設定
-(void)myParseSetting{
//    ====== Parse
//    初始化
        getInfo = [[PFQuery alloc]initWithClassName:@"BattleUser"];
//    Label 取值
    //...
}

#pragma mark 變更照片
- (IBAction)ChangeImageBtn{
    //
    UIImagePickerControllerSourceType targetType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //Check it availble or not
    if ([UIImagePickerController isSourceTypeAvailable:targetType]==NO) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"SourceType is not availble" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    imagePicker = [UIImagePickerController new];
    imagePicker.sourceType = targetType;
    imagePicker.mediaTypes = @[@"public.image"];
    //增加可編輯項
    imagePicker.allowsEditing = YES;
    
    imagePicker.delegate = self;
    //show出來
    [self presentViewController:imagePicker animated:YES completion:^{
        //
    }];
}

#pragma mark 選完圖的動作
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //把選到的圖指派到我們的image上
    /*  //直接用
     UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
     _ImageView.image = originalImage;
     */
    //可編輯
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    _UserImageView.image = [self modifyWithImage:editedImage];
    
    //Save Image 0.8是壓縮率 越小品質越差
    NSData *data = UIImageJPEGRepresentation(_UserImageView.image, 0.8);
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString *fileName = [documentPath stringByAppendingPathComponent:@"image.jpg"];
    [data writeToFile:fileName atomically:NO];
    NSLog(@"Document:%@",documentPath);
    
    //檔名暫存
    NSUserDefaults *UserImageTmp = [NSUserDefaults standardUserDefaults];
    [UserImageTmp setObject:fileName forKey:@"UserImageTmp"];
    
    //save to album 為上傳雲端用
    ALAssetsLibrary *library = [ALAssetsLibrary new];
    [library writeImageToSavedPhotosAlbum:_UserImageView.image.CGImage
                              orientation:(ALAssetOrientation)_UserImageView.image.imageOrientation
                          completionBlock:^(NSURL *assetURL, NSError *error) {
                              NSLog(@"did save");
                          }];

    //選完返回
    [imagePicker dismissViewControllerAnimated:YES completion:^{//
    }];
    
    //結束時釋放
    imagePicker = nil;
    
}

#pragma mark 編輯圖像
-(UIImage *) modifyWithImage:(UIImage*)sourceImage{
    
    //若app需要使用到大量的圖片 此時縮圖就很重要
    CGSize targetWithImage = CGSizeMake(500,500);
    
    //C語言的方法做的 在底層 有加速
    UIGraphicsBeginImageContext(targetWithImage);
    
    //縮小到虛擬畫布上
    [sourceImage drawInRect:CGRectMake(0, 0, targetWithImage.width, targetWithImage.height)];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    //記得結束!!!
    UIGraphicsEndImageContext();
    
    return result;
}

#pragma mark - locationManager delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    [[location share]setUserLocation:[locations lastObject]];
    userLocation = [locations lastObject];
//    NSLog(@"%f,%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    
}


@end
