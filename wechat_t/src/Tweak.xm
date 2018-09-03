
#define ZYFile(path) @"/Library/Caches/ZYWeChat/" #path
#define ZYDefaults [NSUserDefaults standardUserDefaults]
#define ZYAutoKey @"zy_auto_key"

%hook FindFriendEntryViewController

- (long long)numberOfSectionsInTableView:(id)tableView
{
	return %orig + 1;
}

- (long long)tableView:(id)tableView numberOfRowsInSection:(long long)section
{
	if (section == [self numberOfSectionsInTableView:tableView] - 1) {
		return 2;
	} else {
		return %orig;
	}
}

- (id)tableView:(id)tableView cellForRowAtIndexPath:(id)indexPath
{
	if ([indexPath section] != [self numberOfSectionsInTableView:tableView] - 1) {
		return %orig;
	}

	NSString *cellID = ([indexPath row] == 1) ? @"exitCellID" : @"autoCellID";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
		cell.backgroundColor = [UIColor whiteColor];
		// 图片
		cell.imageView.image = [UIImage imageWithContentsOfFile:ZYFile(skull.png)];
	}

	if ([indexPath row] == 0) {
		cell.textLabel.text = @"自动抢红包";
		UISwitch *switchView = [[UISwitch alloc] init];
		switchView.on = [ZYDefaults boolForKey:ZYAutoKey];
    	[switchView addTarget:self action:@selector(zy_autoChange:) forControlEvents:UIControlEventValueChanged];
		cell.accessoryView = switchView;
	} else if ([indexPath row] == 1) {
		cell.textLabel.text = @"退出微信";
	}
	return cell;
}

// 每一行的高度
- (double)tableView:(id)tableView heightForRowAtIndexPath:(id)indexPath
{
	if ([indexPath section] != [self numberOfSectionsInTableView:tableView] - 1) {
		return %orig;
	}
	return 44;
}

// 点击的监听
- (void)tableView:(id)tableView didSelectRowAtIndexPath:(id)indexPath
{
	if ([indexPath section] != [self numberOfSectionsInTableView:tableView] - 1) {
		%orig;
		return;
	}

	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if ([indexPath row] == 1) {
		UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"终止进程" message:nil preferredStyle:UIAlertControllerStyleAlert];
    	[alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    	[self presentViewController:alertVC animated:YES completion:nil];
	}
}

%new
- (void)zy_autoChange:(UISwitch *)switchView
{
	[ZYDefaults setBool:switchView.isOn forKey:ZYAutoKey];
	[ZYDefaults synchronize];

	UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:switchView.isOn ? @"开启了自动抢红包功能" : @"关闭了自动抢红包功能" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
} 

%end
