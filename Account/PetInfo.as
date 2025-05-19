package Account
{
   import Facade.DBFacade;
   import GameMasterDictionary.GMNpc;
   
   public class PetInfo extends InventoryBaseInfo
   {
      
      public var PetType:uint;
      
      public var EquippedHero:uint;
      
      private var mGMNpc:GMNpc;
      
      public function PetInfo(param1:DBFacade, param2:Object)
      {
         super(param1,param2);
         mDBFacade = param1;
         PetType = mGMId = param2.npc_id as uint;
         EquippedHero = param2.equipped_hero as uint;
         mDatabaseId = param2.id as uint;
         mGMNpc = mDBFacade.gameMaster.npcById.itemFor(PetType);
         mIsNew = false;
      }
      
      override public function get iconScale() : Number
      {
         return 68;
      }
      
      public function get attackRating() : uint
      {
         return mGMNpc.AttackRating;
      }
      
      public function get defenseRating() : uint
      {
         return mGMNpc.DefenseRating;
      }
      
      public function get speedRating() : uint
      {
         return mGMNpc.SpeedRating;
      }
      
      override public function get isEquipped() : Boolean
      {
         return EquippedHero != 0;
      }
      
      override public function get uiSwfFilepath() : String
      {
         return mGMNpc.IconSwfFilepath;
      }
      
      override public function get iconName() : String
      {
         return mGMNpc.IconName;
      }
      
      override public function get Name() : String
      {
         return mGMNpc.Name;
      }
      
      override public function get sellCoins() : int
      {
         return mGMNpc.SellCoins;
      }
      
      public function get gmNpc() : GMNpc
      {
         return mGMNpc;
      }
      
      override public function get hasColoredBackground() : Boolean
      {
         return false;
      }
      
      override public function get backgroundIconName() : String
      {
         return "";
      }
      
      override public function get backgroundSwfPath() : String
      {
         return "";
      }
      
      override public function hasGMPropertySetup() : Boolean
      {
         return mGMNpc != null;
      }
   }
}

