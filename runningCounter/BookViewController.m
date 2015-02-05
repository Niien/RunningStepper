//
//  BookViewController.m
//  runningCounter
//
//  Created by chiawei on 2015/1/20.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//


#import "BookViewController.h"
#import "LocalDBManager.h"

@interface BookViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    
    NSArray *data;
    NSMutableArray *catchedPokemons;

}



@end

@implementation BookViewController

static NSString * const reuseIdentifier = @"CollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    catchedPokemons = [NSMutableArray new];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Do any additional setup after loading the view.
    
    
    /*
    // sqlite
    NSArray *table = [NSArray arrayWithObjects:@"ID",@"Name",@"URL", nil];
    NSArray *data = [NSArray arrayWithObjects:@"ABC",@"CBA",@"google.com", nil];
    [[myDB sharedInstance]insertCustNo_TableName:@"MypokemonsImage" TableArray:table TableInside:data];
    
    NSArray *a = [NSArray arrayWithArray:[[myDB sharedInstance] queryCust_TableName:@"MypokemonsImage" TableArray:table OrderBy:@"ID"]];
    NSLog(@"a:%@",a);
    */
    
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    data = [[myPlist shareInstanceWithplistName:@"MyPokemon"]getDataFromPlist];
    
    //NSLog(@"BookView:%@",data);
    
    //catchedPokemons = [[LocalDBManager sharedInstance] queryCatchedPokemon];
    
    [self.collectionView reloadData];
    
}

// hide status bar
- (BOOL)prefersStatusBarHidden {
    
    return YES;
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

    //return [catchedPokemons count];
    return [data count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    //NSString *imageName = [NSString stringWithFormat:@"%@",[[catchedPokemons objectAtIndex:indexPath.row] objectForKey:@"image"]];
    
    NSString *imageName = [NSString stringWithFormat:@"%@",[[data objectAtIndex:indexPath.row] objectForKey:@"image"]];
    
    UIImage *image = [UIImage imageNamed:imageName];
    cell.myImage.image = image;
//    UIImage *tmpImage = [UIImage imageNamed:imageName];
//        //加上邊框之類的
//    UIImage *frameImage = [UIImage imageNamed:@"poke_frame(500).png"];
//    UIGraphicsBeginImageContext(tmpImage.size);
//    [tmpImage drawInRect:CGRectMake(0, 0, tmpImage.size.width, tmpImage.size.height)];
//    [frameImage drawInRect:CGRectMake(0, 0, tmpImage.size.width, tmpImage.size.height)];
//    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//    
//    cell.myImage.image = resultImage;
    
    cell.LvLabel.text = [NSString stringWithFormat:@"Lv:%@",[[data objectAtIndex:indexPath.row]objectForKey:@"LV"]];
    
    return cell;
    
}



#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10.0, 5.0, 20.0, 5.0);
    
}



#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    pokemonDetailViewController *pdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"pokemonDetail"];
    
    pdvc.numberOfIndex = indexPath.row;
    
    [self presentViewController:pdvc animated:YES completion:nil];
    
}

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
