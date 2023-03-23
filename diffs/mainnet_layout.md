| Name                    | Type                              | Slot | Offset | Bytes |
| ----------------------- | --------------------------------- | ---- | ------ | ----- |
| lastInitializedRevision | uint256                           | 0    | 0      | 32    |
| ______gap               | uint256[50]                       | 1    | 0      | 1600  |
| _fundsAdmin             | address                           | 51   | 0      | 20    |
| _status                 | uint256                           | 52   | 0      | 32    |
| _nextStreamId           | uint256                           | 53   | 0      | 32    |
| _streams                | mapping(uint256 => struct Stream) | 54   | 0      | 32    |
