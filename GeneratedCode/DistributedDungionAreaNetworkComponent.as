package GeneratedCode
{
   import DistributedObjects.DistributedDungionArea;
   import NetworkCode.DcNetworkClass;
   import NetworkCode.DcNetworkInterface;
   import NetworkCode.DcNetworkPacket;
   
   public class DistributedDungionAreaNetworkComponent extends DcNetworkClass implements DcNetworkInterface
   {
      
      private var the_instance:DistributedDungionArea;
      
      public const FLID_tileLibrary:uint = 211;
      
      public const FLID_cacheNpc:uint = 212;
      
      public const FLID_cacheSWC:uint = 213;
      
      public const FLID_floorReward:uint = 214;
      
      public const FLID_floorEnding:uint = 215;
      
      public const FLID_dungeonEnding:uint = 216;
      
      public const FLID_floorfailing:uint = 217;
      
      public const FLID_tellClientInfiniteRewardData:uint = 218;
      
      public function DistributedDungionAreaNetworkComponent(param1:DistributedDungionArea, param2:GeneratedDcSocket, param3:uint)
      {
         super(param1,param2,param3);
         the_instance = param1;
      }
      
      public static function netFactory(param1:DcNetworkPacket, param2:GeneratedDcSocket, param3:uint) : DistributedDungionAreaNetworkComponent
      {
         var _loc5_:DistributedDungionArea = new DistributedDungionArea(param2.facade,param3);
         var _loc4_:DistributedDungionAreaNetworkComponent = new DistributedDungionAreaNetworkComponent(_loc5_,param2,param3);
         _loc4_.generate(param1);
         _loc5_.setNetworkComponentDistributedDungionArea(_loc4_);
         _loc5_.postGenerate();
         return _loc4_;
      }
      
      override public function recvById(param1:DcNetworkPacket, param2:uint) : void
      {
         switch(int(param2) - 211)
         {
            case 0:
               recv_tileLibrary(param1);
               break;
            case 1:
               recv_cacheNpc(param1);
               break;
            case 2:
               recv_cacheSWC(param1);
               break;
            case 3:
               recv_floorReward(param1);
               break;
            case 4:
               recv_floorEnding(param1);
               break;
            case 5:
               recv_dungeonEnding(param1);
               break;
            case 6:
               recv_floorfailing(param1);
               break;
            case 7:
               recv_tellClientInfiniteRewardData(param1);
               break;
            default:
               super.recvById(param1,param2);
         }
      }
      
      override public function generate(param1:DcNetworkPacket) : void
      {
         recv_tileLibrary(param1);
         recv_cacheNpc(param1);
         recv_cacheSWC(param1);
         recvByIdLoop(param1);
      }
      
      override public function destroy() : void
      {
         the_instance.destroy();
      }
      
      public function recv_tileLibrary(param1:DcNetworkPacket) : void
      {
         var packet:DcNetworkPacket = param1;
         var tileLibrary:Vector.<swrapper> = (function(param1:DcNetworkPacket):Vector.<swrapper>
         {
            var _loc5_:swrapper = null;
            var _loc3_:Vector.<swrapper> = new Vector.<swrapper>();
            var _loc2_:uint = param1.readUnsignedShort();
            var _loc4_:uint = _loc2_ + param1.position;
            while(param1.position < _loc4_)
            {
               _loc5_ = swrapper.readFromPacket(param1);
               _loc3_.push(_loc5_);
            }
            return _loc3_;
         })(packet);
         the_instance.tileLibrary(tileLibrary);
      }
      
      public function recv_cacheNpc(param1:DcNetworkPacket) : void
      {
         var packet:DcNetworkPacket = param1;
         var v_cacheNpc:Vector.<uint> = (function(param1:DcNetworkPacket):Vector.<uint>
         {
            var _loc5_:* = 0;
            var _loc3_:Vector.<uint> = new Vector.<uint>();
            var _loc2_:uint = param1.readUnsignedShort();
            var _loc4_:uint = _loc2_ + param1.position;
            while(param1.position < _loc4_)
            {
               _loc5_ = param1.readUnsignedInt();
               _loc3_.push(_loc5_);
            }
            return _loc3_;
         })(packet);
         the_instance.cacheNpc = v_cacheNpc;
      }
      
      public function recv_cacheSWC(param1:DcNetworkPacket) : void
      {
         var packet:DcNetworkPacket = param1;
         var v_cacheSWC:Vector.<swrapper> = (function(param1:DcNetworkPacket):Vector.<swrapper>
         {
            var _loc5_:swrapper = null;
            var _loc3_:Vector.<swrapper> = new Vector.<swrapper>();
            var _loc2_:uint = param1.readUnsignedShort();
            var _loc4_:uint = _loc2_ + param1.position;
            while(param1.position < _loc4_)
            {
               _loc5_ = swrapper.readFromPacket(param1);
               _loc3_.push(_loc5_);
            }
            return _loc3_;
         })(packet);
         the_instance.cacheSWC = v_cacheSWC;
      }
      
      public function recv_floorReward(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedInt();
         the_instance.floorReward(_loc2_);
      }
      
      public function recv_floorEnding(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedShort();
         the_instance.floorEnding(_loc2_);
      }
      
      public function recv_dungeonEnding(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedShort();
         var _loc3_:uint = param1.readUnsignedByte();
         the_instance.dungeonEnding(_loc2_,_loc3_);
      }
      
      public function recv_floorfailing(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedShort();
         the_instance.floorfailing(_loc2_);
      }
      
      public function recv_tellClientInfiniteRewardData(param1:DcNetworkPacket) : void
      {
         var packet:DcNetworkPacket = param1;
         var avId:uint = packet.readUnsignedInt();
         var avScore:uint = packet.readUnsignedShort();
         var goldReward:uint = packet.readUnsignedInt();
         var infiniteRewards:Vector.<InfiniteRewardData> = (function(param1:DcNetworkPacket):Vector.<InfiniteRewardData>
         {
            var _loc5_:InfiniteRewardData = null;
            var _loc3_:Vector.<InfiniteRewardData> = new Vector.<InfiniteRewardData>();
            var _loc2_:uint = param1.readUnsignedShort();
            var _loc4_:uint = _loc2_ + param1.position;
            while(param1.position < _loc4_)
            {
               _loc5_ = InfiniteRewardData.readFromPacket(param1);
               _loc3_.push(_loc5_);
            }
            return _loc3_;
         })(packet);
         the_instance.tellClientInfiniteRewardData(avId,avScore,goldReward,infiniteRewards);
      }
   }
}

