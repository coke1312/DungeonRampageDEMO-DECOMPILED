package Account
{
   import GameMasterDictionary.GMKey;
   import GameMasterDictionary.GMOffer;
   
   public class KeyInfo
   {
      
      private var mGMKey:GMKey;
      
      private var mGMKeyOffer:GMOffer;
      
      private var mCount:uint;
      
      public function KeyInfo(param1:GMKey, param2:GMOffer, param3:uint)
      {
         super();
         mGMKey = param1;
         mGMKeyOffer = param2;
         mCount = param3;
      }
      
      public function get gmKey() : GMKey
      {
         return mGMKey;
      }
      
      public function get gmKeyOffer() : GMOffer
      {
         return mGMKeyOffer;
      }
      
      public function get count() : uint
      {
         return mCount;
      }
      
      public function set count(param1:uint) : void
      {
         mCount = param1;
      }
   }
}

