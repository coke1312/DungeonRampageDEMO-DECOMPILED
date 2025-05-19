package Account
{
   import Actor.Player.SkinInfo;
   import Brain.Clock.GameClock;
   import Brain.Event.EventComponent;
   import Brain.Logger.Logger;
   import Brain.jsonRPC.JSONRPCService;
   import Events.BoostersParsedEvent;
   import Facade.DBFacade;
   import GameMasterDictionary.GMHero;
   import GameMasterDictionary.GMKey;
   import GameMasterDictionary.GMMapNode;
   import GameMasterDictionary.GMOffer;
   import GameMasterDictionary.GMOfferDetail;
   import GameMasterDictionary.GMSkin;
   import GameMasterDictionary.GMStackable;
   import org.as3commons.collections.Map;
   import org.as3commons.collections.framework.IMapIterator;
   
   public class DBInventoryInfo
   {
      
      public static const II_FIRST_MAPNODE_ID:uint = 50150;
      
      protected var mDBFacade:DBFacade;
      
      private var mAvatars:Map;
      
      private var mItems:Map;
      
      private var mChests:Vector.<ChestInfo>;
      
      private var mLastPendingChest:int;
      
      private var mKeys:Vector.<KeyInfo>;
      
      private var mStackablesByDatabaseId:Map;
      
      private var mStackablesByStackableId:Map;
      
      private var mBoostersByDatabaseId:Map;
      
      private var mBoostersByStackableId:Map;
      
      private var mPets:Map;
      
      private var mSkins:Map;
      
      private var mResponseCallback:Function;
      
      private var mParseErrorCallback:Function;
      
      protected var mEventComponent:EventComponent;
      
      private var mStorageLimitWeapon:uint;
      
      private var mStorageLimitOther:uint;
      
      private var mFirstParse:Boolean;
      
      private var mTotalHeroesOwned:uint;
      
      public function DBInventoryInfo(param1:DBFacade, param2:Function, param3:Function)
      {
         super();
         mDBFacade = param1;
         mAvatars = new Map();
         mItems = new Map();
         mChests = new Vector.<ChestInfo>();
         mLastPendingChest = -1;
         mKeys = new Vector.<KeyInfo>();
         mStackablesByDatabaseId = new Map();
         mStackablesByStackableId = new Map();
         mBoostersByDatabaseId = new Map();
         mBoostersByStackableId = new Map();
         mPets = new Map();
         mSkins = new Map();
         mFirstParse = true;
         mTotalHeroesOwned = 0;
         mResponseCallback = param2;
         mParseErrorCallback = param3;
         mEventComponent = new EventComponent(mDBFacade);
      }
      
      public function listAllBoosters() : Array
      {
         return mBoostersByStackableId.keysToArray();
      }
      
      public function getStackableByStackId(param1:int) : StackableInfo
      {
         return mStackablesByStackableId.itemFor(param1);
      }
      
      public function findHighestBoosterXP() : BoosterInfo
      {
         var _loc4_:* = null;
         var _loc1_:BoosterInfo = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:Array = listAllBoosters();
         for(var _loc3_ in _loc2_)
         {
            _loc5_ = int(_loc2_[_loc3_]);
            _loc1_ = mBoostersByStackableId.itemFor(_loc5_);
            _loc6_ = timeTillBoosterExpire(_loc5_);
            if(_loc1_ != null && _loc1_.BuffInfo.Exp > 1 && _loc6_ > 0)
            {
               if(_loc4_ == null || _loc1_.BuffInfo.Exp > _loc4_.BuffInfo.Exp)
               {
                  _loc4_ = _loc1_;
               }
            }
         }
         return _loc4_;
      }
      
      public function findHighestBoosterGold() : BoosterInfo
      {
         var _loc4_:* = null;
         var _loc1_:BoosterInfo = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:Array = listAllBoosters();
         for(var _loc3_ in _loc2_)
         {
            _loc5_ = int(_loc2_[_loc3_]);
            _loc1_ = mBoostersByStackableId.itemFor(_loc5_);
            _loc6_ = timeTillBoosterExpire(_loc5_);
            if(_loc1_ != null && _loc1_.BuffInfo.Gold > 1 && _loc6_ > 0)
            {
               if(_loc4_ == null || _loc1_.BuffInfo.Gold > _loc4_.BuffInfo.Gold)
               {
                  _loc4_ = _loc1_;
               }
            }
         }
         return _loc4_;
      }
      
      public function timestampBooster(param1:int) : String
      {
         var _loc2_:BoosterInfo = null;
         if(mBoostersByStackableId.hasKey(param1))
         {
            _loc2_ = mBoostersByStackableId.itemFor(param1);
            if(_loc2_ != null)
            {
               return _loc2_.timeStamp();
            }
         }
         return "";
      }
      
      public function timeTillBoosterExpire(param1:int) : int
      {
         var _loc3_:BoosterInfo = mBoostersByStackableId.itemFor(param1);
         var _loc2_:Date = dateBooster(_loc3_.gmId);
         return int(_loc2_.getTime() - GameClock.getWebServerTime());
      }
      
      public function timeTillNextBoosterExpire() : int
      {
         var _loc2_:BoosterInfo = null;
         var _loc6_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:Array = listAllBoosters();
         var _loc1_:* = -1;
         for(var _loc4_ in _loc3_)
         {
            _loc6_ = int(_loc3_[_loc4_]);
            _loc2_ = mBoostersByStackableId.itemFor(_loc6_);
            _loc5_ = timeTillBoosterExpire(_loc2_.gmId);
            if(_loc5_ > 0)
            {
               if(_loc1_ == -1 || _loc5_ < _loc1_)
               {
                  _loc1_ = _loc5_;
               }
            }
         }
         return _loc1_;
      }
      
      public function dateBooster(param1:int) : Date
      {
         var _loc2_:Date = GameClock.getWebServerDate();
         var _loc3_:String = timestampBooster(param1);
         if(_loc3_ != "")
         {
            return GameClock.parseW3CDTF(_loc3_,true);
         }
         return null;
      }
      
      public function get unequippedWeaponCount() : uint
      {
         var _loc2_:IMapIterator = null;
         var _loc3_:ItemInfo = null;
         var _loc1_:uint = 0;
         _loc2_ = mItems.iterator() as IMapIterator;
         while(_loc2_.hasNext())
         {
            _loc3_ = _loc2_.next();
            if(!_loc3_.isEquipped)
            {
               _loc1_++;
            }
         }
         return _loc1_ + mChests.length;
      }
      
      public function get numStacks() : uint
      {
         return mStackablesByDatabaseId.size;
      }
      
      public function getStackCount(param1:uint) : uint
      {
         var _loc2_:StackableInfo = mStackablesByStackableId.itemFor(param1);
         return _loc2_ ? _loc2_.count : 0;
      }
      
      public function getAvatarInfoForAvatarInstanceId(param1:uint) : AvatarInfo
      {
         return mAvatars.itemFor(param1);
      }
      
      public function getAvatarInfoForHeroType(param1:uint) : AvatarInfo
      {
         var _loc3_:IMapIterator = null;
         var _loc2_:AvatarInfo = null;
         _loc3_ = mAvatars.iterator() as IMapIterator;
         while(_loc3_.hasNext())
         {
            _loc2_ = _loc3_.next();
            if(param1 == _loc2_.avatarType)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function modifiersMatch(param1:GMOfferDetail, param2:ItemInfo) : Boolean
      {
         var _loc3_:uint = 0;
         if(param1.Modifier1)
         {
            _loc3_++;
         }
         if(param1.Modifier2)
         {
            _loc3_++;
         }
         if(param1.Modifier3)
         {
            _loc3_++;
         }
         if(_loc3_ != param2.modifiers.length)
         {
            return false;
         }
         if(param1.Modifier1 && !param2.hasModifier(param1.Modifier1))
         {
            return false;
         }
         if(param1.Modifier2 && !param2.hasModifier(param1.Modifier2))
         {
            return false;
         }
         if(param1.Modifier3 && !param2.hasModifier(param1.Modifier3))
         {
            return false;
         }
         return true;
      }
      
      public function ownsExactWeapon(param1:GMOfferDetail) : Boolean
      {
         var _loc2_:IMapIterator = null;
         var _loc3_:ItemInfo = null;
         _loc2_ = mItems.iterator() as IMapIterator;
         while(_loc2_.hasNext())
         {
            _loc3_ = _loc2_.next();
            if(param1.WeaponId == _loc3_.gmId && param1.WeaponPower == _loc3_.power && this.modifiersMatch(param1,_loc3_))
            {
               return true;
            }
         }
         return false;
      }
      
      public function ownsItem(param1:uint) : Boolean
      {
         var _loc5_:IMapIterator = null;
         var _loc6_:ItemInfo = null;
         var _loc2_:AvatarInfo = null;
         var _loc4_:PetInfo = null;
         var _loc7_:StackableInfo = null;
         var _loc3_:SkinInfo = null;
         _loc5_ = mItems.iterator() as IMapIterator;
         while(_loc5_.hasNext())
         {
            _loc6_ = _loc5_.next();
            if(param1 == _loc6_.gmId)
            {
               return true;
            }
         }
         _loc7_ = mStackablesByStackableId.itemFor(param1);
         if(_loc7_ && _loc7_.count > 0)
         {
            return true;
         }
         _loc5_ = mAvatars.iterator() as IMapIterator;
         while(_loc5_.hasNext())
         {
            _loc2_ = _loc5_.next();
            if(param1 == _loc2_.avatarType)
            {
               return true;
            }
         }
         _loc5_ = mPets.iterator() as IMapIterator;
         while(_loc5_.hasNext())
         {
            _loc4_ = _loc5_.next();
            if(param1 == _loc4_.PetType)
            {
               return true;
            }
         }
         _loc5_ = mSkins.iterator() as IMapIterator;
         while(_loc5_.hasNext())
         {
            _loc3_ = _loc5_.next();
            if(param1 == _loc3_.skinType)
            {
               return true;
            }
         }
         if(mDBFacade.gameMaster.isSkinTypeADefaultSkin(param1))
         {
            return true;
         }
         return false;
      }
      
      public function getEquipedItemsOnAvatar(param1:uint) : Vector.<ItemInfo>
      {
         var _loc3_:IMapIterator = null;
         var _loc4_:ItemInfo = null;
         var _loc2_:Vector.<ItemInfo> = new Vector.<ItemInfo>();
         _loc3_ = mItems.iterator() as IMapIterator;
         while(_loc3_.hasNext())
         {
            _loc4_ = _loc3_.next() as ItemInfo;
            if(_loc4_.avatarId == param1)
            {
               _loc2_.push(_loc4_);
            }
         }
         return _loc2_;
      }
      
      public function getEquipedPetsOnAvatar(param1:uint) : Vector.<PetInfo>
      {
         var _loc4_:IMapIterator = null;
         var _loc3_:PetInfo = null;
         var _loc2_:Vector.<PetInfo> = new Vector.<PetInfo>();
         _loc4_ = mPets.iterator() as IMapIterator;
         while(_loc4_.hasNext())
         {
            _loc3_ = _loc4_.next() as PetInfo;
            if(_loc3_.EquippedHero == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function getEquipedConsumablesOnAvatar(param1:AvatarInfo) : Vector.<StackableInfo>
      {
         var _loc4_:* = null;
         var _loc5_:StackableInfo = null;
         var _loc2_:GMStackable = null;
         var _loc3_:Vector.<StackableInfo> = new Vector.<StackableInfo>();
         if(param1.consumable1Id > 0 && param1.consumable1Count > 0)
         {
            _loc2_ = mDBFacade.gameMaster.stackableById.itemFor(param1.consumable1Id);
            _loc5_ = new StackableInfo(mDBFacade,null,_loc2_);
            _loc5_.setPropertiesAsConsumable(_loc2_.Id,0,param1.consumable1Count);
            _loc3_.push(_loc5_);
         }
         if(param1.consumable2Id > 0 && param1.consumable2Count > 0)
         {
            _loc2_ = mDBFacade.gameMaster.stackableById.itemFor(param1.consumable2Id);
            _loc5_ = new StackableInfo(mDBFacade,null,mDBFacade.gameMaster.stackableById.itemFor(param1.consumable2Id));
            _loc5_.setPropertiesAsConsumable(_loc2_.Id,1,param1.consumable2Count);
            _loc3_.push(_loc5_);
         }
         return _loc3_;
      }
      
      public function get highestAvatarLevel() : uint
      {
         var _loc1_:AvatarInfo = null;
         var _loc2_:uint = 0;
         var _loc3_:IMapIterator = mAvatars.iterator() as IMapIterator;
         while(_loc3_.hasNext())
         {
            _loc1_ = _loc3_.next();
            _loc2_ = Math.max(_loc2_,_loc1_.level);
         }
         return _loc2_;
      }
      
      public function get items() : Map
      {
         return mItems;
      }
      
      public function get chests() : Vector.<ChestInfo>
      {
         return mChests;
      }
      
      public function get keys() : Vector.<KeyInfo>
      {
         return mKeys;
      }
      
      public function get stackables() : Map
      {
         return mStackablesByDatabaseId;
      }
      
      public function get stackablesByStackableID() : Map
      {
         return mStackablesByStackableId;
      }
      
      public function get avatars() : Map
      {
         return mAvatars;
      }
      
      public function get mapnodes1() : Map
      {
         var _loc5_:* = 0;
         var _loc1_:MapnodeInfo = null;
         var _loc2_:GMMapNode = null;
         var _loc12_:* = 0;
         var _loc9_:Boolean = false;
         var _loc10_:* = 0;
         var _loc11_:* = 0;
         var _loc4_:Map = new Map();
         var _loc3_:AvatarInfo = mDBFacade.dbAccountInfo.activeAvatarInfo;
         var _loc7_:uint = _loc3_.level;
         var _loc6_:uint = mDBFacade.dbAccountInfo.trophies;
         var _loc8_:Object = mDBFacade.dbAccountInfo.activeAvatarInfo.mapNodes;
         _loc5_ = 0;
         while(_loc5_ < _loc3_.mapNodes.length)
         {
            _loc1_ = new MapnodeInfo();
            _loc12_ = _loc3_.mapNodes[_loc5_].node_id;
            if(_loc3_.mapNodes[_loc5_].isCompleted)
            {
               _loc1_.init(_loc12_,1);
            }
            else
            {
               _loc1_.init(_loc12_,3);
            }
            _loc4_.add(_loc12_,_loc1_);
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < mDBFacade.gameMaster.MapNodes.length)
         {
            _loc2_ = mDBFacade.gameMaster.MapNodes[_loc5_];
            if(_loc4_.itemFor(_loc2_.Id) == null && _loc2_.LevelRequirement <= _loc7_ && _loc2_.TrophyRequirement <= _loc6_)
            {
               if(_loc2_.ParentNodes.length == 0)
               {
                  _loc1_ = new MapnodeInfo();
                  _loc1_.init(_loc2_.Id,2);
                  _loc4_.add(_loc2_.Id,_loc1_);
               }
               else
               {
                  _loc9_ = false;
                  _loc10_ = 0;
                  while(_loc10_ < _loc3_.mapNodes.length && !_loc9_)
                  {
                     _loc11_ = 0;
                     while(_loc11_ < _loc2_.ParentNodes.length && !_loc9_)
                     {
                        if(_loc2_.ParentNodes[_loc11_].Id == _loc3_.mapNodes[_loc10_].node_id)
                        {
                           _loc9_ = true;
                        }
                        _loc11_++;
                     }
                     _loc10_++;
                  }
                  if(_loc9_)
                  {
                     _loc1_ = new MapnodeInfo();
                     _loc1_.init(_loc2_.Id,2);
                     _loc4_.add(_loc2_.Id,_loc1_);
                  }
               }
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function get pets() : Map
      {
         return mPets;
      }
      
      public function getTotalHeroesOwned() : uint
      {
         return mTotalHeroesOwned;
      }
      
      public function parseJson(param1:Object) : void
      {
         if(param1.account_avatars)
         {
            parseAvatars(param1.account_avatars);
         }
         if(param1.account_items)
         {
            parseItems(param1.account_items);
         }
         if(param1.account_chests)
         {
            parseChests(param1.account_chests);
         }
         if(param1)
         {
            parseKeys(param1);
         }
         if(param1.account_stackables)
         {
            parseStackables(param1.account_stackables);
         }
         if(param1.buckets_weapon)
         {
            mStorageLimitWeapon = param1.buckets_weapon;
         }
         if(param1.buckets_other)
         {
            mStorageLimitOther = param1.buckets_other;
         }
         if(param1.account_pets)
         {
            parsePetInfo(param1.account_pets);
         }
         if(param1.account_skins)
         {
            parseSkinInfo(param1.account_skins);
         }
         if(param1.account_boosters)
         {
            parseBoosters(param1.account_boosters);
         }
         mFirstParse = false;
         mTotalHeroesOwned = mAvatars.size;
      }
      
      private function parseAvatars(param1:Object) : void
      {
         var _loc2_:AvatarInfo = null;
         var _loc4_:* = 0;
         mAvatars.clear();
         var _loc3_:Array = param1 as Array;
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc2_ = new AvatarInfo(mDBFacade,_loc3_[_loc4_],mResponseCallback);
            mAvatars.add(_loc2_.id,_loc2_);
            _loc4_++;
         }
      }
      
      private function parseItems(param1:Object) : void
      {
         var _loc4_:ItemInfo = null;
         var _loc2_:* = 0;
         var _loc3_:Array = mItems.keysToArray();
         mItems.clear();
         var _loc5_:Array = param1 as Array;
         _loc2_ = 0;
         while(_loc2_ < _loc5_.length)
         {
            _loc4_ = new ItemInfo(mDBFacade,_loc5_[_loc2_]);
            if(!mFirstParse && _loc3_.indexOf(_loc5_[_loc2_].id) == -1)
            {
               _loc4_.isNew = true;
            }
            mItems.add(_loc4_.databaseId,_loc4_);
            _loc2_++;
         }
      }
      
      private function parseChests(param1:Object) : void
      {
         var _loc6_:ChestInfo = null;
         var _loc7_:* = 0;
         var _loc5_:Boolean = false;
         var _loc3_:Vector.<ChestInfo> = mChests.slice();
         mChests.splice(0,mChests.length);
         var _loc2_:Array = param1 as Array;
         _loc7_ = 0;
         while(_loc7_ < _loc2_.length)
         {
            _loc5_ = false;
            if(!mFirstParse)
            {
               for each(var _loc4_ in _loc3_)
               {
                  if(_loc4_.databaseId == _loc2_[_loc7_].id)
                  {
                     _loc5_ = true;
                     break;
                  }
               }
            }
            else
            {
               _loc5_ = true;
            }
            _loc6_ = new ChestInfo(mDBFacade,_loc2_[_loc7_]);
            if(!_loc5_)
            {
               _loc6_.isNew = true;
            }
            mChests.push(_loc6_);
            _loc7_++;
         }
      }
      
      private function parseKeys(param1:Object) : void
      {
         var _loc6_:KeyInfo = null;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc2_:* = 0;
         mKeys.splice(0,mKeys.length);
         var _loc3_:Vector.<GMKey> = mDBFacade.gameMaster.Keys;
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_].OfferId;
            _loc2_ = 0;
            switch(int(_loc4_))
            {
               case 0:
                  _loc2_ = uint(param1.basic_keys);
                  break;
               case 1:
                  _loc2_ = uint(param1.uncommon_keys);
                  break;
               case 2:
                  _loc2_ = uint(param1.rare_keys);
                  break;
               case 3:
                  _loc2_ = uint(param1.legendary_keys);
                  break;
            }
            _loc6_ = new KeyInfo(mDBFacade.gameMaster.keysByOfferId.itemFor(_loc5_),mDBFacade.gameMaster.offerById.itemFor(_loc5_),_loc2_);
            mKeys.push(_loc6_);
            _loc4_++;
         }
      }
      
      private function parseStackables(param1:Object) : void
      {
         var _loc5_:StackableInfo = null;
         var _loc4_:* = 0;
         var _loc2_:Array = mStackablesByDatabaseId.keysToArray();
         mStackablesByDatabaseId.clear();
         mStackablesByStackableId.clear();
         var _loc3_:Array = param1 as Array;
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = new StackableInfo(mDBFacade,_loc3_[_loc4_]);
            if(!mFirstParse && _loc2_.indexOf(_loc3_[_loc4_].id) == -1)
            {
               _loc5_.isNew = true;
            }
            mStackablesByDatabaseId.add(_loc5_.databaseId,_loc5_);
            mStackablesByStackableId.add(_loc5_.gmId,_loc5_);
            _loc4_++;
         }
      }
      
      private function parseBoosters(param1:Object) : void
      {
         var _loc2_:BoosterInfo = null;
         var _loc3_:* = 0;
         var _loc5_:Array = mBoostersByDatabaseId.keysToArray();
         mBoostersByDatabaseId.clear();
         mBoostersByStackableId.clear();
         var _loc4_:Array = param1 as Array;
         _loc3_ = 0;
         while(_loc3_ < _loc4_.length)
         {
            _loc2_ = new BoosterInfo(mDBFacade,_loc4_[_loc3_]);
            if(!mFirstParse && _loc5_.indexOf(_loc4_[_loc3_].id) == -1)
            {
               _loc2_.isNew = true;
            }
            mBoostersByDatabaseId.add(_loc2_.databaseId,_loc2_);
            mBoostersByStackableId.add(_loc2_.gmId,_loc2_);
            _loc3_++;
         }
         mDBFacade.eventManager.dispatchEvent(new BoostersParsedEvent("BoostersParsedEvent_BOOSTERS_PARSED_UPDATE"));
      }
      
      private function parsePetInfo(param1:Object) : void
      {
         var _loc3_:PetInfo = null;
         var _loc4_:* = 0;
         var _loc5_:Array = mPets.keysToArray();
         mPets.clear();
         var _loc2_:Array = param1 as Array;
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_ = new PetInfo(mDBFacade,_loc2_[_loc4_]);
            if(!mFirstParse && _loc5_.indexOf(_loc2_[_loc4_].id) == -1)
            {
               _loc3_.isNew = true;
            }
            mPets.add(_loc3_.databaseId,_loc3_);
            _loc4_++;
         }
      }
      
      private function parseSkinInfo(param1:Object) : void
      {
         var _loc3_:SkinInfo = null;
         var _loc4_:* = 0;
         mSkins.clear();
         var _loc2_:Array = param1 as Array;
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_ = new SkinInfo(mDBFacade,_loc2_[_loc4_]);
            mSkins.add(_loc3_.skinType,_loc3_);
            _loc4_++;
         }
      }
      
      public function openChest(param1:uint, param2:uint, param3:uint, param4:Function = null, param5:Function = null) : void
      {
         var rpcFunc:Function;
         var chestInstanceId:uint = param1;
         var forHeroId:uint = param2;
         var forHeroSkinId:uint = param3;
         var responseFinishedCallback:Function = param4;
         var errorCallback:Function = param5;
         if(mLastPendingChest == chestInstanceId && 0)
         {
            Logger.error("Chest has already been opened on Server. Chest id:" + chestInstanceId);
            mLastPendingChest = -1;
            return;
         }
         mLastPendingChest = chestInstanceId;
         rpcFunc = JSONRPCService.getFunction("OpenChest",mDBFacade.rpcRoot + "account");
         rpcFunc(mDBFacade.dbAccountInfo.id,chestInstanceId,mDBFacade.validationToken,forHeroId,forHeroSkinId,function(param1:*):void
         {
            mResponseCallback(param1);
            if(responseFinishedCallback != null)
            {
               responseFinishedCallback(chestInstanceId,param1);
            }
         },function(param1:Error):void
         {
            mParseErrorCallback(param1);
            errorCallback();
         });
      }
      
      public function dropChest(param1:uint, param2:Function = null, param3:Function = null) : void
      {
         var chestInstanceId:uint = param1;
         var responseFinishedCallback:Function = param2;
         var errorCallback:Function = param3;
         var rpcFunc:Function = JSONRPCService.getFunction("DropChest",mDBFacade.rpcRoot + "account");
         rpcFunc(mDBFacade.dbAccountInfo.id,chestInstanceId,mDBFacade.validationToken,function(param1:*):void
         {
            mResponseCallback(param1);
            if(responseFinishedCallback != null)
            {
               responseFinishedCallback(chestInstanceId,param1);
            }
         },function(param1:Error):void
         {
            mParseErrorCallback(param1);
            errorCallback();
         });
      }
      
      public function canThisAvatarEquipThisItem(param1:AvatarInfo, param2:ItemInfo) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         if(param2 == null)
         {
            return false;
         }
         if(!canAvatarEquipThisMasterType(param1,param2.gmWeaponItem.MasterType))
         {
            return false;
         }
         if(param1.level < param2.requiredLevel)
         {
            return false;
         }
         return true;
      }
      
      public function canAvatarEquipThisMasterType(param1:AvatarInfo, param2:String) : Boolean
      {
         return param1.gmHero.AllowedWeapons.hasKey(param2);
      }
      
      public function recalculateWeaponPowers(param1:Function = null, param2:Function = null) : void
      {
         var itemInfo:ItemInfo;
         var rpcFunc:Function;
         var responseFinishedCallback:Function = param1;
         var errorCallback:Function = param2;
         var iter:IMapIterator = mItems.iterator() as IMapIterator;
         var itemIds:Array = [];
         while(iter.hasNext())
         {
            itemInfo = iter.next();
            itemIds.push(itemInfo.databaseId);
         }
         rpcFunc = JSONRPCService.getFunction("RecalculateWeaponPowers",mDBFacade.rpcRoot + "inventorymanager");
         rpcFunc(mDBFacade.dbAccountInfo.id,itemIds,mDBFacade.validationToken,function(param1:*):void
         {
            mResponseCallback(param1);
            if(responseFinishedCallback != null)
            {
               responseFinishedCallback(param1);
            }
         },function(param1:Error):void
         {
            mParseErrorCallback(param1);
            if(errorCallback != null)
            {
               errorCallback();
            }
         });
      }
      
      public function equipItemOnAvatar(param1:uint, param2:uint, param3:uint, param4:Function = null, param5:Function = null) : void
      {
         var avatarInstanceId:uint = param1;
         var itemInstanceId:uint = param2;
         var equipSlot:uint = param3;
         var responseFinishedCallback:Function = param4;
         var errorCallback:Function = param5;
         var rpcFunc:Function = JSONRPCService.getFunction("equipItemOnAvatar",mDBFacade.rpcRoot + "avatarmanager");
         rpcFunc(mDBFacade.dbAccountInfo.id,avatarInstanceId,itemInstanceId,equipSlot,mDBFacade.validationToken,function(param1:*):void
         {
            mResponseCallback(param1);
            if(responseFinishedCallback != null)
            {
               responseFinishedCallback();
            }
         },function(param1:Error):void
         {
            mParseErrorCallback(param1);
            if(errorCallback != null)
            {
               errorCallback();
            }
         });
      }
      
      public function unequipItemOffAvatar(param1:InventoryBaseInfo, param2:Function = null, param3:Function = null) : void
      {
         var rpcFunc:Function;
         var itemInfo:InventoryBaseInfo = param1;
         var responseFinishedCallback:Function = param2;
         var errorCallback:Function = param3;
         if(!itemInfo.isEquipped)
         {
            Logger.error("Trying to unequip an item that is not currently equipped.");
            if(errorCallback != null)
            {
               errorCallback(new Error("Trying to unequip an item that is not currently equipped.",-1));
            }
         }
         rpcFunc = JSONRPCService.getFunction("unequipItemOffAvatar",mDBFacade.rpcRoot + "avatarmanager");
         rpcFunc(mDBFacade.dbAccountInfo.id,itemInfo.databaseId,mDBFacade.validationToken,function(param1:*):void
         {
            mResponseCallback(param1);
            if(responseFinishedCallback != null)
            {
               responseFinishedCallback();
            }
         },function(param1:Error):void
         {
            mParseErrorCallback(param1);
            errorCallback();
         });
      }
      
      public function equipConsumableOnAvatar(param1:uint, param2:uint, param3:uint, param4:Boolean = false, param5:Function = null, param6:Function = null) : void
      {
         var avatarInstanceId:uint = param1;
         var stackableId:uint = param2;
         var equipSlot:uint = param3;
         var swapping:Boolean = param4;
         var responseFinishedCallback:Function = param5;
         var errorCallback:Function = param6;
         var rpcFunc:Function = JSONRPCService.getFunction("equipConsumableOnAvatar",mDBFacade.rpcRoot + "avatarmanager");
         rpcFunc(mDBFacade.dbAccountInfo.id,avatarInstanceId,stackableId,equipSlot,swapping,mDBFacade.validationToken,function(param1:*):void
         {
            mResponseCallback(param1);
            if(responseFinishedCallback != null)
            {
               responseFinishedCallback();
            }
         },function(param1:Error):void
         {
            mParseErrorCallback(param1);
            if(errorCallback != null)
            {
               errorCallback();
            }
         });
      }
      
      public function unequipConsumableOffAvatar(param1:uint, param2:uint, param3:uint, param4:Function = null, param5:Function = null) : void
      {
         var avatarInstanceId:uint = param1;
         var stackableId:uint = param2;
         var equipSlot:uint = param3;
         var responseFinishedCallback:Function = param4;
         var errorCallback:Function = param5;
         var rpcFunc:Function = JSONRPCService.getFunction("unequipConsumableOffAvatar",mDBFacade.rpcRoot + "avatarmanager");
         rpcFunc(mDBFacade.dbAccountInfo.id,avatarInstanceId,stackableId,equipSlot,mDBFacade.validationToken,function(param1:*):void
         {
            mResponseCallback(param1);
            if(responseFinishedCallback != null)
            {
               responseFinishedCallback();
            }
         },function(param1:Error):void
         {
            mParseErrorCallback(param1);
            errorCallback();
         });
      }
      
      public function canEquipThisConsumable(param1:AvatarInfo, param2:uint, param3:uint) : Boolean
      {
         var _loc4_:* = true;
         if(param2 == 0)
         {
            if(param1.consumable2Id > 0 && param1.consumable2Count > 0)
            {
               _loc4_ = param1.consumable2Id != param3;
            }
         }
         else if(param2 == 1)
         {
            if(param1.consumable1Id > 0 && param1.consumable1Count > 0)
            {
               _loc4_ = param1.consumable1Id != param3;
            }
         }
         return _loc4_;
      }
      
      public function equipItemOnAccount(param1:uint, param2:uint, param3:Function = null, param4:Function = null) : void
      {
         var itemInstanceId:uint = param1;
         var equipSlot:uint = param2;
         var responseFinishedCallback:Function = param3;
         var errorCallback:Function = param4;
         var rpcFunc:Function = JSONRPCService.getFunction("equipItemOnAccount",mDBFacade.rpcRoot + "account");
         rpcFunc(mDBFacade.dbAccountInfo.id,itemInstanceId,equipSlot,mDBFacade.validationToken,function(param1:*):void
         {
            mResponseCallback(param1);
            if(responseFinishedCallback != null)
            {
               responseFinishedCallback();
            }
         },function(param1:Error):void
         {
            mParseErrorCallback(param1);
            errorCallback();
         });
      }
      
      public function unequipItemOffAccount(param1:StackableInfo, param2:Function = null, param3:Function = null) : void
      {
         var rpcFunc:Function;
         var itemInfo:StackableInfo = param1;
         var responseFinishedCallback:Function = param2;
         var errorCallback:Function = param3;
         if(!itemInfo.isEquipped)
         {
            Logger.error("Trying to unequip an item that is not currently equipped.");
            if(errorCallback != null)
            {
               errorCallback(new Error("Trying to unequip an item that is not currently equipped.",-1));
            }
         }
         rpcFunc = JSONRPCService.getFunction("unequipItemOffAccount",mDBFacade.rpcRoot + "account");
         rpcFunc(mDBFacade.dbAccountInfo.id,itemInfo.databaseId,mDBFacade.validationToken,function(param1:*):void
         {
            mResponseCallback(param1);
            if(responseFinishedCallback != null)
            {
               responseFinishedCallback();
            }
         },function(param1:Error):void
         {
            mParseErrorCallback(param1);
            errorCallback();
         });
      }
      
      public function equipPetOnAvatar(param1:uint, param2:uint, param3:Function = null, param4:Function = null) : void
      {
         var avatarInstanceId:uint = param1;
         var petId:uint = param2;
         var responseFinishedCallback:Function = param3;
         var errorCallback:Function = param4;
         var rpcFunc:Function = JSONRPCService.getFunction("equipPetOnAvatar",mDBFacade.rpcRoot + "avatarmanager");
         rpcFunc(mDBFacade.dbAccountInfo.id,avatarInstanceId,petId,mDBFacade.validationToken,function(param1:*):void
         {
            mResponseCallback(param1);
            if(responseFinishedCallback != null)
            {
               responseFinishedCallback();
            }
         },function(param1:Error):void
         {
            mParseErrorCallback(param1);
            errorCallback();
         });
      }
      
      public function unequipPet(param1:PetInfo, param2:Function = null, param3:Function = null) : void
      {
         var rpcFunc:Function;
         var petInfo:PetInfo = param1;
         var responseFinishedCallback:Function = param2;
         var errorCallback:Function = param3;
         if(!petInfo.isEquipped)
         {
            Logger.error("Trying to unequip a pet that is not currently equipped.");
            if(errorCallback != null)
            {
               errorCallback(new Error("Trying to unequip a pet that is not currently equipped.",-1));
            }
         }
         rpcFunc = JSONRPCService.getFunction("unEquipPet",mDBFacade.rpcRoot + "avatarmanager");
         rpcFunc(mDBFacade.dbAccountInfo.id,petInfo.databaseId,mDBFacade.validationToken,function(param1:*):void
         {
            mResponseCallback(param1);
            if(responseFinishedCallback != null)
            {
               responseFinishedCallback();
            }
         },function(param1:Error):void
         {
            mParseErrorCallback(param1);
            errorCallback();
         });
      }
      
      public function numberOfEmptySlotsInWeaponStorage() : uint
      {
         return mStorageLimitWeapon - unequippedWeaponCount;
      }
      
      public function isThereEmptySpaceInWeaponStorage() : Boolean
      {
         return unequippedWeaponCount < mStorageLimitWeapon;
      }
      
      public function isEquippableByAnyOwnedAvatar(param1:ItemInfo) : Boolean
      {
         var _loc3_:IMapIterator = null;
         var _loc2_:AvatarInfo = null;
         _loc3_ = mAvatars.iterator() as IMapIterator;
         while(_loc3_.hasNext())
         {
            _loc2_ = _loc3_.next();
            if(this.canThisAvatarEquipThisItem(_loc2_,param1))
            {
               return true;
            }
         }
         return false;
      }
      
      public function get hasNewEquippableItems() : Boolean
      {
         var _loc3_:IMapIterator = null;
         var _loc4_:ItemInfo = null;
         var _loc5_:StackableInfo = null;
         var _loc1_:PetInfo = null;
         _loc3_ = mItems.iterator() as IMapIterator;
         while(_loc3_.hasNext())
         {
            _loc4_ = _loc3_.next();
            if(_loc4_.isNew && this.isEquippableByAnyOwnedAvatar(_loc4_))
            {
               return true;
            }
         }
         _loc3_ = mStackablesByStackableId.iterator() as IMapIterator;
         while(_loc3_.hasNext())
         {
            _loc5_ = _loc3_.next();
            if(_loc5_.isNew)
            {
               return true;
            }
         }
         _loc3_ = mPets.iterator() as IMapIterator;
         while(_loc3_.hasNext())
         {
            _loc1_ = _loc3_.next();
            if(_loc1_.isNew)
            {
               return true;
            }
         }
         for each(var _loc2_ in mChests)
         {
            if(_loc2_.isNew)
            {
               return true;
            }
         }
         return false;
      }
      
      public function markItemsNotNew() : void
      {
         var _loc3_:IMapIterator = null;
         var _loc4_:ItemInfo = null;
         var _loc5_:StackableInfo = null;
         var _loc1_:PetInfo = null;
         _loc3_ = mItems.iterator() as IMapIterator;
         while(_loc3_.hasNext())
         {
            _loc4_ = _loc3_.next();
            _loc4_.isNew = false;
         }
         _loc3_ = mStackablesByStackableId.iterator() as IMapIterator;
         while(_loc3_.hasNext())
         {
            _loc5_ = _loc3_.next();
            _loc5_.isNew = false;
         }
         _loc3_ = mPets.iterator() as IMapIterator;
         while(_loc3_.hasNext())
         {
            _loc1_ = _loc3_.next();
            _loc1_.isNew = false;
         }
         for each(var _loc2_ in mChests)
         {
            _loc2_.isNew = false;
         }
      }
      
      public function getSkinsForHero(param1:GMHero, param2:Map) : Vector.<GMSkin>
      {
         var skin:GMSkin;
         var offer:GMOffer;
         var gmHero:GMHero = param1;
         var offerBySkinId:Map = param2;
         var result:Vector.<GMSkin> = new Vector.<GMSkin>();
         for each(skin in mDBFacade.gameMaster.Skins)
         {
            if(skin.ForHero == gmHero.Constant)
            {
               offer = offerBySkinId.itemFor(skin.Id);
               if(!isSkinExpired(skin,offer))
               {
                  result.push(skin);
               }
            }
         }
         result.sort(function(param1:GMSkin, param2:GMSkin):int
         {
            return param1.Id - param2.Id;
         });
         return result;
      }
      
      public function isSkinExpired(param1:GMSkin, param2:GMOffer) : Boolean
      {
         var _loc7_:Number = Number(GameClock.date.getTime());
         var _loc4_:Boolean = false;
         var _loc3_:Number = 0;
         var _loc6_:Boolean = false;
         var _loc5_:Number = 0;
         if(param2)
         {
            _loc4_ = param2.VisibleDate != null || param2.StartDate != null;
            if(_loc4_)
            {
               _loc3_ = Number(param2.VisibleDate != null ? param2.VisibleDate.getTime() : Number(param2.StartDate.getTime()));
            }
            _loc6_ = param2.EndDate != null || param2.SoldOutDate != null;
            if(_loc6_)
            {
               _loc5_ = Number(param2.SoldOutDate != null ? param2.SoldOutDate.getTime() : Number(param2.EndDate.getTime()));
            }
         }
         if(doesPlayerOwnSkin(param1.Id) || (param2 != null && !_loc4_ || _loc3_ <= _loc7_ && (!_loc6_ || _loc5_ > _loc7_)))
         {
            return false;
         }
         return true;
      }
      
      public function doesPlayerOwnSkin(param1:uint) : Boolean
      {
         return mSkins.hasKey(param1) || mDBFacade.gameMaster.isSkinTypeADefaultSkin(param1);
      }
      
      public function getSkinInfo(param1:uint) : SkinInfo
      {
         if(mSkins.hasKey(param1))
         {
            return mSkins.itemFor(param1);
         }
         return null;
      }
      
      public function getDefaultSkinForHero(param1:GMHero) : GMSkin
      {
         var _loc2_:GMSkin = mDBFacade.gameMaster.getSkinByConstant(param1.DefaultSkin);
         if(_loc2_ == null)
         {
            Logger.error("Unable to find default skin for hero type: " + param1.Id);
         }
         return _loc2_;
      }
      
      public function canShowInfiniteIsland() : Boolean
      {
         var _loc1_:MapnodeInfo = mapnodes1.itemFor(50150);
         return _loc1_ != null;
      }
   }
}

