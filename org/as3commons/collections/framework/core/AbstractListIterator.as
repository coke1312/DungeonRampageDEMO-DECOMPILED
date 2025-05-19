package org.as3commons.collections.framework.core
{
   import org.as3commons.collections.framework.IListIterator;
   import org.as3commons.collections.iterators.ArrayIterator;
   
   use namespace as3commons_collections;
   
   public class AbstractListIterator extends ArrayIterator implements IListIterator
   {
      
      protected var _list:AbstractList;
      
      public function AbstractListIterator(param1:AbstractList, param2:uint = 0)
      {
         this._list = param1;
         super(this._list.as3commons_collections::array_internal,param2);
      }
      
      override protected function removeCurrent() : void
      {
         this._list.removeAt(_current);
      }
   }
}

