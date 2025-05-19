package org.as3commons.collections.framework.core
{
   import org.as3commons.collections.framework.IComparator;
   import org.as3commons.collections.framework.IIterator;
   import org.as3commons.collections.framework.ISortOrder;
   
   use namespace as3commons_collections;
   
   public class AbstractSortedCollection implements ISortOrder
   {
      
      protected var _root:SortedNode;
      
      protected var _size:uint = 0;
      
      protected var _comparator:IComparator;
      
      public function AbstractSortedCollection(param1:IComparator)
      {
         super();
         this._comparator = param1;
      }
      
      protected function addNode(param1:SortedNode) : void
      {
         var _loc3_:int = 0;
         if(!this._root)
         {
            this._comparator.compare(param1.item,param1.item);
            this._root = param1;
            ++this._size;
            return;
         }
         var _loc2_:SortedNode = this._root;
         while(_loc2_)
         {
            _loc3_ = this._comparator.compare(param1.item,_loc2_.item);
            if(!_loc3_)
            {
               _loc3_ = param1.order < _loc2_.order ? -1 : 1;
            }
            if(_loc3_ == -1)
            {
               if(!_loc2_.left)
               {
                  param1.parent = _loc2_;
                  _loc2_.left = param1;
                  _loc2_ = _loc2_.left;
                  break;
               }
               _loc2_ = _loc2_.left;
            }
            else
            {
               if(_loc3_ != 1)
               {
                  return;
               }
               if(!_loc2_.right)
               {
                  param1.parent = _loc2_;
                  _loc2_.right = param1;
                  _loc2_ = _loc2_.right;
                  break;
               }
               _loc2_ = _loc2_.right;
            }
         }
         while(_loc2_.parent)
         {
            if(_loc2_.parent.priority >= _loc2_.priority)
            {
               break;
            }
            this.rotate(_loc2_.parent,_loc2_);
         }
         ++this._size;
      }
      
      public function remove(param1:*) : Boolean
      {
         var _loc2_:SortedNode = this.firstEqualNode(param1);
         if(!_loc2_)
         {
            return false;
         }
         if(_loc2_.item === param1)
         {
            this.removeNode(_loc2_);
            return true;
         }
         _loc2_ = this.as3commons_collections::nextNode_internal(_loc2_);
         while(_loc2_)
         {
            if(this._comparator.compare(param1,_loc2_.item))
            {
               break;
            }
            if(_loc2_.item === param1)
            {
               this.removeNode(_loc2_);
               return true;
            }
            _loc2_ = this.as3commons_collections::nextNode_internal(_loc2_);
         }
         return false;
      }
      
      protected function firstEqualNode(param1:*) : SortedNode
      {
         var _loc3_:SortedNode = null;
         var _loc4_:int = 0;
         var _loc2_:SortedNode = this._root;
         while(_loc2_)
         {
            _loc4_ = this._comparator.compare(param1,_loc2_.item);
            if(_loc4_ == -1)
            {
               if(_loc3_)
               {
                  return _loc3_;
               }
               _loc2_ = _loc2_.left;
            }
            else if(_loc4_ == 1)
            {
               _loc2_ = _loc2_.right;
            }
            else
            {
               _loc3_ = _loc2_;
               _loc2_ = _loc2_.left;
            }
         }
         return _loc3_;
      }
      
      public function get size() : uint
      {
         return this._size;
      }
      
      public function removeLast() : *
      {
         var _loc1_:SortedNode = this.as3commons_collections::mostRightNode_internal();
         if(!_loc1_)
         {
            return undefined;
         }
         this.removeNode(_loc1_);
         return _loc1_.item;
      }
      
      public function removeFirst() : *
      {
         var _loc1_:SortedNode = this.as3commons_collections::mostLeftNode_internal();
         if(!_loc1_)
         {
            return undefined;
         }
         this.removeNode(_loc1_);
         return _loc1_.item;
      }
      
      public function clear() : Boolean
      {
         if(!this._size)
         {
            return false;
         }
         this._root = null;
         this._size = 0;
         return true;
      }
      
      public function hasEqual(param1:*) : Boolean
      {
         var _loc3_:int = 0;
         var _loc2_:SortedNode = this._root;
         while(_loc2_)
         {
            _loc3_ = this._comparator.compare(param1,_loc2_.item);
            if(_loc3_ == -1)
            {
               _loc2_ = _loc2_.left;
            }
            else
            {
               if(_loc3_ != 1)
               {
                  return true;
               }
               _loc2_ = _loc2_.right;
            }
         }
         return false;
      }
      
      public function get last() : *
      {
         if(!this._root)
         {
            return undefined;
         }
         return this.as3commons_collections::mostRightNode_internal().item;
      }
      
      as3commons_collections function mostLeftNode_internal(param1:SortedNode = null) : SortedNode
      {
         if(!this._root)
         {
            return null;
         }
         if(!param1)
         {
            param1 = this._root;
         }
         while(param1.left)
         {
            param1 = param1.left;
         }
         return param1;
      }
      
      as3commons_collections function mostRightNode_internal(param1:SortedNode = null) : SortedNode
      {
         if(!this._root)
         {
            return null;
         }
         if(!param1)
         {
            param1 = this._root;
         }
         while(param1.right)
         {
            param1 = param1.right;
         }
         return param1;
      }
      
      protected function rotate(param1:SortedNode, param2:SortedNode) : void
      {
         var _loc3_:SortedNode = param1.parent;
         var _loc4_:String = "right";
         var _loc5_:String = "left";
         if(param2 == param1.left)
         {
            _loc4_ = "left";
            _loc5_ = "right";
         }
         param1[_loc4_] = param2[_loc5_];
         if(param2[_loc5_])
         {
            SortedNode(param2[_loc5_]).parent = param1;
         }
         param1.parent = param2;
         param2[_loc5_] = param1;
         param2.parent = _loc3_;
         if(_loc3_)
         {
            if(_loc3_[_loc5_] == param1)
            {
               _loc3_[_loc5_] = param2;
            }
            else
            {
               _loc3_[_loc4_] = param2;
            }
         }
         else
         {
            this._root = param2;
         }
      }
      
      public function has(param1:*) : Boolean
      {
         var _loc2_:SortedNode = this.firstEqualNode(param1);
         if(!_loc2_)
         {
            return false;
         }
         if(_loc2_.item === param1)
         {
            return true;
         }
         _loc2_ = this.as3commons_collections::nextNode_internal(_loc2_);
         while(_loc2_)
         {
            if(this._comparator.compare(param1,_loc2_.item))
            {
               break;
            }
            if(_loc2_.item === param1)
            {
               return true;
            }
            _loc2_ = this.as3commons_collections::nextNode_internal(_loc2_);
         }
         return false;
      }
      
      as3commons_collections function previousNode_internal(param1:SortedNode) : SortedNode
      {
         var _loc2_:SortedNode = null;
         if(param1.left)
         {
            param1 = this.as3commons_collections::mostRightNode_internal(param1.left);
         }
         else
         {
            _loc2_ = param1.parent;
            while(Boolean(_loc2_) && param1 == _loc2_.left)
            {
               param1 = _loc2_;
               _loc2_ = _loc2_.parent;
            }
            param1 = _loc2_;
         }
         return param1;
      }
      
      public function toArray() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:SortedNode = this.as3commons_collections::mostLeftNode_internal();
         while(_loc2_)
         {
            _loc1_.push(_loc2_.item);
            _loc2_ = this.as3commons_collections::nextNode_internal(_loc2_);
         }
         return _loc1_;
      }
      
      protected function removeNode(param1:SortedNode) : void
      {
         var _loc2_:SortedNode = null;
         while(Boolean(param1.left) || Boolean(param1.right))
         {
            if(Boolean(param1.left) && Boolean(param1.right))
            {
               _loc2_ = param1.left.priority < param1.right.priority ? param1.left : param1.right;
            }
            else if(param1.left)
            {
               _loc2_ = param1.left;
            }
            else
            {
               if(!param1.right)
               {
                  break;
               }
               _loc2_ = param1.right;
            }
            this.rotate(param1,_loc2_);
         }
         if(param1.parent)
         {
            if(param1.parent.left == param1)
            {
               param1.parent.left = null;
            }
            else
            {
               param1.parent.right = null;
            }
            param1.parent = null;
         }
         else
         {
            this._root = null;
         }
         --this._size;
      }
      
      as3commons_collections function nextNode_internal(param1:SortedNode) : SortedNode
      {
         var _loc2_:SortedNode = null;
         if(param1.right)
         {
            param1 = this.as3commons_collections::mostLeftNode_internal(param1.right);
         }
         else
         {
            _loc2_ = param1.parent;
            while(Boolean(_loc2_) && param1 == _loc2_.right)
            {
               param1 = _loc2_;
               _loc2_ = _loc2_.parent;
            }
            param1 = _loc2_;
         }
         return param1;
      }
      
      protected function lesserNode(param1:*) : SortedNode
      {
         var _loc3_:SortedNode = null;
         var _loc4_:int = 0;
         var _loc2_:SortedNode = this._root;
         while(_loc2_)
         {
            _loc4_ = this._comparator.compare(param1,_loc2_.item);
            if(_loc4_ == -1)
            {
               _loc2_ = _loc2_.left;
            }
            else if(_loc4_ == 1)
            {
               _loc3_ = _loc2_;
               _loc2_ = _loc2_.right;
            }
            else
            {
               _loc2_ = _loc2_.left;
            }
         }
         return _loc3_;
      }
      
      public function iterator(param1:* = undefined) : IIterator
      {
         return null;
      }
      
      protected function higherNode(param1:*) : SortedNode
      {
         var _loc3_:SortedNode = null;
         var _loc4_:int = 0;
         var _loc2_:SortedNode = this._root;
         while(_loc2_)
         {
            _loc4_ = this._comparator.compare(param1,_loc2_.item);
            if(_loc4_ == -1)
            {
               _loc3_ = _loc2_;
               _loc2_ = _loc2_.left;
            }
            else if(_loc4_ == 1)
            {
               _loc2_ = _loc2_.right;
            }
            else
            {
               _loc2_ = _loc2_.right;
            }
         }
         return _loc3_;
      }
      
      as3commons_collections function removeNode_internal(param1:SortedNode) : void
      {
         this.removeNode(param1);
      }
      
      public function get first() : *
      {
         if(!this._root)
         {
            return undefined;
         }
         return this.as3commons_collections::mostLeftNode_internal().item;
      }
   }
}

