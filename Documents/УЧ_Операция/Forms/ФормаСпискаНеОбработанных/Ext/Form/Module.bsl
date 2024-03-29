﻿
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьФормуУч_Операция" Тогда
		Элементы.Список.Обновить();
	ИначеЕсли ИмяСобытия = "ОбновитьФормуУч_Операция_Изменения" Тогда  
		Элементы.СписокИзмененных.Обновить();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьЗначение(Элементы.Список.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокИзмененных.Параметры.УстановитьЗначениеПараметра("Период", ТекущаяДата());
	
КонецПроцедуры

&НаКлиенте
Процедура СписокИзмененныхВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекДок = Элементы.СписокИзмененных.ТекущиеДанные.Документ;
	
	ОткрытьФорму("Документ.УЧ_Операция.Форма.БухгалтерскаяСправка", Новый Структура("Ключ, ПоказатьИзменения", ТекДок, Истина));
	
КонецПроцедуры
