//
//  ViewController.m
//  HW_CoreData
//
//  Created by Alexander on 30.03.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSMutableArray *pages;
    NSIndexPath *updateIdxPath;
    UIAlertController *addPage;
    NSNotificationCenter *nCenter;
    NSManagedObjectContext *moc;
    CoreDataManager *manager;
    NetManager *nManager;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property(nonatomic,retain) UIPopoverPresentationController *popover;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    nCenter = [NSNotificationCenter defaultCenter];
    manager = [CoreDataManager shared];
    nManager =[NetManager sharedInstance];
    [self reloadData];
}

-(void)addPageWithTitle:(NSString *)title andUrl:(NSString *)url{
    moc = manager.managedObjectContext;
    Page *page = [NSEntityDescription insertNewObjectForEntityForName:@"Page" inManagedObjectContext:moc];
    page.title = title;
    page.url = url;
    [nManager loadPage:page :^(Page *page) {
        [pages addObject:page];
        [manager save];
        [self.tableView reloadData];
        
    }];
    
}
-(void)reloadData{
    [manager getAllPages:^(NSArray *pagesArr) {
        pages = [NSMutableArray arrayWithArray:pagesArr];
        [self.tableView reloadData];
    }];
}

- (IBAction)addPage:(id)sender {

        addPage = [UIAlertController alertControllerWithTitle:@"" message:@"Введите название" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *noAction = [UIAlertAction
                                   actionWithTitle:@"Отмена"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       [nCenter removeObserver:self                                                                                               name:UITextFieldTextDidChangeNotification
                                                        object:nil];
                                       [addPage dismissViewControllerAnimated:YES completion:nil];
                                   }];
        
        UIAlertAction *yesAction = [UIAlertAction
                                    actionWithTitle:@"Добавить"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action)
                                    {
                                        UITextField *nameTextField = addPage.textFields.firstObject;
                                        UITextField *urlTextField = addPage.textFields.lastObject;
                                        [self addPageWithTitle:nameTextField.text andUrl:urlTextField.text];
                                        [nCenter removeObserver:self                                                                                               name:UITextFieldTextDidChangeNotification
                                                         object:nil];
                                        [addPage dismissViewControllerAnimated:YES completion:nil];
                                    }];
    
        [addPage addTextFieldWithConfigurationHandler:^(UITextField *nameTextField) {
            nameTextField.placeholder = @"URL name";
            [nCenter addObserver:self
                        selector:@selector(alertTextFieldDidChange:)
                            name:UITextFieldTextDidChangeNotification
                          object:nameTextField];
        }];
        [addPage addTextFieldWithConfigurationHandler:^(UITextField *urlTextField) {
            urlTextField.placeholder = @"URL: http://www...";
            [nCenter addObserver:self
                        selector:@selector(alertTextFieldDidChange:)
                            name:UITextFieldTextDidChangeNotification
                          object:urlTextField];
        }];
        yesAction.enabled = NO;
        [addPage addAction:noAction];
        [addPage addAction:yesAction];
        UINavigationController *destNav = [[UINavigationController alloc] initWithRootViewController:addPage];
        destNav.modalPresentationStyle = UIModalPresentationPopover;
        _popover = destNav.popoverPresentationController;
        _popover.delegate = self;
        if (sender) {
            _popover.barButtonItem = sender;
        } else  _popover.barButtonItem = _addButton;
        destNav.modalPresentationStyle = UIModalPresentationPopover;
        destNav.navigationBarHidden = YES;
        [self presentViewController:destNav animated:YES completion:nil];
    
}

- (void)alertTextFieldDidChange:(NSNotification *)notification
{
    UINavigationController *nav = self.presentedViewController;
    UIAlertController *alertController = (UIAlertController *)[nav visibleViewController];
    if (alertController)
    {
        UITextField *name = alertController.textFields.firstObject;
        UITextField *url = alertController.textFields.lastObject;
        UIAlertAction *yesAction = alertController.actions.lastObject;
        NSString *urlRegEx =
        @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
        NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
        yesAction.enabled = (name.text.length>2)&&[urlTest evaluateWithObject:url.text];
    }
}

- (UIModalPresentationStyle) adaptivePresentationStyleForPresentationController: (UIPresentationController * ) controller {
    return UIModalPresentationNone;
}


#pragma mark - Table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (pages) {
        return pages.count;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WebsiteCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Page *page = pages[indexPath.row];
    if (page) {
        cell.title.text = page.title;
        cell.icon.image = page.img;
    }
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((editingStyle==UITableViewCellEditingStyleDelete)&&(pages[indexPath.row])) {
        [manager deletePage:pages[indexPath.row]];
        [manager save];
        [pages removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    if ([segue.identifier isEqual:@"showPage"] && path) {
        WebViewController *webView = [segue destinationViewController];
        if (pages[path.row]) {
            Page *page = pages[path.row];
            webView.data = page.data;
            webView.url = [NSURL URLWithString:page.url];
        }
    }
    
}


@end
