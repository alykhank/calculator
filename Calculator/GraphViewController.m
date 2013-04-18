//
//  GraphViewController.m
//  Calculator
//
//  Created by alykhan.kanji on 16/04/13.
//  Copyright (c) 2013 Alykhan Kanji. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "CalculatorBrain.h"

@interface GraphViewController () <GraphViewDataSource>
@property (weak, nonatomic) IBOutlet GraphView *graphView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *splitViewBarButtonItem;
@end

@implementation GraphViewController

@synthesize program = _program;
@synthesize drawingStyleSwitch = _drawingStyleSwitch;
@synthesize programLabel = _programLabel;
@synthesize graphView = _graphView;
@synthesize toolbar = _toolbar;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;

- (void)setProgram:(id)program
{
    _program = program;
    NSString *equation = [[CalculatorBrain class] descriptionOfProgram:self.program];
    self.programLabel.text = [NSString stringWithFormat:@"y = %@", [equation length] ? equation : @"0"];
    [self.graphView setNeedsDisplay];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tap:)];
    tapgr.numberOfTapsRequired = 3;
    [self.graphView addGestureRecognizer:tapgr];
    self.graphView.dataSource = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString *equation = [[CalculatorBrain class] descriptionOfProgram:self.program];
    self.programLabel.text = [NSString stringWithFormat:@"y = %@", [equation length] ? equation : @"0"];
    self.splitViewController.delegate = self;
}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"Calculator";
    self.splitViewBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.splitViewBarButtonItem = nil;
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
    if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
    self.toolbar.items = toolbarItems;
    _splitViewBarButtonItem = splitViewBarButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (float)yValueForGraphView:(GraphView *)sender withXValue:(float)x
{
    return [[CalculatorBrain class] runProgram:self.program usingVariableValues:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:x], @"x", nil]];
}

- (BOOL)drawingStyle
{
    return self.drawingStyleSwitch.isOn;
}

- (IBAction)drawingStyleChanged:(UISwitch *)sender {
    [self.graphView setNeedsDisplay];
}

- (IBAction)resetPressed {
    [NSUserDefaults resetStandardUserDefaults];
    self.graphView.origin = CGPointZero;
    self.graphView.scale = 0.0;
    [self.graphView setNeedsDisplay];
}

@end
