﻿&НаСервере
Перем МассивИсклТипов;

&НаСервереБезКонтекста
Процедура ОбработатьДокументыБУНаСервере(ТекДокументСтруктура, СтруктураВозврата = Неопределено)
	
	РегистрыСведений.сабОбработкаДокументов.ОбработатьДокументыБУНаСервере(ТекДокументСтруктура, СтруктураВозврата);
	
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

&НаСервере
Функция ПолучитьНеобработанныеДокументыРозница()
	 
	Возврат РегистрыСведений.сабОбработкаДокументов.ПолучитьНеобработанныеДокументыРозница();
	
КонецФункции // ()


&НаКлиенте
Процедура ОбработатьДокументыБУ(Команда)
	
	Если Команда.Имя = "ОбработатьВыделенныеДокументыБУ" Тогда
		ДокументыКОбработке = Новый Массив;
		Для каждого ТекСтрока Из Элементы.СписокНеобработанных.ВыделенныеСтроки Цикл
			ДокументыКОбработке.Добавить(Новый Структура("Ссылка", ТекСтрока));		
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
			ОбработатьДокументыБУНаСервере(ТекОбр);	
		Исключение
			Сообщить(ОписаниеОшибки());
			Если Не НеПрерыватьПриОшибкеОбработки Тогда
				Прервать;	
			КонецЕсли;
		КонецПопытки;
		
	КонецЦикла;
	
	Элементы.СписокНеобработанных.Обновить();
	Если Элементы.РозничныеПродажи.Видимость Тогда
		Элементы.СписокРозничныеПродажи.Обновить();
	КонецЕсли;
	
	РасчитатьЗаголовки();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.РозничныеПродажи.Видимость = ПравоДоступа("Чтение", Метаданные.Документы.ВедомостьНаВыплатуЗарплаты);
	Элементы.Обработанные.Видимость = ПравоДоступа("Чтение", Метаданные.Документы.ВедомостьНаВыплатуЗарплаты);
	Элементы.Настройки.Видимость = ПравоДоступа("Чтение", Метаданные.Документы.ВедомостьНаВыплатуЗарплаты);
	СписокИзмененные.ТекстЗапроса = СтрЗаменить(СписокИзмененные.ТекстЗапроса, "ВЫБРАТЬ", "ВЫБРАТЬ РАЗРЕШЕННЫЕ");
	
	ОбрабатыватьНепроведенныеБУДокументы = справочники.сабМониторВнедрения.ПолучитьЗначениеНастройки("ОбрабатыватьНепроведенныеБУДокументы");
	
	ДатаВводаОстатков = Дата('00010101');
	ТекСтрока = Справочники.сабМониторВнедрения.НайтиПоНаименованию("Дата остатков", Истина);
	Если ЗначениеЗаполнено(ТекСтрока) Тогда
		ДатаВводаОстатков = ТекСтрока.Значение;
	КонецЕсли;
	
	СписокНеобработанных.ТекстЗапроса = РегистрыСведений.сабОбработкаДокументов.ТекстЗапросаНеобработанных();
	
	//СписокИзмененные.Параметры.УстановитьЗначениеПараметра("Дата", ДатаВводаОстатков);
	СписокНеобработанных.Параметры.УстановитьЗначениеПараметра("Дата", ДатаВводаОстатков);
	
	СписокРозничныеПродажи.ТекстЗапроса = РегистрыСведений.сабОбработкаДокументов.ТекстЗапросаНеобработанныхРозница();
	
	СписокРозничныеПродажи.Параметры.УстановитьЗначениеПараметра("Дата", ДатаВводаОстатков);
	
	МассивИсклТиповСтру = МассивИсклТипов();
	МассивИсклТипов = МассивИсклТиповСтру.МассивИсклТипов; 
	
	СписокНеобработанных.Параметры.УстановитьЗначениеПараметра("МассивВклВидовОпераций", МассивИсклТиповСтру.МассивВклВидовОпераций);
	СписокНеобработанных.Параметры.УстановитьЗначениеПараметра("МассивИсклТипов", МассивИсклТипов);
	СписокРозничныеПродажи.Параметры.УстановитьЗначениеПараметра("МассивИсклТипов", МассивИсклТипов);
	
	Если ОбрабатыватьНепроведенныеБУДокументы Тогда
		СписокНеобработанных.ТекстЗапроса = СтрЗаменить(СписокНеобработанных.ТекстЗапроса, ".Проведен = ИСТИНА", ".ПометкаУдаления = ЛОЖЬ");
		СписокИзмененные.ТекстЗапроса = СтрЗаменить(СписокИзмененные.ТекстЗапроса, ".Проведен = ИСТИНА", ".ПометкаУдаления = ЛОЖЬ");
		СписокРозничныеПродажи.ТекстЗапроса = СтрЗаменить(СписокРозничныеПродажи.ТекстЗапроса, ".Проведен = ИСТИНА", ".ПометкаУдаления = ЛОЖЬ");
		СписокНеобработанных.ТекстЗапроса = СтрЗаменить(СписокНеобработанных.ТекстЗапроса, ".Проведен = Истина", ".ПометкаУдаления = ЛОЖЬ");
		СписокИзмененные.ТекстЗапроса = СтрЗаменить(СписокИзмененные.ТекстЗапроса, ".Проведен = Истина", ".ПометкаУдаления = ЛОЖЬ");
		СписокРозничныеПродажи.ТекстЗапроса = СтрЗаменить(СписокРозничныеПродажи.ТекстЗапроса, ".Проведен = Истина", ".ПометкаУдаления = ЛОЖЬ");
		СписокНеобработанных.ТекстЗапроса = СтрЗаменить(СписокНеобработанных.ТекстЗапроса, "И НЕ Хозрасчетный.Регистратор ЕСТЬ NULL", "");
	КонецЕсли;
	
	СформироватьЗапросПоБезСвязи();
	
	РасчитатьЗаголовки();
	
	
КонецПроцедуры

&НаСервере
Процедура СформироватьЗапросПоБезСвязи()
	
	Доки = Метаданные.РегистрыСведений.сабОбработкаДокументов.Измерения.ДокументУУ.Тип.Типы();
	
	СписокБезСвязи.ТекстЗапроса = "";
	Индекс = 0;
	Для каждого ТекТип Из Доки Цикл
		
		Индекс = Индекс + 1;
		
		Если ТекТип = Тип("Строка") Тогда
			Продолжить;	
		КонецЕсли;
		
		ОбъектОписания = Метаданные.НайтиПоТипу(ТекТип); 
		
		Если ОбъектОписания <> Неопределено Тогда 
			ИмяСправочника = ОбъектОписания.Имя;
			
			ЕстьАвтор = Ложь;
			Если НЕ ОбъектОписания.Реквизиты.Найти("Автор") = Неопределено Тогда
				ЕстьАвтор = Истина;
			КонецЕсли;
			
			ЕстьКомментарий = Ложь;
			Если НЕ ОбъектОписания.Реквизиты.Найти("Комментарий") = Неопределено Тогда
				ЕстьКомментарий = Истина;
			КонецЕсли;

			СписокБезСвязи.ТекстЗапроса = СписокБезСвязи.ТекстЗапроса + "ВЫБРАТЬ
			|	ДокументУЧ_ДвижениеДС.Ссылка КАК Ссылка,
			|	ДокументУЧ_ДвижениеДС.Номер КАК Номер,
			|	ДокументУЧ_ДвижениеДС.Дата КАК Дата,
			|	" + ?(ЕстьКомментарий, "ДокументУЧ_ДвижениеДС.Комментарий", """""") + " КАК Комментарий,
			|	" + ?(ЕстьАвтор, "ДокументУЧ_ДвижениеДС.Автор", "Значение(Справочник.Пользователи.ПустаяСсылка)") + " КАК Автор,
			|	ТИПЗНАЧЕНИЯ(ДокументУЧ_ДвижениеДС.Ссылка) КАК Тип
			|ИЗ
			|	Документ." + ОбъектОписания.Имя + " КАК ДокументУЧ_ДвижениеДС
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.сабОбработкаДокументов КАК сабОбработкаДокументов
			|		ПО ДокументУЧ_ДвижениеДС.Ссылка = сабОбработкаДокументов.ДокументУУ
			|ГДЕ
			|	сабОбработкаДокументов.ДокументУУ ЕСТЬ NULL
			|	И ДокументУЧ_ДвижениеДС.Проведен = Истина";
			
			Если НЕ Доки.Количество() = Индекс Тогда
				СписокБезСвязи.ТекстЗапроса = СписокБезСвязи.ТекстЗапроса  + "
				|	ОБЪЕДИНИТЬ ВСЕ
				|";
			КонецЕсли;      
			
		КонецЕсли;
		
	КонецЦикла;
	
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
	               |			ИЛИ сабСоответствиеТиповДокументов.НаправлениеОбмена = ""Только БУ-УУ"")";
	
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
	
	Если Элементы.Группа1.ТекущаяСтраница = Элементы.РозничныеПродажи Тогда
		ДокументыКОбработке = Новый Массив;
		Для каждого ТекСтрока Из Элементы.СписокРозничныеПродажи.ВыделенныеСтроки Цикл
			ДокументыКОбработке.Добавить(Новый Структура("Ссылка", ТекСтрока.Ссылка));		
		КонецЦикла; 
	Иначе	
		ДокументыКОбработке = Новый Массив;
		Для каждого ТекСтрока Из Элементы.СписокНеобработанных.ВыделенныеСтроки Цикл
			ДокументыКОбработке.Добавить(Новый Структура("Ссылка", ТекСтрока));		
		КонецЦикла; 
	КонецЕсли;
	
	Для каждого ТекОбр Из ДокументыКОбработке Цикл
		
		БухСсылка = ТекОбр.Ссылка;
		
		СтруктураДанных = Новый Структура;
		ОбработатьДокументыБУНаСервере(ТекОбр, СтруктураДанных);
		Если СтруктураДанных.Свойство("Ссылка") Тогда
			ТекОбр.Ссылка = СтруктураДанных.Ссылка;
		КонецЕсли;
		
		Если НЕ СтруктураДанных.Количество() Тогда
			Прервать;		
		КонецЕсли;
		
		ДопПараметр = Новый Структура("ДокументБУ", БухСсылка); 
		ТекФормаБП = ПолучитьФорму("Документ." + СтруктураДанных.ИмяФормы +".ФормаОбъекта", Новый Структура("Основание, ДокументБУ", ТекОбр.Ссылка, БухСсылка));
		ТекФормаБП.РежимОткрытияОкна = РежимОткрытияОкнаФормы.Независимый;
		ДопПараметр.Вставить("ОбъектУУ", ТекФормаБП);
		Оп = Новый ОписаниеОповещения("ВыполнитьПослеОкончания", ЭтотОбъект, ДопПараметр);
		ТекФормаБП.ОписаниеОповещенияОЗакрытии = Оп;
		
		//рекв ДокументБУ
		КлючУникальности   = Новый УникальныйИдентификатор;
		СтруктураРеквизита = Новый Структура("ДокументБУРекв", КлючУникальности);
		ЗаполнитьЗначенияСвойств(СтруктураРеквизита, ТекФормаБП);
		Если СтруктураРеквизита["ДокументБУРекв"] <> КлючУникальности Тогда
			ТекФормаБП.ДокументБУРекв = БухСсылка;		
		КонецЕсли;
		
		ТекФормаБП.Открыть();
		Прервать;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПослеОкончания(Результат, Параметры) Экспорт
	
	//Если ЗначениеЗаполнено(Параметры.ОбъектУУ.Объект.Ссылка) Тогда
	//	Параметры.Вставить("ДокументУУ", Параметры.ОбъектУУ.Объект.Ссылка);
	//	Параметры.ОбъектУУ = Неопределено;
	//	СоздатьЗаписьРегистра(Параметры);
	//	Элементы.СписокНеобработанных.Обновить();
	//	Если Элементы.РозничныеПродажи.Видимость Тогда
	//		Элементы.СписокРозничныеПродажи.Обновить();
	//	КонецЕсли;
	//КонецЕсли;

КонецПроцедуры


&НаСервереБезКонтекста
Процедура СоздатьЗаписьРегистра(Параметры)
	
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
	
КонецПроцедуры


&НаСервереБезКонтекста
Процедура ПровереноНаСервере(Документ)
	НаборЗаписей = РегистрыСведений.сабОбработкаДокументов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ДокументБУ.Установить(Документ.ДокументБУ);
	НаборЗаписей.Прочитать();
	Для каждого ТекСТрока Из НаборЗаписей Цикл
		ТекСТрока.Модифицирован = Ложь;
		ТекСТрока.ДатаОбработки = ТекущаяДата();
	КонецЦикла;
	НаборЗаписей.Записать();
КонецПроцедуры


&НаКлиенте
Процедура Проверено(Команда)
	Для каждого Эл Из Элементы.СписокИзмененные.ВыделенныеСтроки Цикл
		ПровереноНаСервере(Эл);		
	КонецЦикла;
	Элементы.СписокИзмененные.Обновить();
	РасчитатьЗаголовки();
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


&НаКлиенте
Процедура ОбработатьВсеДокументыБУРозница(Команда)
	
	Если Команда.Имя = "ОбработатьВыделенныеДокументыБУРозница" Тогда
		ДокументыКОбработке = Новый Массив;
		Для каждого ТекСтрока Из Элементы.СписокРозничныеПродажи.ВыделенныеСтроки Цикл
			ДокументыКОбработке.Добавить(Новый Структура("Ссылка", ТекСтрока.Ссылка));		
		КонецЦикла; 
	Иначе	
		ДокументыКОбработке = ПолучитьНеобработанныеДокументыРозница();
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
			ОбработатьДокументыБУНаСервере(ТекОбр);	
		Исключение
			Сообщить(ОписаниеОшибки());
			Если Не НеПрерыватьПриОшибкеОбработки Тогда
				Прервать;	
			КонецЕсли;
		КонецПопытки;
		
	КонецЦикла;
	
	Элементы.СписокРозничныеПродажи.Обновить();
	
	РасчитатьЗаголовки();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ОповеститьРегистрОбработанных" Тогда
		
		Если ТипЗнч(Параметр) = Тип("Структура") И Параметр.Свойство("ДокументБУ") И Не ЗначениеЗаполнено(Параметр.ДокументБУ) Тогда
			Возврат;//это создание УУ документа при открытой обработке БУ доков, нужно пропускать		
		КонецЕсли;
		
		СоздатьЗаписьРегистра(Параметр);

		Элементы.СписокИзмененные.Обновить();
		Элементы.СписокНеобработанных.Обновить();
		Если Элементы.РозничныеПродажи.Видимость Тогда
			Элементы.СписокРозничныеПродажи.Обновить();
		КонецЕсли;
		
		РасчитатьЗаголовки();
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокРозничныеПродажиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	 ПоказатьЗначение(,Элементы.СписокРозничныеПродажи.ТекущиеДанные.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПропуститьВсеДокументыБУ(Команда)
	Если Команда.Имя = "ПропуститьВыделенныеДокументыБУ" Тогда
		ДокументыКОбработке = Новый Массив;
		Для каждого ТекСтрока Из Элементы.СписокНеобработанных.ВыделенныеСтроки Цикл
			ДокументыКОбработке.Добавить(Новый Структура("Ссылка", ТекСтрока));		
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
			ПропуститьДокументыБУНаСервере(ТекОбр);	
		Исключение
			Сообщить(ОписаниеОшибки());
			Прервать;	
		КонецПопытки;
		
	КонецЦикла;
	
	Элементы.СписокНеобработанных.Обновить();
	Если Элементы.РозничныеПродажи.Видимость Тогда
		Элементы.СписокРозничныеПродажи.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПропуститьДокументыБУНаСервере(ТекДокументСтруктура, СтруктураВозврата = Неопределено)
	
	РегистрыСведений.сабОбработкаДокументов.ПропуститьДокументыБУНаСервере(ТекДокументСтруктура, СтруктураВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура ПропуститьВсеДокументыБУРозница(Команда)
	
	Если Команда.Имя = "ПропуститьВыделенныеДокументыБУРозница" Тогда
		ДокументыКОбработке = Новый Массив;
		Для каждого ТекСтрока Из Элементы.СписокРозничныеПродажи.ВыделенныеСтроки Цикл
			ДокументыКОбработке.Добавить(Новый Структура("Ссылка", ТекСтрока.Ссылка));		
		КонецЦикла; 
	Иначе	
		ДокументыКОбработке = ПолучитьНеобработанныеДокументыРозница();
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
			ПропуститьДокументыБУНаСервере(ТекОбр);	
		Исключение
			Сообщить(ОписаниеОшибки());
			Прервать;	
		КонецПопытки;
		
	КонецЦикла;
	
	Элементы.СписокРозничныеПродажи.Обновить();

КонецПроцедуры

&НаСервере
Процедура РасчитатьЗаголовки()
	
	//МассивИсклТипов = МассивИсклТипов();
	
	Схема = Элементы.СписокНеобработанных.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	
	Настройки = Элементы.СписокНеобработанных.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	
	//Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Дата", ДатаВводаОстатков);
	//Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("МассивИсклТипов", МассивИсклТипов);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
		
	КоличествоНеобработанных = Результат.Количество();
	
	Если Элементы.РозничныеПродажи.Видимость Тогда
		
		Схема = Элементы.СписокРозничныеПродажи.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
		
		Настройки = Элементы.СписокРозничныеПродажи.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
		
		//Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Дата", ДатаВводаОстатков);
		//Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("МассивИсклТипов", МассивИсклТипов);
		
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
		МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
		
		ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
		ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
		Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
		
		КоличествоНеобработанныхРозница = Результат.Количество();
		
	КонецЕсли;	
	
	
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
	
	Схема = Элементы.СписокБезСвязи.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	
	Настройки = Элементы.СписокБезСвязи.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	КоличествоБезСвязи = Результат.Количество();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПодключитьОбработчикОжидания("РасчитатьЗаголовкиКлиент", 180);
КонецПроцедуры

&НаКлиенте
Процедура РасчитатьЗаголовкиКлиент()
	РасчитатьЗаголовки();
КонецПроцедуры

&НаКлиенте
Процедура СписокБезСвязиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ТекДанные = Элементы.СписокБезСвязи.ДанныеСтроки(Элементы.СписокБезСвязи.ТекущаяСтрока);
	Если Не ТекДанные = Неопределено Тогда
		ПоказатьЗначение(, ТекДанные.Ссылка);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбрабатыватьНерповеденныеБУДокументыПриИзмененииНаСервере()
	
	ТекЭл = Справочники.сабМониторВнедрения.НайтиПоНаименованию("ОбрабатыватьНепроведенныеБУДокументы", Истина);
	
	Если ЗначениеЗаполнено(ТекЭл) Тогда
		ТекЭлОб = ТекЭл.ПолучитьОбъект();
	Иначе
		ТекЭлОб = Справочники.сабМониторВнедрения.СоздатьЭлемент();
	КонецЕсли;
	
	ТекЭлОб.Наименование = "ОбрабатыватьНепроведенныеБУДокументы";
	ТекЭлОб.Значение = ОбрабатыватьНепроведенныеБУДокументы;
	ТекЭлОб.Записать();

КонецПроцедуры

&НаКлиенте
Процедура ОбрабатыватьНерповеденныеБУДокументыПриИзменении(Элемент)
	ОбрабатыватьНерповеденныеБУДокументыПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПринятьИзмененияНаСервере(ТекОбр)
	
	Попытка
		ТекОбъект = ТекОбр.ДокументУУ.ПолучитьОбъект();
		ТекОбъект.ОбработкаЗаполненияСФормы(ТекОбр.ДокументБУ, Неопределено, Истина);
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
			ТекСТрока.Модифицирован = Ложь;
			ТекСТрока.ДатаОбработки = ТекущаяДата();
			ТекСТрока.Автор = ПараметрыСеанса.ТекущийПользователь;
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

&НаСервере
Функция ВернутьОшибку(Док)
	Выборка = РегистрыСведений.сабДокументОшибкаФоновогоПроведения.Выбрать(Новый Структура("ДокументБУ", Док));
	Пока Выборка.Следующий() Цикл
		Возврат Выборка.Комментарий;
	КонецЦикла;
КонецФункции

&НаКлиенте
Процедура ОткрытьРегистрОшибокФоновогоПроведения(Команда)
	ОткрытьФорму("РегистрСведений.сабДокументОшибкаФоновогоПроведения.ФормаСписка");
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьРегистрОшибокФоновогоПроведения(Команда)
	Режим = РежимДиалогаВопрос.ДаНет;
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтаФорма, Параметры);
	ПоказатьВопрос(Оповещение, "Очистить регистр ошибок фонового проведения", Режим, 0);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		УдалитьЗаписиРегистрасабДокументОшибкаФоновогоПроведения()
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УдалитьЗаписиРегистрасабДокументОшибкаФоновогоПроведения() Экспорт
	НаборЗаписей = РегистрыСведений["сабДокументОшибкаФоновогоПроведения"].СоздатьНаборЗаписей();
	НаборЗаписей.Записать();
КонецПроцедуры

&НаКлиенте
Процедура СписокНеобработанныхВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Элемент.ТекущийЭлемент <> Неопределено И Элемент.ТекущийЭлемент.Заголовок = "Ошибка" Тогда
		Если Элемент.ТекущиеДанные.НомерКартинки = 0 Тогда
			СтандартнаяОбработка = Ложь;
			Ошибка = ВернутьОшибку(Элемент.ТекущаяСтрока);
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = Ошибка;
			//Сообщение.Поле = "СписокНеобработанных[" + Элемент.ТекущаяСтрока + "].СписокНеобработанныхНомерКартинки";
			Сообщение.Сообщить();		
		КонецЕсли;
	КонецЕсли;
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
	
	СсылкаНаОбъект = ТекДанные.ДокументБУ; 
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Ссылка",СсылкаНаОбъект);
	СтруктураКоличествВерсий = сабОбщегоНазначенияБУХ.ПолучитьКоличествоВерсий(СсылкаНаОбъект);
	КолВерсий = СтруктураКоличествВерсий.КоличествоИзмененныхВерсий;
	СравниваемыеВерсии = Новый СписокЗначений;  
	Пока КолВерсий > 0 Цикл
		СравниваемыеВерсии.Добавить(СтруктураКоличествВерсий.КоличествоВерсий, СтруктураКоличествВерсий.КоличествоВерсий);
		СтруктураКоличествВерсий.КоличествоВерсий = СтруктураКоличествВерсий.КоличествоВерсий - 1;
		КолВерсий = КолВерсий - 1;
	КонецЦикла;
	ПараметрыОтчета.Вставить("СравниваемыеВерсии",СравниваемыеВерсии); 
	
	ОткрытьФорму("РегистрСведений.ВерсииОбъектов.Форма.ОтчетПоВерсиямОбъекта", ПараметрыОтчета);

КонецПроцедуры






