﻿
&НаСервере
Процедура УУ_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	Если Параметры.ИзменениеПоступленияНаРасчетныйСчет тогда 
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ЭлементОтбора.ПравоеЗначение = Параметры.СписокДоговоров; 
	КонецЕсли;
	
КонецПроцедуры
