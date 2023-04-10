```diff
diff --git a/./flattened/AToken_polygon.sol b/./flattened/AToken_new.sol
index 270a855..247233a 100644
--- a/./flattened/AToken_polygon.sol
+++ b/./flattened/AToken_new.sol
@@ -917,6 +917,21 @@ interface IAaveIncentivesController {
       uint256
     );
 
+  /*
+   * LEGACY **************************
+   * @dev Returns the configuration of the distribution for a certain asset
+   * @param asset The address of the reference asset of the distribution
+   * @return The asset index, the emission per second and the last updated timestamp
+   **/
+  function assets(address asset)
+    external
+    view
+    returns (
+      uint128,
+      uint128,
+      uint256
+    );
+
   /**
    * @dev Whitelists an address to claim the rewards on behalf of another address
    * @param user The address of the user
@@ -1012,6 +1027,11 @@ interface IAaveIncentivesController {
    * @dev for backward compatibility with previous implementation of the Incentives controller
    */
   function PRECISION() external view returns (uint8);
+
+  /**
+   * @dev Gets the distribution end timestamp of the emissions
+   */
+  function DISTRIBUTION_END() external view returns (uint256);
 }
 
 /**
@@ -1782,7 +1802,7 @@ contract AToken is
   bytes32 public constant PERMIT_TYPEHASH =
     keccak256('Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)');
 
-  uint256 public constant ATOKEN_REVISION = 0x1;
+  uint256 public constant ATOKEN_REVISION = 0x2;
 
   /// @dev owner => next valid nonce to submit with permit()
   mapping(address => uint256) public _nonces;
@@ -2025,7 +2045,7 @@ contract AToken is
   /**
    * @dev Returns the address of the underlying asset of this aToken (E.g. WETH for aWETH)
    **/
-  function UNDERLYING_ASSET_ADDRESS() public override view returns (address) {
+  function UNDERLYING_ASSET_ADDRESS() public view override returns (address) {
     return _underlyingAsset;
   }
 
```
