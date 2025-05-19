package GeneratedCode
{
   import DistributedObjects.HeroGameObjectOwner;
   import NetworkCode.DcNetworkInterface;
   import NetworkCode.DcNetworkPacket;
   import flash.geom.Vector3D;
   
   public class HeroGameObjectOwnerNetworkComponent extends HeroGameObjectNetworkComponent implements DcNetworkInterface
   {
      
      private var the_instance:IHeroGameObjectOwner;
      
      public function HeroGameObjectOwnerNetworkComponent(param1:HeroGameObjectOwner, param2:GeneratedDcSocket, param3:uint)
      {
         super(param1,param2,param3);
         the_instance = param1;
      }
      
      public static function ownerFactory(param1:DcNetworkPacket, param2:GeneratedDcSocket, param3:uint) : HeroGameObjectOwnerNetworkComponent
      {
         var _loc5_:HeroGameObjectOwner = new HeroGameObjectOwner(param2.facade,param3);
         var _loc4_:HeroGameObjectOwnerNetworkComponent = new HeroGameObjectOwnerNetworkComponent(_loc5_,param2,param3);
         _loc4_.generate(param1);
         _loc5_.setNetworkComponentHeroGameObject(_loc4_);
         _loc5_.setOwnerNetworkComponentHeroGameObject(_loc4_);
         _loc5_.postGenerate();
         return _loc4_;
      }
      
      override public function recvById(param1:DcNetworkPacket, param2:uint) : void
      {
         switch(int(param2) - 168)
         {
            case 0:
               recv_ReportBuffEffect(param1);
               break;
            case 1:
               recv_ReceivedBuffEffect(param1);
               break;
            case 2:
               recv_TooFullForDoober(param1);
               break;
            case 7:
               recv_ProposeSelfRevive_Resp(param1);
               break;
            default:
               super.recvById(param1,param2);
         }
      }
      
      override public function generate(param1:DcNetworkPacket) : void
      {
         recv_type(param1);
         recv_position(param1);
         recv_heading(param1);
         recv_scale(param1);
         recv_flip(param1);
         recv_hitPoints(param1);
         recv_weaponDetails(param1);
         recv_consumableDetails(param1);
         recv_healthBombsUsed(param1);
         recv_partyBombsUsed(param1);
         recv_playerID(param1);
         recv_state(param1);
         recv_team(param1);
         recv_skinType(param1);
         recv_screenName(param1);
         recv_manaPoints(param1);
         recv_experiencePoints(param1);
         recv_slotPoints(param1);
         recv_dungeonBusterPoints(param1);
         recv_setAFK(param1);
         recvByIdLoop(param1);
      }
      
      public function send_position(param1:Vector3D) : void
      {
         var _loc2_:DcNetworkPacket = new DcNetworkPacket();
         Prepare_FieldUpdate(_loc2_,147);
         _loc2_.writeFloat(param1.x);
         _loc2_.writeFloat(param1.y);
         Send_packet(_loc2_);
      }
      
      public function send_heading(param1:Number) : void
      {
         var _loc2_:DcNetworkPacket = new DcNetworkPacket();
         Prepare_FieldUpdate(_loc2_,148);
         _loc2_.writeFloat(param1);
         Send_packet(_loc2_);
      }
      
      public function send_ReceiveAttackChoreography(param1:AttackChoreography) : void
      {
         var _loc2_:DcNetworkPacket = new DcNetworkPacket();
         Prepare_FieldUpdate(_loc2_,159);
         param1.writeToPacket(_loc2_);
         Send_packet(_loc2_);
      }
      
      public function recv_ReportBuffEffect(param1:DcNetworkPacket) : void
      {
         var _loc5_:uint = param1.readUnsignedInt();
         var _loc3_:int = param1.readInt();
         var _loc4_:uint = param1.readUnsignedInt();
         var _loc2_:int = param1.readByte();
         the_instance.ReportBuffEffect(_loc5_,_loc3_,_loc4_,_loc2_);
      }
      
      public function recv_ReceivedBuffEffect(param1:DcNetworkPacket) : void
      {
         var _loc3_:int = param1.readInt();
         var _loc4_:uint = param1.readUnsignedInt();
         var _loc2_:int = param1.readByte();
         the_instance.ReceivedBuffEffect(_loc3_,_loc4_,_loc2_);
      }
      
      public function recv_TooFullForDoober(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedByte();
         the_instance.TooFullForDoober(_loc2_);
      }
      
      public function send_ProposeCombatResults(param1:Vector.<CombatResult>) : void
      {
         var combatResultsfunc:Function;
         var combatResults:Vector.<CombatResult> = param1;
         var outpacket:DcNetworkPacket = new DcNetworkPacket();
         Prepare_FieldUpdate(outpacket,171);
         combatResultsfunc = function():void
         {
            var _loc2_:* = 0;
            var _loc1_:uint = combatResults.length;
            var _loc3_:DcNetworkPacket = outpacket;
            outpacket = new DcNetworkPacket();
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               combatResults[_loc2_].writeToPacket(outpacket);
               _loc2_++;
            }
            _loc3_.writeShort(outpacket.length);
            _loc3_.writeBytes(outpacket);
            outpacket = _loc3_;
         };
         combatResultsfunc();
         Send_packet(outpacket);
      }
      
      public function send_ProposeAttackChoreography(param1:AttackChoreography) : void
      {
         var _loc2_:DcNetworkPacket = new DcNetworkPacket();
         Prepare_FieldUpdate(_loc2_,172);
         param1.writeToPacket(_loc2_);
         Send_packet(_loc2_);
      }
      
      public function send_ProposeRevive(param1:uint) : void
      {
         var _loc2_:DcNetworkPacket = new DcNetworkPacket();
         Prepare_FieldUpdate(_loc2_,173);
         _loc2_.writeUnsignedInt(param1);
         Send_packet(_loc2_);
      }
      
      public function send_ProposeSelfRevive(param1:uint) : void
      {
         var _loc2_:DcNetworkPacket = new DcNetworkPacket();
         Prepare_FieldUpdate(_loc2_,174);
         _loc2_.writeByte(param1);
         Send_packet(_loc2_);
      }
      
      public function recv_ProposeSelfRevive_Resp(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedByte();
         var _loc3_:uint = param1.readUnsignedByte();
         the_instance.ProposeSelfRevive_Resp(_loc2_,_loc3_);
      }
      
      public function send_ProposeCreateNPC(param1:uint, param2:uint, param3:Number, param4:Number) : void
      {
         var _loc5_:DcNetworkPacket = new DcNetworkPacket();
         Prepare_FieldUpdate(_loc5_,177);
         _loc5_.writeUnsignedInt(param1);
         _loc5_.writeUnsignedInt(param2);
         _loc5_.writeFloat(param3);
         _loc5_.writeFloat(param4);
         Send_packet(_loc5_);
      }
      
      public function send_StopChoreography() : void
      {
         var _loc1_:DcNetworkPacket = new DcNetworkPacket();
         Prepare_FieldUpdate(_loc1_,179);
         Send_packet(_loc1_);
      }
   }
}

