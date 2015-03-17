//
//  ViewController.m
//  EMCoreData
//
//  Created by Adward on 15/3/17.
//  Copyright (c) 2015年 iDouKou. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Entity.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *ageText;
@property (weak, nonatomic) IBOutlet UITextField *sexText;
@property (retain, nonatomic) AppDelegate *myAppDelegate;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _myAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
}
- (IBAction)exitTextField:(id)sender {
}

- (IBAction)insertIntoDataSource:(id)sender {
    Entity *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:_myAppDelegate.managedObjectContext];
    user.name = _nameText.text;
    user.age  = [NSNumber numberWithInteger:[_ageText.text integerValue]];
    user.sex  = _sexText.text;
    NSError *error = nil;
    BOOL isSaveSuccess = [_myAppDelegate.managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error:%@",error);
    }else{
        NSLog(@"Save successful!");
    }
}

- (IBAction)deleteFromDataSource:(id)sender {
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* user=[NSEntityDescription entityForName:@"User" inManagedObjectContext:_myAppDelegate.managedObjectContext];
    [request setEntity:user];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"name==%@",_nameText.text];
    [request setPredicate:predicate];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[_myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"The count of entry: %ld",[mutableFetchResult count]);
    for (Entity* user in mutableFetchResult) {
        [_myAppDelegate.managedObjectContext deleteObject:user];
    }
    
    if ([_myAppDelegate.managedObjectContext save:&error]) {
        NSLog(@"Error:%@,%@",error,[error userInfo]);
    }
}

- (IBAction)updateFromDataSource:(id)sender {
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *user = [NSEntityDescription entityForName:@"User" inManagedObjectContext:_myAppDelegate.managedObjectContext];
    [request setEntity:user];
    //查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name==%@",_nameText.text];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSMutableArray *mutableFetchResult = [[_myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"The count of entry: %ld",[mutableFetchResult count]);
    //更新age后要进行保存，否则没更新
    for (Entity* user in mutableFetchResult) {
        [user setAge:[NSNumber numberWithInt:12]];
        
    }
    [_myAppDelegate.managedObjectContext save:&error];
}

- (IBAction)searchFromDataSource:(id)sender {
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *user = [NSEntityDescription entityForName:@"User" inManagedObjectContext:_myAppDelegate.managedObjectContext];
    [request setEntity:user];
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"name==%@",_nameText.text];
    [request setPredicate:searchPredicate];
    NSError *error = nil;
    NSMutableArray *mutableFetchResult = [[_myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"The count of entry:%ld",[mutableFetchResult count]);
    for (Entity *user in mutableFetchResult) {
        NSLog(@"name:%@----age:%@------sex:%@",user.name,user.age,user.sex);
    }
    
}


- (IBAction)showAll:(id)sender {
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *user = [NSEntityDescription entityForName:@"User" inManagedObjectContext:_myAppDelegate.managedObjectContext];
    [request setEntity:user];
    NSError *error = nil;
    NSMutableArray *mutableFetchResult = [[_myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"The count of entry:%ld",[mutableFetchResult count]);
    for (Entity *user in mutableFetchResult) {
        NSLog(@"name:%@----age:%@------sex:%@",user.name,user.age,user.sex);
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
