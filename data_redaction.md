# Data Redaction

## Overview
The **Data Redaction** feature in the **FullviewSDK** allows developers to hide sensitive information from the screen shared with support agents. This feature ensures user privacy while providing remote assistance.

## Usage

Wrap the widget you want to hide within the `DataRedactionWidget`. Any widget within this container will be excluded from the screen capture.

#### Example

```react
import 'package:flutter_fullview/data_redaction_widget.dart';

DataRedactionWidget(child: Text("NON Visible text on the agent side")),
Text("Visible text on the agent side"),
```

### Note
This setup ensures that wrapped elements will not appear in the shared screen feed.