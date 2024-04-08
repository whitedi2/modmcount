﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БюджетныйНаСервере.ДействияПриСозданииФормыСправочника(ЭтаФорма, Параметры);
	
	СписокВладельцев.Параметры.УстановитьЗначениеПараметра("ДоступныеПредприятия", ПараметрыСеанса.ДоступныеПредприятия);
	
	ПользовательскийОтбор = Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(Список.КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки);
	ПользовательскийОтбор.Элементы.Очистить();
	
	ЕстьВладелец = Параметры.Отбор.Свойство("Предприятие");
	ТекВладелец = Неопределено;
	Если ЕстьВладелец Тогда
		ТекВладелец = Параметры.Отбор["Предприятие"];
		Элементы.СписокВладельцев.Видимость = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекВладелец) Тогда
		
		
		Если ТипЗнч(ТекВладелец) = Тип("СправочникСсылка.Предприятия") Тогда
			СписокВладельцев.ТекстЗапроса = "ВЫБРАТЬ
			|	СправочникПредприятия.Ссылка,
			|	СправочникПредприятия.Наименование,
			|	ТИПЗНАЧЕНИЯ(СправочникПредприятия.Ссылка) КАК Тип,
			|	""Предприятия"" КАК Тип2,
			|	0 КАК Картинка
			|ИЗ
			|	Справочник.Предприятия КАК СправочникПредприятия";
			СписокВладельцев.ОсновнаяТаблица = "Справочник.Предприятия";
		ИначеЕсли ТипЗнч(ТекВладелец) = Тип("СправочникСсылка.Организации") Тогда
			СписокВладельцев.ТекстЗапроса = "ВЫБРАТЬ
			|	Организации.Ссылка,
			|	Организации.Наименование,
			|	ТИПЗНАЧЕНИЯ(Организации.Ссылка) КАК Тип,
			|	""Предприятия"" КАК Тип2,
			|	0 КАК Картинка
			|ИЗ
			|	Справочник.Организации КАК Организации";
			СписокВладельцев.ОсновнаяТаблица = "Справочник.Организации";
		КонецЕсли;
		
		Элементы.СписокВладельцев.ТекущаяСтрока = ТекВладелец;
		
	КонецЕсли;	
	
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	
	Если Элементы.Список.РежимВыбора И ЗначениеЗаполнено(Параметры.ТекущаяСтрока) Тогда
		Элементы.СписокВладельцев.ТекущаяСтрока = Параметры.ТекущаяСтрока.Предприятие;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекВладелец) Тогда
		
		Список.Отбор.Элементы.Очистить();
		
		НовыйОтбор = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Предприятие");
		НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
		НовыйОтбор.ПравоеЗначение = ТекВладелец;
		
	КонецЕсли;
	
	Параметры.Отбор.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВладельцевПриАктивизацииСтроки(Элемент)
	
	Список.Отбор.Элементы.Очистить();
	
	Если ЗначениеЗаполнено(Элементы.СписокВладельцев.ТекущаяСтрока) Тогда
		ПравоеЗначенин = Элементы.СписокВладельцев.ДанныеСтроки(Элементы.СписокВладельцев.ТекущаяСтрока).Ссылка;
	Иначе
		ПравоеЗначенин = Неопределено;
	КонецЕсли;
	
	НовыйОтбор = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Предприятие");
	НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
	НовыйОтбор.ПравоеЗначение = ПравоеЗначенин;
	
	Если АвтоРаскрытиеВсехУровней Тогда
		ПодрузделенияОтбора = ПолучитьСписокПодразделений();
		Для каждого ТекСтрока Из ПодрузделенияОтбора Цикл
			Элементы.Список.Развернуть(ТекСтрока, Истина);
		КонецЦикла; 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если НЕ Копирование И Элементы.СписокВладельцев.Видимость Тогда
		Если Элементы.СписокВладельцев.ТекущиеДанные = Неопределено Тогда
			Отказ = Истина;
			ОткрытьФорму("Справочник.Предприятия.ФормаОбъекта",,,,,,Новый ОписаниеОповещения("ВыполнитьПослеОкончания", ЭтотОбъект, Новый Структура),РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Иначе
			Отказ = Истина;
			ТекФорма = ?(Группа, ПолучитьФорму("Справочник.СтруктураПредприятия.ФормаГруппы"), ПолучитьФорму("Справочник.СтруктураПредприятия.ФормаОбъекта"));
			ТекФорма.Объект.Предприятие= Элементы.СписокВладельцев.ДанныеСтроки(Элементы.СписокВладельцев.ТекущаяСтрока).Ссылка;
			ТекФорма.Открыть();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПользовательскийОтбор = Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(Список.КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки);
	ПользовательскийОтбор.Элементы.Очистить();
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокПодразделений()
	
	Схема = Элементы.Список.ПолучитьИсполняемуюСхемуКомпоновкиДанных();	
	Настройки = Элементы.Список.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	НовыйЭлемент = Настройки.Структура[0].Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	НовыйЭлемент.Поле = Новый ПолеКомпоновкиДанных("Ссылка");
	
	//Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ПП", БюджетныйНаСервере.ПолучитьПредприятия());
	//Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ДоступныеДокументы", ДоступныеДокументыСписок.ВыгрузитьЗначения());
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	МассивЭлементов = Новый Массив;
	Для каждого ТекСтрока Из Результат Цикл
		МассивЭлементов.Добавить(ТекСтрока.Ссылка);	
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	СтруктураПредприятия.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ Родители
	|ИЗ
	|	Справочник.СтруктураПредприятия КАК СтруктураПредприятия
	|ГДЕ
	|	СтруктураПредприятия.Ссылка В(&Ссылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Родители.Ссылка КАК Ссылка
	|ИЗ
	|	Родители КАК Родители
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СтруктураПредприятия КАК СтруктураПредприятия
	|		ПО Родители.Ссылка = СтруктураПредприятия.Родитель
	|
	|СГРУППИРОВАТЬ ПО
	|	Родители.Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", МассивЭлементов);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	МассивЭлементов = Новый Массив;
	Пока Выборка.Следующий() Цикл
		МассивЭлементов.Добавить(Выборка.Ссылка);	
	КонецЦикла;
	
	
	Возврат МассивЭлементов;


КонецФункции // ()

&НаКлиенте
Процедура СоздатьПредприятие(Команда)
	ОткрытьФорму("Справочник.Предприятия.ФормаОбъекта",,,,,,Новый ОписаниеОповещения("ВыполнитьПослеОкончания", ЭтотОбъект, Новый Структура),РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПослеОкончания(Результат, Параметры) Экспорт
	СписокВладельцев.Параметры.УстановитьЗначениеПараметра("ДоступныеПредприятия", БюджетныйНаСервере.ПолучитьПредприятия());
	//Элементы.СписокВладельцев.Обновить();
	//Элементы.Список.Обновить();
КонецПроцедуры

