package GeneratedCode
{
   import DistributedObjects.DistributedNPCGameObject;
   import NetworkCode.DcNetworkClass;
   import NetworkCode.DcNetworkInterface;
   import NetworkCode.DcNetworkPacket;
   import flash.geom.Vector3D;
   
   public class DistributedNPCGameObjectNetworkComponent extends DcNetworkClass implements DcNetworkInterface
   {
      
      private var the_instance:DistributedNPCGameObject;
      
      public const FLID_type:uint = 130;
      
      public const FLID_level:uint = 131;
      
      public const FLID_position:uint = 132;
      
      public const FLID_heading:uint = 133;
      
      public const FLID_scale:uint = 134;
      
      public const FLID_flip:uint = 135;
      
      public const FLID_hitPoints:uint = 136;
      
      public const FLID_weaponDetails:uint = 137;
      
      public const FLID_state:uint = 138;
      
      public const FLID_team:uint = 139;
      
      public const FLID_layer:uint = 140;
      
      public const FLID_remoteTriggerState:uint = 141;
      
      public const FLID_masterId:uint = 142;
      
      public const FLID_ReceiveAttackChoreography:uint = 143;
      
      public const FLID_ReceiveCombatResult:uint = 144;
      
      public const FLID_ReceiveTimelineAction:uint = 145;
      
      public function DistributedNPCGameObjectNetworkComponent(param1:DistributedNPCGameObject, param2:GeneratedDcSocket, param3:uint)
      {
         super(param1,param2,param3);
         the_instance = param1;
      }
      
      public static function netFactory(param1:DcNetworkPacket, param2:GeneratedDcSocket, param3:uint) : DistributedNPCGameObjectNetworkComponent
      {
         var _loc5_:DistributedNPCGameObject = new DistributedNPCGameObject(param2.facade,param3);
         var _loc4_:DistributedNPCGameObjectNetworkComponent = new DistributedNPCGameObjectNetworkComponent(_loc5_,param2,param3);
         _loc4_.generate(param1);
         _loc5_.setNetworkComponentDistributedNPCGameObject(_loc4_);
         _loc5_.postGenerate();
         return _loc4_;
      }
      
      override public function recvById(param1:DcNetworkPacket, param2:uint) : void
      {
         switch(int(param2) - 130)
         {
            case 0:
               recv_type(param1);
               break;
            case 1:
               recv_level(param1);
               break;
            case 2:
               recv_position(param1);
               break;
            case 3:
               recv_heading(param1);
               break;
            case 4:
               recv_scale(param1);
               break;
            case 5:
               recv_flip(param1);
               break;
            case 6:
               recv_hitPoints(param1);
               break;
            case 7:
               recv_weaponDetails(param1);
               break;
            case 8:
               recv_state(param1);
               break;
            case 9:
               recv_team(param1);
               break;
            case 10:
               recv_layer(param1);
               break;
            case 11:
               recv_remoteTriggerState(param1);
               break;
            case 12:
               recv_masterId(param1);
               break;
            case 13:
               recv_ReceiveAttackChoreography(param1);
               break;
            case 14:
               recv_ReceiveCombatResult(param1);
               break;
            case 15:
               recv_ReceiveTimelineAction(param1);
               break;
            default:
               super.recvById(param1,param2);
         }
      }
      
      override public function generate(param1:DcNetworkPacket) : void
      {
         recv_type(param1);
         recv_level(param1);
         recv_position(param1);
         recv_heading(param1);
         recv_scale(param1);
         recv_flip(param1);
         recv_hitPoints(param1);
         recv_weaponDetails(param1);
         recv_state(param1);
         recv_team(param1);
         recv_layer(param1);
         recv_remoteTriggerState(param1);
         recv_masterId(param1);
         recvByIdLoop(param1);
      }
      
      override public function destroy() : void
      {
         the_instance.destroy();
      }
      
      public function recv_type(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedInt();
         the_instance.type = _loc2_;
      }
      
      public function recv_level(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedByte();
         the_instance.level = _loc2_;
      }
      
      public function recv_position(param1:DcNetworkPacket) : void
      {
         var packet:DcNetworkPacket = param1;
         var v_position:Vector3D = (function(param1:DcNetworkPacket):Vector3D
         {
            var _loc2_:Vector3D = new Vector3D();
            _loc2_.x = param1.readFloat();
            _loc2_.y = param1.readFloat();
            return _loc2_;
         })(packet);
         the_instance.position = v_position;
      }
      
      public function recv_heading(param1:DcNetworkPacket) : void
      {
         var _loc2_:Number = param1.readFloat();
         the_instance.heading = _loc2_;
      }
      
      public function recv_scale(param1:DcNetworkPacket) : void
      {
         var _loc2_:Number = param1.readFloat();
         the_instance.scale = _loc2_;
      }
      
      public function recv_flip(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedByte();
         the_instance.flip = _loc2_;
      }
      
      public function recv_hitPoints(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedInt();
         the_instance.hitPoints = _loc2_;
      }
      
      public function recv_weaponDetails(param1:DcNetworkPacket) : void
      {
         var packet:DcNetworkPacket = param1;
         var v_weaponDetails:Vector.<WeaponDetails> = (function(param1:DcNetworkPacket):Vector.<WeaponDetails>
         {
            var _loc3_:* = 0;
            var _loc5_:WeaponDetails = null;
            var _loc4_:Vector.<WeaponDetails> = new Vector.<WeaponDetails>();
            var _loc2_:uint = 4;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc5_ = WeaponDetails.readFromPacket(param1);
               _loc4_.push(_loc5_);
               _loc3_++;
            }
            return _loc4_;
         })(packet);
         the_instance.weaponDetails = v_weaponDetails;
      }
      
      public function recv_state(param1:DcNetworkPacket) : void
      {
         var _loc2_:String = param1.readUTF();
         the_instance.state = _loc2_;
      }
      
      public function recv_team(param1:DcNetworkPacket) : void
      {
         var _loc2_:int = param1.readByte();
         the_instance.team = _loc2_;
      }
      
      public function recv_layer(param1:DcNetworkPacket) : void
      {
         var _loc2_:int = param1.readByte();
         the_instance.layer = _loc2_;
      }
      
      public function recv_remoteTriggerState(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedByte();
         the_instance.remoteTriggerState = _loc2_;
      }
      
      public function recv_masterId(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedInt();
         the_instance.masterId = _loc2_;
      }
      
      public function recv_ReceiveAttackChoreography(param1:DcNetworkPacket) : void
      {
         var _loc2_:AttackChoreography = AttackChoreography.readFromPacket(param1);
         the_instance.ReceiveAttackChoreography(_loc2_);
      }
      
      public function recv_ReceiveCombatResult(param1:DcNetworkPacket) : void
      {
         var _loc2_:CombatResult = CombatResult.readFromPacket(param1);
         the_instance.ReceiveCombatResult(_loc2_);
      }
      
      public function recv_ReceiveTimelineAction(param1:DcNetworkPacket) : void
      {
         var _loc2_:String = param1.readUTF();
         the_instance.ReceiveTimelineAction(_loc2_);
      }
   }
}

