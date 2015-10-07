
//
//  BSKeyboardControls.m
//  Example
//
//  Created by Simon B. Støvring on 11/01/13.
//  Copyright (c) 2013 simonbs. All rights reserved.
//

#import "BSKeyboardControls.h"

@interface BSKeyboardControls ()
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIBarButtonItem *leftArrowButton;
@property (nonatomic, strong) UIBarButtonItem *rightArrowButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;
@property (nonatomic, strong) UIBarButtonItem *deleteButton;
@property (nonatomic, strong) UIBarButtonItem *segmentedControlItem;
@end

@implementation BSKeyboardControls


- (BOOL) enableInputClicksWhenVisible {
	return YES;
}


#pragma mark -
#pragma mark Lifecycle

- (id)init
{
    return [self initWithFields:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFields:nil];
}

- (id)initWithFields:(NSMutableArray *)fields
{
    if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)])
    {
        [self setToolbar:[[UIToolbar alloc] initWithFrame:self.frame]];
        [self.toolbar setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth)];
        [self addSubview:self.toolbar];

        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            [self setLeftArrowButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:105 target:self action:@selector(selectPreviousField)]];
            [self.leftArrowButton setEnabled:NO];
            [self.rightArrowButton setEnabled:NO];
            [self setRightArrowButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:106 target:self action:@selector(selectNextField)]];

        } else {
            [self setBarStyle:UIBarStyleBlackTranslucent];

            [self setSegmentedControl:[[UISegmentedControl alloc] initWithItems:@[ NSLocalizedStringFromTable(@"Previous", @"BSKeyboardControls", @"Previous button title."),
                                                                                   NSLocalizedStringFromTable(@"Next", @"BSKeyboardControls", @"Next button title.") ]]];
            [self.segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];

            [self.segmentedControl setMomentary:YES];
            [self.segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
            [self.segmentedControl setEnabled:NO forSegmentAtIndex:BSKeyboardControlsDirectionPrevious];
            [self.segmentedControl setEnabled:NO forSegmentAtIndex:BSKeyboardControlsDirectionNext];
            [self setSegmentedControlItem:[[UIBarButtonItem alloc] initWithCustomView:self.segmentedControl]];
        }

        [self setDeleteButton:[[UIBarButtonItem alloc] initWithTitle:@"Delete"
                                                               style:UIBarButtonItemStyleDone
                                                              target:self
                                                              action:@selector(deleteButtonPressed:)]];

        [self setDoneButton:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Save", @"BSKeyboardControls", @"Done button title.")
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(doneButtonPressed:)]];

        [self setVisibleControls:(BSKeyboardControlPreviousNext | BSKeyboardControlDelete | BSKeyboardControlDone )];

        [self setFields:fields];
    }

    return self;
}

- (void)dealloc
{
    [self setFields:nil];
    [self setSegmentedControlTintControl:nil];
    [self setPreviousTitle:nil];
    [self setBarTintColor:nil];
    [self setNextTitle:nil];
    [self setDoneTitle:nil];
    [self setDoneTintColor:nil];
    [self setActiveField:nil];
    [self setToolbar:nil];
    [self setRightArrowButton:nil];
    [self setLeftArrowButton:nil];
    [self setSegmentedControl:nil];
    [self setSegmentedControlItem:nil];
    [self setDoneButton:nil];
    [self setDeleteButton:nil];
}

#pragma mark -
#pragma mark Public Methods

- (void)setActiveField:(id)activeField
{
    _activeField = activeField;

        if ([activeField isKindOfClass:[WPEditorField class]]) {
            [activeField focus];
        }else{
            [activeField becomeFirstResponder];
        }

     [self updatePrevoidNextEnabledStates];
//    if (activeField != _activeField)
//    {
//        if (!activeField || [self.fields containsObject:activeField])
//        {
//            _activeField = activeField;
//
//            if (activeField)
//            {
//                if (![activeField isFirstResponder])
//                {
//                    [activeField becomeFirstResponder];
//                }
//
//                [self updatePrevoidNextEnabledStates];
//            }
//        }
//    }
}

- (void)setFields:(NSMutableArray *)fields
{
    if (fields != _fields)
    {
//        for (UIView *field in fields)
//        {
//            [(WPEditorField *)field setInputAccessoryView:self];
//            if ([field isKindOfClass:[UITextField class]])
//            {
//                [(UITextField *)field setInputAccessoryView:self];
//            }
//            else if ([field isKindOfClass:[UITextView class]])
//            {
//                [(UITextView *)field setInputAccessoryView:self];
//            }
//        }

        _fields = fields;
    }
}

- (void)setBarStyle:(UIBarStyle)barStyle
{
    if (barStyle != _barStyle)
    {
        [self.toolbar setBarStyle:barStyle];

        _barStyle = barStyle;
    }
}

- (void)setBarTintColor:(UIColor *)barTintColor
{
    if (barTintColor != _barTintColor)
    {
        [self.toolbar setTintColor:barTintColor];

        _barTintColor = barTintColor;
    }
}

- (void)setSegmentedControlTintControl:(UIColor *)segmentedControlTintControl
{
    if (segmentedControlTintControl != _segmentedControlTintControl)
    {
        [self.segmentedControl setTintColor:segmentedControlTintControl];

        _segmentedControlTintControl = segmentedControlTintControl;
    }
}

- (void)setPreviousTitle:(NSString *)previousTitle
{
    if (![previousTitle isEqualToString:_previousTitle])
    {
        [self.segmentedControl setTitle:previousTitle forSegmentAtIndex:BSKeyboardControlsDirectionPrevious];

        _previousTitle = previousTitle;
    }
}

- (void)setNextTitle:(NSString *)nextTitle
{
    if (![nextTitle isEqualToString:_nextTitle])
    {
        [self.segmentedControl setTitle:nextTitle forSegmentAtIndex:BSKeyboardControlsDirectionNext];

        _nextTitle = nextTitle;
    }
}

- (void)setDoneTitle:(NSString *)doneTitle
{
    if (![doneTitle isEqualToString:_doneTitle])
    {
        [self.doneButton setTitle:doneTitle];

        _doneTitle = doneTitle;
    }
}

- (void)setDoneTintColor:(UIColor *)doneTintColor
{
    if (doneTintColor != _doneTintColor)
    {
        [self.doneButton setTintColor:doneTintColor];

        _doneTintColor = doneTintColor;
    }
}

- (void)setDeleteTitle:(NSString *)deleteTitle
{
    if (![deleteTitle isEqualToString:_deleteTitle])
    {
        [self.deleteButton setTitle:deleteTitle];

        _deleteTitle = deleteTitle;
    }
}

- (void)setDeleteTintColor:(UIColor *)deleteTintColor
{
    if (deleteTintColor != _deleteTintColor)
    {
        [self.deleteButton setTintColor:deleteTintColor];

        _deleteTintColor = deleteTintColor;
    }
}

- (void)setVisibleControls:(BSKeyboardControl)visibleControls
{
    if (visibleControls != _visibleControls)
    {
        _visibleControls = visibleControls;

        [self.toolbar setItems:[self toolbarItems]];
    }
}

#pragma mark -
#pragma mark Private Methods

- (void)segmentedControlValueChanged:(id)sender
{
	[[UIDevice currentDevice] playInputClick];

    switch (self.segmentedControl.selectedSegmentIndex)
    {
        case BSKeyboardControlsDirectionPrevious:
            [self selectPreviousField];
            break;
        case BSKeyboardControlsDirectionNext:
            [self selectNextField];
            break;
        default:
            break;
    }
}

- (void)doneButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(keyboardControlsDonePressed:)])
    {
        [self.delegate keyboardControlsDonePressed:self];
    }
}

- (void)deleteButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(keyboardControlsDonePressed:)])
    {
        [self.delegate keyboardControlsDeletePressed:self];
    }
}

- (void)updatePrevoidNextEnabledStates
{
    NSInteger index = [self.fields indexOfObject:self.activeField];
    if (index != NSNotFound)
    {
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            [self.leftArrowButton setEnabled:(index > 0)];
            [self.rightArrowButton setEnabled:(index < [self.fields count] - 1)];
        } else {
            [self.segmentedControl setEnabled:(index > 0) forSegmentAtIndex:BSKeyboardControlsDirectionPrevious];
            [self.segmentedControl setEnabled:(index < [self.fields count] - 1) forSegmentAtIndex:BSKeyboardControlsDirectionNext];
        }
    }
}

- (void)selectPreviousField
{
    NSInteger index = [self.fields indexOfObject:self.activeField];
    if (index > 0)
    {
        index -= 1;
        id field = [self.fields objectAtIndex:index];
        [self setActiveField:field];

        if ([self.delegate respondsToSelector:@selector(keyboardControls:selectedField:inDirection:)])
        {
            [self.delegate keyboardControls:self selectedField:field inDirection:BSKeyboardControlsDirectionPrevious];
        }
    }
}

- (void)selectNextField
{
    NSInteger index = [self.fields indexOfObject:self.activeField];
    if (index < [self.fields count] - 1)
    {
        index += 1;
        id field = [self.fields objectAtIndex:index];
        [self setActiveField:field];
        [self.delegate keyboardControlsNextPressed];

        if ([self.delegate respondsToSelector:@selector(keyboardControls:selectedField:inDirection:)])
        {
            [self.delegate keyboardControls:self selectedField:field inDirection:BSKeyboardControlsDirectionNext];
        }
    }
}

- (NSArray *)toolbarItems
{
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:3];

    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        if (self.visibleControls & BSKeyboardControlPreviousNext)
        {
            UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            fixedSpace.width = 22.0;
            [items addObjectsFromArray:@[self.leftArrowButton,
                                         fixedSpace,
                                         self.rightArrowButton]];
        }
    } else {
        if (self.visibleControls & BSKeyboardControlPreviousNext)
        {
            [items addObject:self.segmentedControlItem];
        }
    }

    CGFloat space = 210;

    // TODO A bit hacky but need more space for buttons in Portuguese because of longer text
    NSString* language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language isEqualToString:@"pt"] || [language isEqualToString:@"pt-PT"] || [language isEqualToString:@"pt-BR"]) {
        space = space + 18;
    }

    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        space = space + 10;

    if (self.visibleControls & BSKeyboardControlDelete)
    {
        UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [fixedItem setWidth: [[UIScreen mainScreen] bounds].size.width - space];
        [items addObject:fixedItem];
        [items addObject:self.deleteButton];
    }

    if (self.visibleControls & BSKeyboardControlDone)
    {
        UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [fixedItem setWidth: 18];
        [items addObject:fixedItem];
        [items addObject:self.doneButton];
    }


    return items;
}

@end
