package GeneratedCode
{
   import DistributedObjects.DistributedDungeonSummary;
   import NetworkCode.DcNetworkClass;
   import NetworkCode.DcNetworkInterface;
   import NetworkCode.DcNetworkPacket;
   
   public class DistributedDungeonSummaryNetworkComponent extends DcNetworkClass implements DcNetworkInterface
   {
      
      private var the_instance:DistributedDungeonSummary;
      
      public const FLID_map_node_id:uint = 273;
      
      public const FLID_report:uint = 274;
      
      public const FLID_dungeon_name:uint = 275;
      
      public const FLID_dungeonSuccess:uint = 276;
      
      public const FLID_dungeonMod1:uint = 277;
      
      public const FLID_dungeonMod2:uint = 278;
      
      public const FLID_dungeonMod3:uint = 279;
      
      public const FLID_dungeonMod4:uint = 280;
      
      public const FLID_OpenChest:uint = 281;
      
      public const FLID_TakeChest:uint = 282;
      
      public const FLID_DropChest:uint = 283;
      
      public const FLID_TransactionResponse:uint = 284;
      
      public function DistributedDungeonSummaryNetworkComponent(param1:DistributedDungeonSummary, param2:GeneratedDcSocket, param3:uint)
      {
         super(param1,param2,param3);
         the_instance = param1;
      }
      
      public static function netFactory(param1:DcNetworkPacket, param2:GeneratedDcSocket, param3:uint) : DistributedDungeonSummaryNetworkComponent
      {
         var _loc5_:DistributedDungeonSummary = new DistributedDungeonSummary(param2.facade,param3);
         var _loc4_:DistributedDungeonSummaryNetworkComponent = new DistributedDungeonSummaryNetworkComponent(_loc5_,param2,param3);
         _loc4_.generate(param1);
         _loc5_.setNetworkComponentDistributedDungeonSummary(_loc4_);
         _loc5_.postGenerate();
         return _loc4_;
      }
      
      override public function recvById(param1:DcNetworkPacket, param2:uint) : void
      {
         switch(int(param2) - 273)
         {
            case 0:
               recv_map_node_id(param1);
               break;
            case 1:
               recv_report(param1);
               break;
            case 2:
               recv_dungeon_name(param1);
               break;
            case 3:
               recv_dungeonSuccess(param1);
               break;
            case 4:
               recv_dungeonMod1(param1);
               break;
            case 5:
               recv_dungeonMod2(param1);
               break;
            case 6:
               recv_dungeonMod3(param1);
               break;
            case 7:
               recv_dungeonMod4(param1);
               break;
            case 11:
               recv_TransactionResponse(param1);
               break;
            default:
               super.recvById(param1,param2);
         }
      }
      
      override public function generate(param1:DcNetworkPacket) : void
      {
         recv_map_node_id(param1);
         recv_report(param1);
         recv_dungeon_name(param1);
         recv_dungeonSuccess(param1);
         recv_dungeonMod1(param1);
         recv_dungeonMod2(param1);
         recv_dungeonMod3(param1);
         recv_dungeonMod4(param1);
         recvByIdLoop(param1);
      }
      
      override public function destroy() : void
      {
         the_instance.destroy();
      }
      
      public function recv_map_node_id(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedInt();
         the_instance.map_node_id = _loc2_;
      }
      
      public function recv_report(param1:DcNetworkPacket) : void
      {
         var packet:DcNetworkPacket = param1;
         var v_report:Vector.<DungeonReport> = (function(param1:DcNetworkPacket):Vector.<DungeonReport>
         {
            var _loc5_:DungeonReport = null;
            var _loc3_:Vector.<DungeonReport> = new Vector.<DungeonReport>();
            var _loc2_:uint = param1.readUnsignedShort();
            var _loc4_:uint = _loc2_ + param1.position;
            while(param1.position < _loc4_)
            {
               _loc5_ = DungeonReport.readFromPacket(param1);
               _loc3_.push(_loc5_);
            }
            return _loc3_;
         })(packet);
         the_instance.report = v_report;
      }
      
      public function recv_dungeon_name(param1:DcNetworkPacket) : void
      {
         var _loc2_:String = param1.readUTF();
         the_instance.dungeon_name = _loc2_;
      }
      
      public function recv_dungeonSuccess(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedByte();
         the_instance.dungeonSuccess = _loc2_;
      }
      
      public function recv_dungeonMod1(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedInt();
         the_instance.dungeonMod1 = _loc2_;
      }
      
      public function recv_dungeonMod2(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedInt();
         the_instance.dungeonMod2 = _loc2_;
      }
      
      public function recv_dungeonMod3(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedInt();
         the_instance.dungeonMod3 = _loc2_;
      }
      
      public function recv_dungeonMod4(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedInt();
         the_instance.dungeonMod4 = _loc2_;
      }
      
      public function send_OpenChest(param1:uint, param2:uint) : void
      {
         var _loc3_:DcNetworkPacket = new DcNetworkPacket();
         Prepare_FieldUpdate(_loc3_,281);
         _loc3_.writeUnsignedInt(param1);
         _loc3_.writeUnsignedInt(param2);
         Send_packet(_loc3_);
      }
      
      public function send_TakeChest(param1:uint, param2:uint) : void
      {
         var _loc3_:DcNetworkPacket = new DcNetworkPacket();
         Prepare_FieldUpdate(_loc3_,282);
         _loc3_.writeUnsignedInt(param1);
         _loc3_.writeUnsignedInt(param2);
         Send_packet(_loc3_);
      }
      
      public function send_DropChest(param1:uint, param2:uint) : void
      {
         var _loc3_:DcNetworkPacket = new DcNetworkPacket();
         Prepare_FieldUpdate(_loc3_,283);
         _loc3_.writeUnsignedInt(param1);
         _loc3_.writeUnsignedInt(param2);
         Send_packet(_loc3_);
      }
      
      public function recv_TransactionResponse(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedInt();
         var _loc4_:uint = param1.readUnsignedByte();
         var _loc3_:uint = param1.readUnsignedInt();
         var _loc5_:uint = param1.readUnsignedInt();
         the_instance.TransactionResponse(_loc2_,_loc4_,_loc3_,_loc5_);
      }
   }
}

