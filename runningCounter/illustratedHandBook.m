//
//  illustratedHandBook.m
//  runningCounter
//
//  Created by chiawei on 2015/1/31.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import "illustratedHandBook.h"


@interface illustratedHandBook () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    
    NSMutableArray *allPokemons;
    NSMutableArray *myPokemons;
    NSMutableArray *reOrderArray;
    //
    NSMutableArray *myPokemonsName;
    
    
}

@end

@implementation illustratedHandBook

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    allPokemons = [NSMutableArray new];
    reOrderArray = [NSMutableArray new];
    myPokemonsName = [NSMutableArray new];
    
    for (int i = 1; i <= ALL_POKEMON_COUNT; i++) {
        
        [allPokemons addObject:@"mystery.png"];
        [myPokemonsName addObject:@"? ? ?"];
        
    }
    
    UINavigationBar *bar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
    [self.view addSubview:bar];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    UINavigationItem * leftItem = [[UINavigationItem alloc]init];
    leftItem.leftBarButtonItem = backButton;
    bar.items = @[leftItem];
    //
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"illustratebg.png"]];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    myPokemons = [[NSMutableArray alloc]initWithArray:[[myPlist shareInstanceWithplistName:@"hadGetPokemon"]getDataFromPlist]];
    
    for (NSDictionary *dict in myPokemons) {
        
        int i = [[dict objectForKey:@"id"]intValue];
        allPokemons [i-1] = [dict objectForKey:@"image"];
        myPokemonsName [i-1] = [dict objectForKey:@"name"];
        
    }
    
    [self.collectionView reloadData];
}


// hide status bar
- (BOOL)prefersStatusBarHidden {
    
    return YES;
}


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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [allPokemons count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
//    cell.illustrateImage.image = [UIImage imageNamed:[allPokemons objectAtIndex:indexPath.row]];
    
    UIImage *tmpImage = [UIImage imageNamed:[allPokemons objectAtIndex:indexPath.row]];
    //開始加入邊框
    UIImage *frameImage = [UIImage imageNamed:@"poke_frame(500).png"];
    UIGraphicsBeginImageContext(tmpImage.size);
    [tmpImage drawInRect:CGRectMake(0, 0, tmpImage.size.width, tmpImage.size.height)];
    [frameImage drawInRect:CGRectMake(0, 0, tmpImage.size.width, tmpImage.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //加入邊框結束
    cell.illustrateImage.image = resultImage;
    
    cell.illustrateLabel.text = [NSString stringWithFormat:@"%@",[myPokemonsName objectAtIndex:indexPath.row]];
    

    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MapViewController *mvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    
    if (![[allPokemons objectAtIndex:indexPath.row]isEqualToString:@"mystery.png"]) {
        
        mvc.pictureName = [allPokemons objectAtIndex:indexPath.row];
        
        [self presentViewController:mvc animated:YES completion:nil];
        
    }
    
}



#pragma mark - collection view delegate flowlayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(45.0, 5.0, 20.0, 5.0);
    
}


#pragma mark - button 

- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
