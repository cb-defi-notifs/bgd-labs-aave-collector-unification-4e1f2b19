```diff
diff --git a/./diffs/polygon_layout.md b/./diffs/new_layout.md
index 2b976c4..7e8f364 100644
--- a/./diffs/polygon_layout.md
+++ b/./diffs/new_layout.md
@@ -1,6 +1,8 @@
 | Name                    | Type                              | Slot | Offset | Bytes |
 | ----------------------- | --------------------------------- | ---- | ------ | ----- |
 | lastInitializedRevision | uint256                           | 0    | 0      | 32    |
-| initializing            | bool                              | 1    | 0      | 1     |
-| ______gap               | uint256[50]                       | 2    | 0      | 1600  |
+| ______gap               | uint256[50]                       | 1    | 0      | 1600  |
+| _status                 | uint256                           | 51   | 0      | 32    |
 | _fundsAdmin             | address                           | 52   | 0      | 20    |
+| _nextStreamId           | uint256                           | 53   | 0      | 32    |
+| _streams                | mapping(uint256 => struct Stream) | 54   | 0      | 32    |
```
