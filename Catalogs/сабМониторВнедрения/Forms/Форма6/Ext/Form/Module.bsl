﻿
&НаКлиенте
Процедура Автонастройка(Команда)
	Объект.Выполнено = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьАвтомаршруты(Команда)
	ОткрытьФорму("РегистрСведений.сабОбработкаДокументов.ФормаСписка",,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//ДатаВводаОстатков = Константы.УЧ_ДатаВводаОстатков.Получить();
КонецПроцедуры


&НаКлиенте
Процедура ОткрытьЖурналУправленческихДокументов(Команда)
	ОткрытьФорму("ЖурналДокументов.УЧ_Полный.ФормаСписка",,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры


&НаКлиенте
Процедура ОткрытьЖурналДокументооборота(Команда)
	ОткрытьФорму("ЖурналДокументов.ВнутренниеДокументы.ФормаСписка",,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры


&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если Не Объект.Выполнено Тогда
		Возврат;	
	КонецЕсли;
	//УстановитьПривилегированныйРежим(Истина);
	//Запрос = Новый Запрос;
	//Запрос.Текст = "ВЫБРАТЬ
	//|	Задача.Ссылка КАК Ссылка
	//|ИЗ
	//|	Справочник.Задача КАК Задача
	//|ГДЕ
	//|	Задача.Наименование = &Наименование";
	//
	//Запрос.УстановитьПараметр("Наименование", "Настроить ""модуль.Управленка""");
	//
	//Результат = Запрос.Выполнить();
	//Выборка = Результат.Выбрать();
	//
	//Пока Выборка.Следующий() Цикл
	//	НоваяЗадача = Выборка.Ссылка.ПолучитьОбъект();
	//	НоваяЗадача.Выполнена = Истина;
	//	НоваяЗадача.Записать();
	//КонецЦикла;
	//УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ОбновитьСписокЗадач");
	Оповестить("ОбновитьСтатусыНастроек", Новый Структура("Ссылка, Наименование, Выполнено", Объект.Ссылка, Объект.Наименование, Объект.Выполнено));
КонецПроцедуры

&НаКлиенте
Процедура РасширенныеНастройкиДоступа(Команда)
	ОткрытьФорму("Справочник.сабМониторВнедрения.Форма.Форма8");
КонецПроцедуры

