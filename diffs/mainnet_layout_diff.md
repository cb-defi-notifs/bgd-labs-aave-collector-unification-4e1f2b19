```diff
diff --git a/./diffs/mainnet_layout.md b/./diffs/new_layout.md
index cec7d30..8ca00fc 100644
--- a/./diffs/mainnet_layout.md
+++ b/./diffs/new_layout.md
@@ -2,7 +2,7 @@
 | ----------------------- | --------------------------------- | ---- | ------ | ----- |
 | lastInitializedRevision | uint256                           | 0    | 0      | 32    |
 | **\_\_**gap             | uint256[50]                       | 1    | 0      | 1600  |
-| \_fundsAdmin            | address                           | 51   | 0      | 20    |
-| \_status                | uint256                           | 52   | 0      | 32    |
+| \_status                | uint256                           | 51   | 0      | 32    |
+| \_fundsAdmin            | address                           | 52   | 0      | 20    |
 | \_nextStreamId          | uint256                           | 53   | 0      | 32    |
 | \_streams               | mapping(uint256 => struct Stream) | 54   | 0      | 32    |
```
