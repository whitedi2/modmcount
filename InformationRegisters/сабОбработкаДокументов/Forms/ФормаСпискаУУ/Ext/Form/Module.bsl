﻿&НаСервере
Перем МассивИсклТипов;

&НаСервереБезКонтекста
Процедура ОбработатьДокументыУУНаСервере(ТекДокументСтруктура, СтруктураВозврата = Неопределено)
	
	РегистрыСведений.сабОбработкаДокументов.ОбработатьДокументыУУНаСервере(ТекДокументСтруктура, СтруктураВозврата);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьНеобработанныеДокументы()
	
	МассивИсклТипов = МассивИсклТипов();
	
	Схема = Элементы.СписокНеобработанных.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	
	Настройки = Элементы.СписокНеобработанных.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Дата", ДатаВводаОстатков);
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("МассивИсклТипов", МассивИсклТипов);
	
	Выбор = Настройки.Структура[0].Выбор;
	Для Каждого поле из выбор.ДоступныеПоляВыбора.Элементы Цикл
		Если поле.Заголовок = "Системные поля" ИЛИ поле.Заголовок = "Параметры" Тогда
			Продолжить;
		КонецЕсли;
		поле1 = Неопределено;
		фл = Ложь;
		Для Каждого поле1 из выбор.Элементы Цикл
			Если поле1.поле = поле.поле Тогда
				фл = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если Не фл Тогда
			поле1 = выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
			ЗаполнитьЗначенияСвойств(поле1, поле);
			поле1.Заголовок = "";
		КонецЕсли;
	КонецЦикла;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	СтруктураДоков = Новый Массив;
	Для каждого ТекСДок Из Результат Цикл
		СтруктураДоков.Добавить(Новый Структура("Ссылка", ТекСДок.Ссылка));
	КонецЦикла;
	
	Возврат СтруктураДоков;

КонецФункции // ()

&НаКлиенте
Процедура ОбработатьДокументыУУ(Команда)
	
	Если Команда.Имя = "ОбработатьВыделенныеДокументыУУ" Тогда
		ДокументыКОбработке = Новый Массив;
		Для каждого ТекСтрока Из Элементы.СписокНеобработанных.ВыделенныеСтроки Цикл
			//ДокументыКОбработке.Добавить(Новый Структура("Ссылка", ТекСтрока));
			ДокументыКОбработке.Добавить(Новый Структура("Ссылка", Элементы.СписокНеобработанных.ДанныеСтроки(ТекСтрока).Ссылка));
		КонецЦикла; 
	Иначе	
		ДокументыКОбработке = ПолучитьНеобработанныеДокументы();
	КонецЕсли;
	
	счСтроки = 0;
	ВремяНачала = ТекущаяДата();
	ЧислоСтрок  = ДокументыКОбработке.Количество();
	
	Для каждого ТекОбр Из ДокументыКОбработке Цикл
		счСтроки = счСтроки + 1;
		СкоростьЗагрузки = ?(ТекущаяДата() - ВремяНачала = 0, 0, Окр(счСтроки / (ТекущаяДата() - ВремяНачала), 2));
		ОсталосьВремени = Окр((ТекущаяДата() - ВремяНачала) / счСтроки * (ЧислоСтрок - счСтроки) / 60, 2);
		
		Если счСтроки / 100 = Окр(счСтроки / 100, 0) ИЛИ СкоростьЗагрузки < 20 ИЛИ ЧислоСтрок < 100 Тогда
			Состояние("Обработка..." + " Осталось " + Строка(ОсталосьВремени) + " мин." + " Скорость " + Строка(СкоростьЗагрузки) + " стр/сек",
			счСтроки / ЧислоСтрок * 100, "" +  Строка(ТекОбр.Ссылка) +
			" (" + Строка(счСтроки) + "/" + Строка(ЧислоСтрок) + ")" );
		КонецЕсли;
		ОбработкаПрерыванияПользователя();
		
		Попытка
			ОбработатьДокументыУУНаСервере(ТекОбр);	
		Исключение
			Сообщить(ОписаниеОшибки());
			Если Не НеПрерыватьПриОшибкеОбработки Тогда
				Прервать;	
			КонецЕсли;
		КонецПопытки;
		
	КонецЦикла;
	
	Элементы.СписокНеобработанных.Обновить();
	
	РасчитатьЗаголовки();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбрабатыватьНепроведенныеУУДокументы = справочники.сабМониторВнедрения.ПолучитьЗначениеНастройки("ОбрабатыватьНепроведенныеУУДокументы");
	
	ДатаВводаОстатков = Дата('00010101');
	ТекСтрока = Справочники.сабМониторВнедрения.НайтиПоНаименованию("Дата остатков", Истина);
	Если ЗначениеЗаполнено(ТекСтрока) Тогда
		ДатаВводаОстатков = ТекСтрока.Значение;
	КонецЕсли;
	
	СписокИзмененные.ТекстЗапроса = СтрЗаменить(СписокИзмененные.ТекстЗапроса, "ВЫБРАТЬ", "ВЫБРАТЬ РАЗРЕШЕННЫЕ");
	//СписокИзмененные.Параметры.УстановитьЗначениеПараметра("Дата", ДатаВводаОстатков);
	
	СписокНеобработанных.ТекстЗапроса = РегистрыСведений.сабОбработкаДокументов.ТекстЗапросаНеобработанныхУУ(Неопределено);
	
	СписокНеобработанных.Параметры.УстановитьЗначениеПараметра("Дата", ДатаВводаОстатков);
	
	МассивИсклТипов = МассивИсклТипов();
	
	СписокНеобработанных.Параметры.УстановитьЗначениеПараметра("МассивИсклТипов", МассивИсклТипов.МассивИсклТипов);
	СписокНеобработанных.Параметры.УстановитьЗначениеПараметра("МассивВклВидовОпераций", МассивИсклТипов.МассивВклВидовОпераций);
	
	Если ОбрабатыватьНепроведенныеУУДокументы Тогда
		СписокНеобработанных.ТекстЗапроса = СтрЗаменить(СписокНеобработанных.ТекстЗапроса, ".Проведен = ИСТИНА", ".ПометкаУдаления = ЛОЖЬ");
		СписокНеобработанных.ТекстЗапроса = СтрЗаменить(СписокНеобработанных.ТекстЗапроса, ".Проведен = Истина", ".ПометкаУдаления = ЛОЖЬ");
		СписокНеобработанных.ТекстЗапроса = СтрЗаменить(СписокНеобработанных.ТекстЗапроса, "И НЕ Учетный.Регистратор ЕСТЬ NULL", "");
		СписокИзмененные.ТекстЗапроса = СтрЗаменить(СписокИзмененные.ТекстЗапроса, ".Проведен = ИСТИНА", ".ПометкаУдаления = ЛОЖЬ");
	КонецЕсли;
	
	РасчитатьЗаголовки();
	
КонецПроцедуры

&НаСервере
Функция МассивИсклТипов()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	сабСоответствиеТиповДокументов.ТипДокументаУУ КАК ТипДокументаУУ,
	               |	сабСоответствиеТиповДокументов.ТипДокументаБУ КАК ТипДокументаБУ,
	               |	сабСоответствиеТиповДокументов.ВидОперацииБУ КАК ВидОперацииБУ
	               |ИЗ
	               |	РегистрСведений.сабСоответствиеТиповДокументов КАК сабСоответствиеТиповДокументов
	               |ГДЕ
	               |	(сабСоответствиеТиповДокументов.НаправлениеОбмена = ""Нет"" ИЛИ сабСоответствиеТиповДокументов.НаправлениеОбмена = """" ИЛИ сабСоответствиеТиповДокументов.НаправлениеОбмена = ""Любое""
	               |			ИЛИ сабСоответствиеТиповДокументов.НаправлениеОбмена = ""Только УУ-БУ"")";
	
	//Запрос.УстановитьПараметр("ТипДокументаУУ", "Исключено");
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выгрузить();
	
	МассивИсклТипов = Новый Массив;
	МассивВклВидовОпераций = Новый Массив;
	МассивИсклВидовОпераций = Новый Массив;
	Для каждого ТекСтрока Из Выборка Цикл
		Если ТекСтрока.ТипДокументаУУ = "Исключено" Тогда
			МассивИсклТипов.Добавить(Тип("ДокументСсылка." + Строка(ТекСтрока.ТипДокументаБУ)));
			Если ЗначениеЗаполнено(ТекСтрока.ВидОперацииБУ) Тогда
				МассивИсклВидовОпераций.Добавить(ТекСтрока.ВидОперацииБУ);
			КонецЕсли;
		ИначеЕсли ЗначениеЗаполнено(ТекСтрока.ВидОперацииБУ) Тогда
			МассивВклВидовОпераций.Добавить(ТекСтрока.ВидОперацииБУ);
		ИначеЕсли ТекСтрока.ТипДокументаБУ = "ПоступлениеТоваровУслуг" Тогда
			Для каждого ТекВид Из Перечисления.ВидыОперацийПоступлениеТоваровУслуг Цикл
				МассивВклВидовОпераций.Добавить(ТекВид);
			КонецЦикла;
		ИначеЕсли ТекСтрока.ТипДокументаБУ = "РеализацияТоваровУслуг" Тогда
			Для каждого ТекВид Из Перечисления.ВидыОперацийРеализацияТоваров Цикл
				МассивВклВидовОпераций.Добавить(ТекВид);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ТекИсклВид Из МассивИсклВидовОпераций Цикл
		Если Не МассивВклВидовОпераций.Найти(ТекИсклВид) = Неопределено Тогда
			МассивВклВидовОпераций.Удалить(МассивВклВидовОпераций.Найти(ТекИсклВид));
		КонецЕсли;
	КонецЦикла;
	
    Возврат Новый Структура("МассивИсклТипов, МассивВклВидовОпераций", МассивИсклТипов, МассивВклВидовОпераций);

КонецФункции // ()

&НаКлиенте
Процедура СоздатьНаОсновании(Команда)
	
	Если Элементы.Группа1.ТекущаяСтраница = Элементы.Необработанные Тогда
		ДокументыКОбработке = Новый Массив;
		Для каждого ТекСтрока Из Элементы.СписокНеобработанных.ВыделенныеСтроки Цикл
			//ДокументыКОбработке.Добавить(Новый Структура("Ссылка", ТекСтрока));		
			ДокументыКОбработке.Добавить(Новый Структура("Ссылка", Элементы.СписокНеобработанных.ДанныеСтроки(ТекСтрока).Ссылка));
		КонецЦикла; 
	КонецЕсли;
	
	Для каждого ТекОбр Из ДокументыКОбработке Цикл
		
		УУСсылка = ТекОбр.Ссылка;
		
		СтруктураДанных = Новый Структура;
		ОбработатьДокументыУУНаСервере(ТекОбр, СтруктураДанных);
		Если СтруктураДанных.Свойство("Ссылка") Тогда
			ТекОбр.Ссылка = СтруктураДанных.Ссылка;
		КонецЕсли;
		
		Если НЕ СтруктураДанных.Количество() Тогда
			Прервать;		
		КонецЕсли;
		
		ДопПараметр = Новый Структура("ДокументУУ", УУСсылка); 
		ТекФормаУУ = ПолучитьФорму("Документ." + СтруктураДанных.ИмяФормы +".ФормаОбъекта", Новый Структура("Основание, ДокументУУ, ЗначенияЗаполнения, ВидОперации", ТекОбр.Ссылка, УУСсылка, СтруктураДанных, СтруктураДанных.ВидОперации));
		ТекФормаУУ.РежимОткрытияОкна = РежимОткрытияОкнаФормы.Независимый;
		ДопПараметр.Вставить("ОбъектБУ", ТекФормаУУ);
		Оп = Новый ОписаниеОповещения("ВыполнитьПослеОкончания", ЭтотОбъект, ДопПараметр);
		ТекФормаУУ.ОписаниеОповещенияОЗакрытии = Оп;
		
		//ДобавитьРеквизит();
		
		ТекФормаУУ.Открыть();
		Прервать;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ДобавитьРеквизит()
	//ДобавляемыеРеквизиты	= Новый Массив;
	//Реквизит_ДокументУУ = Новый РеквизитФормы("ДокументУУ",	Документы.ТипВсеСсылки(),	, "Документ УУ");
	//ДобавляемыеРеквизиты.Добавить(Реквизит_ДокументУУ);
	//ТекФормаУУ.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
КонецПроцедуры
	
&НаКлиенте
Процедура ВыполнитьПослеОкончания(Результат, Параметры) Экспорт
	
	//Если ЗначениеЗаполнено(Параметры.ОбъектБУ.Объект.Ссылка) Тогда
	//	Параметры.Вставить("ДокументБУ", Параметры.ОбъектБУ.Объект.Ссылка);
	//	Параметры.ОбъектБУ = Неопределено;
	//	СоздатьЗаписьРегистра(Параметры);
	//	Элементы.СписокНеобработанных.Обновить();
	//	Элементы.СписокИзмененные.Обновить();
	//	РасчитатьЗаголовки();
	//КонецЕсли;

КонецПроцедуры


&НаСервереБезКонтекста
Процедура СоздатьЗаписьРегистра(Параметры)
	
	Если ЗначениеЗаполнено(Параметры.ДокументБУ) Тогда
		НаборЗаписей = РегистрыСведений.сабОбработкаДокументов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ДокументБУ.Установить(Параметры.ДокументБУ);
		НаборЗаписей.Отбор.ДокументУУ.Установить(Параметры.ДокументУУ);
		НаборЗаписей.Прочитать();
		Если НЕ НаборЗаписей.Количество() Тогда
			НаборЗаписей = РегистрыСведений.сабОбработкаДокументов.СоздатьМенеджерЗаписи();
			НаборЗаписей.ДокументБУ = Параметры.ДокументБУ;
			НаборЗаписей.ДокументУУ = Параметры.ДокументУУ;
			НаборЗаписей.Автор = ПараметрыСеанса.ТекущийПользователь;
			НаборЗаписей.ДатаОбработки = ТекущаяДата();
			НаборЗаписей.ПервичныйДокументУУ = Истина;
			
			Если ЗначениеЗаполнено(НаборЗаписей.ДокументБУ) Тогда
				ДокМета = НаборЗаписей.ДокументБУ.Метаданные();
				Если БюджетныйНаСервере.ЕстьСвойствоОбъекта(ДокМета.СтандартныеРеквизиты, "Дата") Тогда
					НаборЗаписей.ДатаБУ = НаборЗаписей.ДокументБУ.Дата;
				КонецЕсли;
				Если БюджетныйНаСервере.ЕстьСвойствоОбъекта(ДокМета.СтандартныеРеквизиты, "Дата") Тогда
					НаборЗаписей.НомерБУ = НаборЗаписей.ДокументБУ.Номер;
				КонецЕсли;
				Если Не ДокМета.Реквизиты.Найти("Организация") = Неопределено Тогда
					НаборЗаписей.ОрганизацияБУ = НаборЗаписей.ДокументБУ.Организация;
				КонецЕсли;
				Если Не ДокМета.Реквизиты.Найти("СуммаДокумента") = Неопределено Тогда
					НаборЗаписей.СуммаДокументаБУ = НаборЗаписей.ДокументБУ.СуммаДокумента;
				КонецЕсли;
				Если Не ДокМета.Реквизиты.Найти("Комментарий") = Неопределено Тогда
					НаборЗаписей.КомментарийБУ = НаборЗаписей.ДокументБУ.Комментарий;
				КонецЕсли;
				НаборЗаписей.ТипДокументаБУ = ТипЗнч(НаборЗаписей.ДокументБУ);
			КонецЕсли;
			Если ЗначениеЗаполнено(НаборЗаписей.ДокументУУ) Тогда
				ДокМета = НаборЗаписей.ДокументУУ.Метаданные();
				Если БюджетныйНаСервере.ЕстьСвойствоОбъекта(ДокМета.СтандартныеРеквизиты, "Дата") Тогда
					НаборЗаписей.ДатаУУ = НаборЗаписей.ДокументУУ.Дата;
				КонецЕсли;
				Если БюджетныйНаСервере.ЕстьСвойствоОбъекта(ДокМета.СтандартныеРеквизиты, "Дата") Тогда
					НаборЗаписей.НомерУУ = НаборЗаписей.ДокументУУ.Номер;
				КонецЕсли;
				Если Не ДокМета.Реквизиты.Найти("Предприятие") = Неопределено Тогда
					НаборЗаписей.ПредприятиеУУ = НаборЗаписей.ДокументУУ.Предприятие;
				КонецЕсли;
				Если Не ДокМета.Реквизиты.Найти("СуммаДокумента") = Неопределено Тогда
					НаборЗаписей.СуммаДокументаУУ = НаборЗаписей.ДокументУУ.СуммаДокумента;
				КонецЕсли;
				НаборЗаписей.ТипДокументаУУ = ТипЗнч(НаборЗаписей.ДокументУУ);
			КонецЕсли;
			
			НаборЗаписей.Записать();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ОповеститьРегистрОбработанныхУУ" Тогда
		
		СоздатьЗаписьРегистра(Параметр);
		
		Элементы.СписокИзмененные.Обновить();

		Элементы.СписокНеобработанных.Обновить();
		
		РасчитатьЗаголовки();
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПропуститьВсеДокументыУУ(Команда)
	Если Команда.Имя = "ПропуститьВыделенныеДокументыУУ" Тогда
		ДокументыКОбработке = Новый Массив;
		Для каждого ТекСтрока Из Элементы.СписокНеобработанных.ВыделенныеСтроки Цикл
			//ДокументыКОбработке.Добавить(Новый Структура("Ссылка", ТекСтрока));
			ДокументыКОбработке.Добавить(Новый Структура("Ссылка", Элементы.СписокНеобработанных.ДанныеСтроки(ТекСтрока).Ссылка));
		КонецЦикла; 
	Иначе	
		ДокументыКОбработке = ПолучитьНеобработанныеДокументы();
	КонецЕсли;
	
	счСтроки = 0;
	ВремяНачала = ТекущаяДата();
	ЧислоСтрок  = ДокументыКОбработке.Количество();
	
	Для каждого ТекОбр Из ДокументыКОбработке Цикл
		счСтроки = счСтроки + 1;
		СкоростьЗагрузки = ?(ТекущаяДата() - ВремяНачала = 0, 0, Окр(счСтроки / (ТекущаяДата() - ВремяНачала), 2));
		ОсталосьВремени = Окр((ТекущаяДата() - ВремяНачала) / счСтроки * (ЧислоСтрок - счСтроки) / 60, 2);
		
		Если счСтроки / 100 = Окр(счСтроки / 100, 0) ИЛИ СкоростьЗагрузки < 20 ИЛИ ЧислоСтрок < 100 Тогда
			Состояние("Обработка..." + " Осталось " + Строка(ОсталосьВремени) + " мин." + " Скорость " + Строка(СкоростьЗагрузки) + " стр/сек",
			счСтроки / ЧислоСтрок * 100, "" +  Строка(ТекОбр.Ссылка) +
			" (" + Строка(счСтроки) + "/" + Строка(ЧислоСтрок) + ")" );
		КонецЕсли;
		ОбработкаПрерыванияПользователя();
		
		Попытка
			ПропуститьДокументыУУНаСервере(ТекОбр);	
		Исключение
			Сообщить(ОписаниеОшибки());
			Прервать;	
		КонецПопытки;
		
	КонецЦикла;
	
	Элементы.СписокНеобработанных.Обновить();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПропуститьДокументыУУНаСервере(ТекДокументСтруктура, СтруктураВозврата = Неопределено)
	
	РегистрыСведений.сабОбработкаДокументов.ПропуститьДокументыУУНаСервере(ТекДокументСтруктура, СтруктураВозврата);
	
КонецПроцедуры

&НаСервере
Процедура РасчитатьЗаголовки()
	
	МассивИсклТипов = МассивИсклТипов();
	
	Схема = Элементы.СписокНеобработанных.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	
	Настройки = Элементы.СписокНеобработанных.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Дата", ДатаВводаОстатков);
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("МассивИсклТипов", МассивИсклТипов.МассивИсклТипов);
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("МассивВклВидовОпераций", МассивИсклТипов.МассивВклВидовОпераций);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
		
	КоличествоНеобработанных = Результат.Количество();
	
	Схема = Элементы.СписокИзмененные.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	
	Настройки = Элементы.СписокИзмененные.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	
	//Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Дата", ДатаВводаОстатков);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	КоличествоИзмененные = Результат.Количество();
	

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПодключитьОбработчикОжидания("РасчитатьЗаголовкиКлиент", 180);
КонецПроцедуры

&НаКлиенте
Процедура РасчитатьЗаголовкиКлиент()
	РасчитатьЗаголовки();
КонецПроцедуры

&НаСервере
Процедура ОбрабатыватьНерповеденныеУУДокументыПриИзмененииНаСервере()
	
	ТекЭл = Справочники.сабМониторВнедрения.НайтиПоНаименованию("ОбрабатыватьНепроведенныеУУДокументы", Истина);
	
	Если ЗначениеЗаполнено(ТекЭл) Тогда
		ТекЭлОб = ТекЭл.ПолучитьОбъект();
	Иначе
		ТекЭлОб = Справочники.сабМониторВнедрения.СоздатьЭлемент();
	КонецЕсли;
	
	ТекЭлОб.Наименование = "ОбрабатыватьНепроведенныеУУДокументы";
	ТекЭлОб.Значение = ОбрабатыватьНепроведенныеУУДокументы;
	ТекЭлОб.Записать();

КонецПроцедуры

&НаКлиенте
Процедура ОбрабатыватьНерповеденныеУУДокументыПриИзменении(Элемент)
	ОбрабатыватьНерповеденныеУУДокументыПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СписокНеобработанныхВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ПоказатьЗначение(,Элемент.ТекущиеДанные.Ссылка); 
КонецПроцедуры

&НаКлиенте
Процедура СписокИзмененныеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле.Имя = "СписокИзмененныеДокументБУ" Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(,Элементы.СписокИзмененные.ТекущиеДанные.ДокументБУ);
	ИначеЕсли Поле.Имя = "СписокИзмененныеДокументУУ" Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(,Элементы.СписокИзмененные.ТекущиеДанные.ДокументУУ);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПринятьИзмененияНаСервере(ТекОбр)
	
	Попытка
		ТекОбъект = ТекОбр.ДокументБУ.ПолучитьОбъект();
		ТекОбъект.Заполнить(ТекОбр.ДокументУУ);
		Если ТекОбъект.Проведен Тогда
			ТекОбъект.Записать(РежимЗаписиДокумента.Проведение);	
		ИначеЕсли ТекОбъект.ПометкаУдаления Тогда
			ТекОбъект.УстановитьПометкуУдаления(Истина);
			ТекОбъект.ПометкаУдаления = Истина;
			ТекОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		Иначе	
			ТекОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		КонецЕсли;
		
		НаборЗаписей = РегистрыСведений.сабОбработкаДокументов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ДокументБУ.Установить(ТекОбр.ДокументБУ);
		НаборЗаписей.Отбор.ДокументУУ.Установить(ТекОбр.ДокументУУ);
		НаборЗаписей.Прочитать();
		Для каждого ТекСТрока Из НаборЗаписей Цикл
			Если ТекСТрока.ПервичныйДокументУУ Тогда
				ТекСТрока.Модифицирован = Ложь;
				ТекСТрока.Автор = ПараметрыСеанса.ТекущийПользователь;
				ТекСТрока.ДатаОбработки = ТекущаяДата();
			КонецЕсли;
		КонецЦикла;
		НаборЗаписей.Записать();
		
	Исключение
		НоваяЗапись = РегистрыСведений.сабДокументОшибкаФоновогоПроведения.СоздатьМенеджерЗаписи();
		НоваяЗапись.ДокументБУ = ТекОбр.ДокументБУ;
		НоваяЗапись.ДатаОбработки = ТекущаяДата();
		НоваяЗапись.Комментарий = ОписаниеОшибки();
		НоваяЗапись.Записать();
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура Проверено(Команда)
	Для каждого Эл Из Элементы.СписокИзмененные.ВыделенныеСтроки Цикл
		ПровереноНаСервере(Эл);		
	КонецЦикла;
	Элементы.СписокИзмененные.Обновить();
	РасчитатьЗаголовки();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПровереноНаСервере(Документ)
	НаборЗаписей = РегистрыСведений.сабОбработкаДокументов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ДокументУУ.Установить(Документ.ДокументУУ);
	НаборЗаписей.Прочитать();
	Для каждого ТекСТрока Из НаборЗаписей Цикл
		Если ТекСТрока.ПервичныйДокументУУ Тогда
			ТекСТрока.Модифицирован = Ложь;
			ТекСТрока.ДатаОбработки = ТекущаяДата();
		КонецЕсли;
	КонецЦикла;
	НаборЗаписей.Записать();
КонецПроцедуры

&НаСервере
Функция ПолучитьИзмененияНаСервере()
	
	Схема = Элементы.СписокИзмененные.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	
	Настройки = Элементы.СписокИзмененные.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	
	//Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Дата", ДатаВводаОстатков);
	
	Выбор = Настройки.Структура[0].Выбор;
	Для Каждого поле из выбор.ДоступныеПоляВыбора.Элементы Цикл
		Если поле.Заголовок = "Системные поля" ИЛИ поле.Заголовок = "Параметры" Тогда
			Продолжить;
		КонецЕсли;
		поле1 = Неопределено;
		фл = Ложь;
		Для Каждого поле1 из выбор.Элементы Цикл
			Если поле1.поле = поле.поле Тогда
				фл = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если Не фл Тогда
			поле1 = выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
			ЗаполнитьЗначенияСвойств(поле1, поле);
			поле1.Заголовок = "";
		КонецЕсли;
	КонецЦикла;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	СтруктураДоков = Новый Массив;
	Для каждого ТекСДок Из Результат Цикл
		СтруктураДоков.Добавить(Новый Структура("ДокументБУ, ДокументУУ", ТекСДок.ДокументБУ, ТекСДок.ДокументУУ));
	КонецЦикла;
	
	Возврат СтруктураДоков;

КонецФункции

&НаКлиенте
Процедура ПринятьИзмененияСтроки(Команда)
	Если Команда.Имя = "ПринятьИзмененияСтроки" Тогда
		ДокументыКОбработке = Новый Массив;
		Для Каждого ТекСтрока Из Элементы.СписокИзмененные.ВыделенныеСтроки Цикл
			ТекДанные = Элементы.СписокИзмененные.ДанныеСтроки(ТекСтрока);
			ДокументыКОбработке.Добавить(Новый Структура("ДокументБУ, ДокументУУ", ТекДанные.ДокументБУ, ТекДанные.ДокументУУ)); 
		КонецЦикла;
	Иначе
		ДокументыКОбработке = ПолучитьИзмененияНаСервере();
	КонецЕсли;
	
	счСтроки = 0;
	ВремяНачала = ТекущаяДата();
	ЧислоСтрок  = ДокументыКОбработке.Количество();
	
	Для каждого ТекОбр Из ДокументыКОбработке Цикл
		счСтроки = счСтроки + 1;
		СкоростьЗагрузки = ?(ТекущаяДата() - ВремяНачала = 0, 0, Окр(счСтроки / (ТекущаяДата() - ВремяНачала), 2));
		ОсталосьВремени = Окр((ТекущаяДата() - ВремяНачала) / счСтроки * (ЧислоСтрок - счСтроки) / 60, 2);
		
		Если счСтроки / 100 = Окр(счСтроки / 100, 0) ИЛИ СкоростьЗагрузки < 20 ИЛИ ЧислоСтрок < 100 Тогда
			Состояние("Обработка..." + " Осталось " + Строка(ОсталосьВремени) + " мин." + " Скорость " + Строка(СкоростьЗагрузки) + " стр/сек",
			счСтроки / ЧислоСтрок * 100, "" +  Строка(ТекОбр.ДокументБУ) +
			" (" + Строка(счСтроки) + "/" + Строка(ЧислоСтрок) + ")" );
		КонецЕсли;
		ОбработкаПрерыванияПользователя();
		
		Попытка
			ПринятьИзмененияНаСервере(ТекОбр);	
		Исключение
			Сообщить(ОписаниеОшибки());
			Если Не НеПрерыватьПриОшибкеОбработки Тогда
				Прервать;	
			КонецЕсли;
		КонецПопытки;
		
	КонецЦикла;
	
	Элементы.СписокИзмененные.Обновить();
	РасчитатьЗаголовки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьИзменения(Команда)
	
	ТекДанные = Элементы.СписокИзмененные.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрКоманды = ТекДанные.ДокументУУ;
	ПараметрыФормы = Новый Структура("Объект", ПараметрКоманды);
	ТекФорма = ПолучитьФорму("РегистрСведений.ИзмененияРеквизитовОбъектовИБ.ФормаСписка", ПараметрыФормы);
	//ТекФорма = ПолучитьФорму("РегистрСведений.ИзмененияРеквизитовОбъектовИБ.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
	ПользовательскийОтбор = ТекФорма.Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ТекФорма.Список.КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки);
	ПользовательскийОтбор.Элементы.Очистить();
	
	ЭлементОтбора = ПользовательскийОтбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Период");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ПравоеЗначение = ТекДанные.ДатаОбработки;
	
	ТекФорма.Открыть();
	
КонецПроцедуры

