//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.core.matchers
{
	import flash.errors.IllegalOperationError;
	
	import org.hamcrest.Description;
	import org.hamcrest.StringDescription;

	public class TypeMatcher implements ITypeMatcher
	{

		protected const _allOfTypes:Vector.<Class> = new Vector.<Class>;

		protected const _anyOfTypes:Vector.<Class> = new Vector.<Class>;

		protected const _noneOfTypes:Vector.<Class> = new Vector.<Class>;

		protected var _typeFilter:ITypeFilter;

		public function TypeMatcher()
		{
		}

		public function allOf(... types):TypeMatcher
		{
			pushAddedTypesTo(types, _allOfTypes);
			return this;
		}

		public function anyOf(... types):TypeMatcher
		{
			pushAddedTypesTo(types, _anyOfTypes);
			return this;
		}

		public function createTypeFilter():ITypeFilter
		{
			// calling this seals the matcher
			return _typeFilter ||= buildTypeFilter();
		}

		public function noneOf(... types):TypeMatcher
		{
			pushAddedTypesTo(types, _noneOfTypes);
			return this;
		}

		public function lock():void
		{
			createTypeFilter();
		}
		
		public function describeTo(description:Description):void
		{
			description.appendText(createTypeFilter().descriptor);
		}
		
		public function matches(item:Object):Boolean
		{
			return createTypeFilter().matches(item);
		}
		
		public function describeMismatch(item:Object, mismatchDescription:Description):void
		{
			mismatchDescription.appendText("was ").appendValue(item);
		}
		
		public function toString():String
		{
			return StringDescription.toString(this);
		}

		private function buildTypeFilter():ITypeFilter
		{
			if ((_allOfTypes.length == 0) &&
				(_anyOfTypes.length == 0) &&
				(_noneOfTypes.length == 0))
			{
				throw new TypeMatcherError(TypeMatcherError.EMPTY_MATCHER);
			}
			return new TypeFilter(_allOfTypes, _anyOfTypes, _noneOfTypes);
		}

		private function pushAddedTypesTo(types:Array, targetSet:Vector.<Class>):void
		{
			_typeFilter && throwSealedMatcherError();

			pushValuesToClassVector(types, targetSet);
		}

		private function throwSealedMatcherError():void
		{
			throw new IllegalOperationError('This TypeMatcher has been sealed and can no longer be configured');
		}
	}
}
