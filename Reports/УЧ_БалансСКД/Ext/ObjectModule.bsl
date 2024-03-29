﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
		
	СКД = ЭтотОбъект.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");	
	Источник = Новый ИсточникДоступныхНастроекКомпоновкиДанных(СКД);
	
	КомпоновщикНастроек2 = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек2.Инициализировать(Источник);
	КомпоновщикНастроек2.ЗагрузитьНастройки(КомпоновщикНастроек.Настройки);
	КомпоновщикНастроек2.ЗагрузитьПользовательскиеНастройки(КомпоновщикНастроек.ПользовательскиеНастройки);
	
	НастройкиДляКомпоновкиМакета = КомпоновщикНастроек2.ПолучитьНастройки();
	ДатаКон = ТекущаяДата();
	ДатаНач = ТекущаяДата();
	
	Для Каждого ТекЭлемент Из НастройкиДляКомпоновкиМакета.ПараметрыДанных.Элементы Цикл
		
		Если Строка(ТекЭлемент.Параметр) = "ВыбПериод" Тогда
			ДатаКон = ТекЭлемент.Значение.ДатаОкончания;
			ДатаНач = ТекЭлемент.Значение.ДатаНачала;
		КонецЕсли;
		
		Если Строка(ТекЭлемент.Параметр) = "ЭквивалентнаяВалюта" Тогда
			СтандартныеОтчетыКлиентСервер.УстановитьПараметр(НастройкиДляКомпоновкиМакета, "ЭквивалентнаяВалюта", ?(ЗначениеЗаполнено(ТекЭлемент.Значение) И ТекЭлемент.Использование, ТекЭлемент.Значение, УЧ_Сервер.НациональнаяВалюта()));
		КонецЕсли;
		
		Если Строка(ТекЭлемент.Параметр) = "ДатаКурса" Тогда
			СтандартныеОтчетыКлиентСервер.УстановитьПараметр(НастройкиДляКомпоновкиМакета, "ДатаКурса", ДатаКон);
		КонецЕсли;	
		
		//Если Строка(ТекЭлемент.Параметр) = "РазвернутыеСчета" Тогда
		//	КолвоСчетов = ТекЭлемент.Значение.Количество();
		//	
		//	Для ОбрИнд = 1 По ТекЭлемент.Значение.Количество() Цикл
		//		
		//		Если Не ЗначениеЗаполнено(ТекЭлемент.Значение[КолвоСчетов - ОбрИнд]) Тогда
		//			ТекЭлемент.Значение.Удалить(КолвоСчетов - ОбрИнд);
		//		КонецЕсли;
		//		
		//	КонецЦикла;
		//	
		//	СтандартныеОтчетыКлиентСервер.УстановитьПараметр(НастройкиДляКомпоновкиМакета, "РазвернутыеСчета",);
		//КонецЕсли;	
		
	КонецЦикла;
			
КонецПроцедуры
