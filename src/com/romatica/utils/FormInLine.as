﻿/**
{
	import flash.errors.IllegalOperationError;
	
	public class FormInLine
	{
		public static var _TD : int;
		// X
		// Y
		{

		// ////////////////////////////////////////////////////////////////////////////////////////////////////
		public static function getPoint(ww : Number, hh : Number, ID : int, xpcs : int, ypcs : int):Point
		{
			_TD = Math.floor(ID / xpcs);
			_TR = (ID - (_TD * xpcs));
			return new Point(_TR * ww, _TD * hh);
		}
	}
}