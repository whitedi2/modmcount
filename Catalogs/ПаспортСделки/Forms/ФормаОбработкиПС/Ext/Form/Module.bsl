﻿
&НаКлиенте
Процедура ПлатежкиБезПС(Команда)
	
	Элементы.СписокПлатежкиПлатежкиБезПС.Пометка = 1 - Элементы.СписокПлатежкиПлатежкиБезПС.Пометка;
	ОбновитьСписок(Элементы.СписокПлатежкиПлатежкиБезПС.Пометка);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписок(Признак)
	
	Если Признак Тогда
		НовыйОтбор = СписокПлатежки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		НовыйОтбор.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("ПаспортСделки");
		НовыйОтбор.ВидСравнения 	= ВидСравненияКомпоновкиДанных.Равно;
		НовыйОтбор.ПравоеЗначение 	= Справочники.ПаспортСделки.ПустаяСсылка();
		НовыйОтбор.Использование  	= Истина;
	Иначе
		Для Каждого ТекСтрокаОтбора Из СписокПлатежки.Отбор.Элементы Цикл
			Если ТекСтрокаОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПаспортСделки") Тогда
				СписокПлатежки.Отбор.Элементы.Удалить(ТекСтрокаОтбора);
			КонецЕсли;
		КонецЦикла;		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ДоговораБезПС(Команда)
	
	Элементы.СписокДоговораДоговораБезПС.Пометка = 1 - Элементы.СписокДоговораДоговораБезПС.Пометка;
	ОбновитьСписокДоговора(Элементы.СписокДоговораДоговораБезПС.Пометка);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокДоговора(Признак)
	
	Если Признак Тогда
		НовыйОтбор = СписокДоговора.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		НовыйОтбор.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("ПаспортСделки");
		НовыйОтбор.ВидСравнения 	= ВидСравненияКомпоновкиДанных.Равно;
		НовыйОтбор.ПравоеЗначение 	= Справочники.ПаспортСделки.ПустаяСсылка();
		НовыйОтбор.Использование  	= Истина;
	Иначе
		Для Каждого ТекСтрокаОтбора Из СписокДоговора.Отбор.Элементы Цикл
			Если ТекСтрокаОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПаспортСделки") Тогда
				СписокДоговора.Отбор.Элементы.Удалить(ТекСтрокаОтбора);
			КонецЕсли;
		КонецЦикла;		
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//Если РольДоступна("РасчетныйОтдел") Тогда
	//	НовыйОтбор = СписокПлатежки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	//	НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("МестныйПлатеж");
	//	НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	//	НовыйОтбор.ПравоеЗначение = Ложь;
	//КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДокументПлатежноеПоручение.Ссылка) КАК Количество
	               |ИЗ
	               |	Документ.ПлатежноеПоручение КАК ДокументПлатежноеПоручение
	               |ГДЕ
	               |	НЕ ДокументПлатежноеПоручение.ПометкаУдаления
	               |	И ДокументПлатежноеПоручение.ИспользоватьПаспортСделки
	               |	И (ДокументПлатежноеПоручение.Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
	               |			ИЛИ ДокументПлатежноеПоручение.Договор.ПаспортСделки = ЗНАЧЕНИЕ(Справочник.ПаспортСделки.ПустаяСсылка))";
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		Элементы.Платежки.Заголовок = "Платежки (" + Строка(Выборка.Количество) + ")";
	Иначе
		Элементы.Платежки.Заголовок = "Платежки";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	КОЛИЧЕСТВО(ДоговорыКонтрагентов.Ссылка) КАК Количество
	               |ИЗ
	               |	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	               |ГДЕ
	               |	ДоговорыКонтрагентов.ПаспортСделки = ЗНАЧЕНИЕ(Справочник.ПаспортСделки.ПустаяСсылка)
	               |	И ДоговорыКонтрагентов.ИспользоватьПС
	               |	И НЕ ДоговорыКонтрагентов.ПометкаУдаления";
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		Элементы.Договора.Заголовок = "Договора (" + Строка(Выборка.Количество) + ")";
	Иначе
		Элементы.Договора.Заголовок = "Договора";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	КОЛИЧЕСТВО(Д_ЗаявкаНаОтгрузку.Ссылка) КАК Количество
	               |ИЗ
	               |	Документ.Д_ЗаявкаНаОтгрузку КАК Д_ЗаявкаНаОтгрузку
	               |ГДЕ
	               |	(Д_ЗаявкаНаОтгрузку.Договор = Значение(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) ИЛИ Д_ЗаявкаНаОтгрузку.Договор.ПаспортСделки = ЗНАЧЕНИЕ(Справочник.ПаспортСделки.ПустаяСсылка))
	               |	И НЕ Д_ЗаявкаНаОтгрузку.Договор.ПометкаУдаления
	               |	И Д_ЗаявкаНаОтгрузку.ИспользоватьПС";
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		Элементы.ЗаявкиНаОтгрузку.Заголовок = "Заявки на отгрузку (" + Строка(Выборка.Количество) + ")";
	Иначе
		Элементы.ЗаявкиНаОтгрузку.Заголовок = "Заявки на отгрузку";
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ЗаявкиБезПС(Команда)
	
	Элементы.СписокЗаявкиНаОтгрузкуЗаявкиБезПС.Пометка = 1 - Элементы.СписокЗаявкиНаОтгрузкуЗаявкиБезПС.Пометка;
	ОбновитьСписокЗаявки(Элементы.СписокЗаявкиНаОтгрузкуЗаявкиБезПС.Пометка);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокЗаявки(Признак)
	
	Если Признак Тогда
		НовыйОтбор = СписокЗаявкиНаОтгрузку.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		НовыйОтбор.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("ДоговорПаспортСделки");
		НовыйОтбор.ВидСравнения 	= ВидСравненияКомпоновкиДанных.Равно;
		НовыйОтбор.ПравоеЗначение 	= Справочники.ПаспортСделки.ПустаяСсылка();
		НовыйОтбор.Использование  	= Истина;
	Иначе
		Для Каждого ТекСтрокаОтбора Из СписокЗаявкиНаОтгрузку.Отбор.Элементы Цикл
			Если ТекСтрокаОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДоговорПаспортСделки") Тогда
				СписокЗаявкиНаОтгрузку.Отбор.Элементы.Удалить(ТекСтрокаОтбора);
			КонецЕсли;
		КонецЦикла;		
	КонецЕсли;
		
КонецПроцедуры

