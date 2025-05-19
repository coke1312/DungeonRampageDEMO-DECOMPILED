package GeneratedCode
{
   import DistributedObjects.HeroGameObject;
   import NetworkCode.DcNetworkClass;
   import NetworkCode.DcNetworkInterface;
   import NetworkCode.DcNetworkPacket;
   import flash.geom.Vector3D;
   
   public class HeroGameObjectNetworkComponent extends DcNetworkClass implements DcNetworkInterface
   {
      
      private var the_instance:HeroGameObject;
      
      public const FLID_type:uint = 146;
      
      public const FLID_position:uint = 147;
      
      public const FLID_heading:uint = 148;
      
      public const FLID_scale:uint = 149;
      
      public const FLID_flip:uint = 150;
      
      public const FLID_hitPoints:uint = 151;
      
      public const FLID_weaponDetails:uint = 152;
      
      public const FLID_consumableDetails:uint = 153;
      
      public const FLID_healthBombsUsed:uint = 154;
      
      public const FLID_partyBombsUsed:uint = 155;
      
      public const FLID_playerID:uint = 156;
      
      public const FLID_state:uint = 157;
      
      public const FLID_team:uint = 158;
      
      public const FLID_ReceiveAttackChoreography:uint = 159;
      
      public const FLID_ReceiveCombatResult:uint = 160;
      
      public const FLID_skinType:uint = 161;
      
      public const FLID_screenName:uint = 162;
      
      public const FLID_manaPoints:uint = 163;
      
      public const FLID_experiencePoints:uint = 164;
      
      public const FLID_slotPoints:uint = 165;
      
      public const FLID_dungeonBusterPoints:uint = 166;
      
      public const FLID_setAFK:uint = 167;
      
      public const FLID_ReportBuffEffect:uint = 168;
      
      public const FLID_ReceivedBuffEffect:uint = 169;
      
      public const FLID_TooFullForDoober:uint = 170;
      
      public const FLID_ProposeCombatResults:uint = 171;
      
      public const FLID_ProposeAttackChoreography:uint = 172;
      
      public const FLID_ProposeRevive:uint = 173;
      
      public const FLID_ProposeSelfRevive:uint = 174;
      
      public const FLID_ProposeSelfRevive_Resp:uint = 175;
      
      public const FLID_PartyBomb:uint = 176;
      
      public const FLID_ProposeCreateNPC:uint = 177;
      
      public const FLID_setStateAndAttackChoreography:uint = 178;
      
      public const FLID_StopChoreography:uint = 179;
      
      public function HeroGameObjectNetworkComponent(param1:HeroGameObject, param2:GeneratedDcSocket, param3:uint)
      {
         super(param1,param2,param3);
         the_instance = param1;
      }
      
      public static function netFactory(param1:DcNetworkPacket, param2:GeneratedDcSocket, param3:uint) : HeroGameObjectNetworkComponent
      {
         var _loc5_:HeroGameObject = new HeroGameObject(param2.facade,param3);
         var _loc4_:HeroGameObjectNetworkComponent = new HeroGameObjectNetworkComponent(_loc5_,param2,param3);
         _loc4_.generate(param1);
         _loc5_.setNetworkComponentHeroGameObject(_loc4_);
         _loc5_.postGenerate();
         return _loc4_;
      }
      
      override public function recvById(param1:DcNetworkPacket, param2:uint) : void
      {
         switch(param2)
         {
            case 146:
               recv_type(param1);
               break;
            case 147:
               recv_position(param1);
               break;
            case 148:
               recv_heading(param1);
               break;
            case 149:
               recv_scale(param1);
               break;
            case 150:
               recv_flip(param1);
               break;
            case 151:
               recv_hitPoints(param1);
               break;
            case 152:
               recv_weaponDetails(param1);
               break;
            case 153:
               recv_consumableDetails(param1);
               break;
            case 154:
               recv_healthBombsUsed(param1);
               break;
            case 155:
               recv_partyBombsUsed(param1);
               break;
            case 156:
               recv_playerID(param1);
               break;
            case 157:
               recv_state(param1);
               break;
            case 158:
               recv_team(param1);
               break;
            case 159:
               recv_ReceiveAttackChoreography(param1);
               break;
            case 160:
               recv_ReceiveCombatResult(param1);
               break;
            case 161:
               recv_skinType(param1);
               break;
            case 162:
               recv_screenName(param1);
               break;
            case 163:
               recv_manaPoints(param1);
               break;
            case 164:
               recv_experiencePoints(param1);
               break;
            case 165:
               recv_slotPoints(param1);
               break;
            case 166:
               recv_dungeonBusterPoints(param1);
               break;
            case 167:
               recv_setAFK(param1);
               break;
            case 176:
               recv_PartyBomb(param1);
               break;
            case 178:
               recv_setStateAndAttackChoreography(param1);
               break;
            case 179:
               recv_StopChoreography(param1);
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
      
      override public function destroy() : void
      {
         the_instance.destroy();
      }
      
      public function recv_type(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedInt();
         the_instance.type = _loc2_;
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
         var _loc2_:uint = param1.readUnsignedShort();
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
      
      public function recv_consumableDetails(param1:DcNetworkPacket) : void
      {
         var packet:DcNetworkPacket = param1;
         var v_consumableDetails:Vector.<ConsumableDetails> = (function(param1:DcNetworkPacket):Vector.<ConsumableDetails>
         {
            var _loc3_:* = 0;
            var _loc5_:ConsumableDetails = null;
            var _loc4_:Vector.<ConsumableDetails> = new Vector.<ConsumableDetails>();
            var _loc2_:uint = 2;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc5_ = ConsumableDetails.readFromPacket(param1);
               _loc4_.push(_loc5_);
               _loc3_++;
            }
            return _loc4_;
         })(packet);
         the_instance.consumableDetails = v_consumableDetails;
      }
      
      public function recv_healthBombsUsed(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedByte();
         the_instance.healthBombsUsed = _loc2_;
      }
      
      public function recv_partyBombsUsed(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedByte();
         the_instance.partyBombsUsed = _loc2_;
      }
      
      public function recv_playerID(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedInt();
         the_instance.playerID = _loc2_;
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
      
      public function recv_skinType(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedInt();
         the_instance.skinType = _loc2_;
      }
      
      public function recv_screenName(param1:DcNetworkPacket) : void
      {
         var _loc2_:String = param1.readUTF();
         the_instance.screenName = _loc2_;
      }
      
      public function recv_manaPoints(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedShort();
         the_instance.manaPoints = _loc2_;
      }
      
      public function recv_experiencePoints(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedInt();
         the_instance.experiencePoints = _loc2_;
      }
      
      public function recv_slotPoints(param1:DcNetworkPacket) : void
      {
         var packet:DcNetworkPacket = param1;
         var v_slotPoints:Vector.<uint> = (function(param1:DcNetworkPacket):Vector.<uint>
         {
            var _loc3_:* = 0;
            var _loc5_:* = 0;
            var _loc4_:Vector.<uint> = new Vector.<uint>();
            var _loc2_:uint = 4;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc5_ = param1.readUnsignedShort();
               _loc4_.push(_loc5_);
               _loc3_++;
            }
            return _loc4_;
         })(packet);
         the_instance.slotPoints = v_slotPoints;
      }
      
      public function recv_dungeonBusterPoints(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedInt();
         the_instance.dungeonBusterPoints = _loc2_;
      }
      
      public function recv_setAFK(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedByte();
         the_instance.setAFK = _loc2_;
      }
      
      public function recv_PartyBomb(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedInt();
         the_instance.PartyBomb(_loc2_);
      }
      
      public function recv_setStateAndAttackChoreography(param1:DcNetworkPacket) : void
      {
         var _loc2_:String = param1.readUTF();
         var _loc3_:AttackChoreography = AttackChoreography.readFromPacket(param1);
         the_instance.setStateAndAttackChoreography(_loc2_,_loc3_);
      }
      
      public function recv_StopChoreography(param1:DcNetworkPacket) : void
      {
         the_instance.StopChoreography();
      }
   }
}

