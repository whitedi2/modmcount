﻿#Область СлужебныеПроцедурыИФункции

// Функция формирует печатную форму документа.
//
Функция ПечатьЗаказ(МассивОбъектов) Экспорт
		
	КолонкаКодов       = "Код";
	ВыводитьКоды       = ЗначениеЗаполнено(КолонкаКодов);
	ВыводитьУпаковки   = Истина;//ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры");
	ТабличныйДокумент  = Новый ТабличныйДокумент;
	РеквизитыДокумента = Новый Структура("Номер, Дата, Префикс");
	СинонимДокумента   = НСтр("ru='Заказ на перемещение товаров'");

	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПеремещениеТоваров_НакладнаяНаПеремещение";
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПеремещениеТоваров.Ссылка КАК Ссылка,
		|	ПеремещениеТоваров.Заказ КАК Заказ
		|ПОМЕСТИТЬ ВТДокументыНаОсновании
		|ИЗ
		|	Документ.ПеремещениеТоваров КАК ПеремещениеТоваров
		|ГДЕ
		|	ПеремещениеТоваров.Заказ В(&МассивОбъектов)
		|	И НЕ ПеремещениеТоваров.ПометкаУдаления
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПередачаТоваров.Ссылка,
		|	ПередачаТоваров.Заказ
		|ИЗ
		|	Документ.ПередачаТоваров КАК ПередачаТоваров
		|ГДЕ
		|	ПередачаТоваров.Заказ В(&МассивОбъектов)
		|	И НЕ ПередачаТоваров.ПометкаУдаления
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	УЧ_ПеремещениеТоваров.Ссылка,
		|	УЧ_ПеремещениеТоваров.ДокОснование
		|ИЗ
		|	Документ.УЧ_ПеремещениеТоваров КАК УЧ_ПеремещениеТоваров
		|ГДЕ
		|	УЧ_ПеремещениеТоваров.ДокОснование В(&МассивОбъектов)
		|	И НЕ УЧ_ПеремещениеТоваров.ПометкаУдаления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ВТДокументыНаОсновании.Ссылка) КАК Ссылка,
		|	ВТДокументыНаОсновании.Заказ КАК Заказ
		|ПОМЕСТИТЬ ВТДокументыНаОснованииГрупп
		|ИЗ
		|	ВТДокументыНаОсновании КАК ВТДокументыНаОсновании
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТДокументыНаОсновании.Заказ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	сабОбработкаДокументов.ДокументУУ КАК ДокументУУ,
		|	сабОбработкаДокументов.ДокументБУ КАК ДокументБУ,
		|	сабОбработкаДокументов.ДатаОбработки КАК ДатаОбработки
		|ПОМЕСТИТЬ ВТ_НеПустые
		|ИЗ
		|	РегистрСведений.сабОбработкаДокументов КАК сабОбработкаДокументов
		|ГДЕ
		|	сабОбработкаДокументов.ДокументУУ.Дата ЕСТЬ НЕ NULL 
		|
		|СГРУППИРОВАТЬ ПО
		|	сабОбработкаДокументов.ДокументБУ,
		|	сабОбработкаДокументов.ДокументУУ,
		|	сабОбработкаДокументов.ДатаОбработки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	МАКСИМУМ(ВТ_НеПустые.ДокументУУ) КАК ДокументУУ,
		|	ВТ_НеПустые.ДокументБУ КАК ДокументБУ,
		|	ВТ_НеПустые.ДатаОбработки КАК ДатаОбработки
		|ПОМЕСТИТЬ Вт_Группировка
		|ИЗ
		|	ВТ_НеПустые КАК ВТ_НеПустые
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_НеПустые.ДокументБУ,
		|	ВТ_НеПустые.ДатаОбработки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Вт_Группировка.ДокументБУ КАК ДокументБУ,
		|	МАКСИМУМ(Вт_Группировка.ДатаОбработки) КАК ДатаОбработки
		|ПОМЕСТИТЬ Вт_Группировка_Итоговая
		|ИЗ
		|	Вт_Группировка КАК Вт_Группировка
		|
		|СГРУППИРОВАТЬ ПО
		|	Вт_Группировка.ДокументБУ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Вт_Группировка_Итоговая.ДокументБУ КАК ДокументБУ,
		|	МАКСИМУМ(Вт_Группировка.ДокументУУ) КАК ДокументУУ
		|ПОМЕСТИТЬ ВТ_Итоговая
		|ИЗ
		|	Вт_Группировка_Итоговая КАК Вт_Группировка_Итоговая
		|		ЛЕВОЕ СОЕДИНЕНИЕ Вт_Группировка КАК Вт_Группировка
		|		ПО Вт_Группировка_Итоговая.ДокументБУ = Вт_Группировка.ДокументБУ
		|			И Вт_Группировка_Итоговая.ДатаОбработки = Вт_Группировка.ДатаОбработки
		|
		|СГРУППИРОВАТЬ ПО
		|	Вт_Группировка_Итоговая.ДокументБУ
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ДокументБУ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТДокументыНаОснованииГрупп.Заказ КАК Заказ,
		|	ВЫБОР
		|		КОГДА ВТДокументыНаОснованииГрупп.Ссылка ССЫЛКА Документ.УЧ_ПеремещениеТоваров
		|			ТОГДА ВТДокументыНаОснованииГрупп.Ссылка
		|		ИНАЧЕ ЕСТЬNULL(ВТ_Итоговая.ДокументУУ, ЗНАЧЕНИЕ(Документ.УЧ_ПеремещениеТоваров.ПустаяСсылка))
		|	КОНЕЦ КАК ДокументУУ
		|ПОМЕСТИТЬ ВТ_Заказы_РеализацияУпр
		|ИЗ
		|	ВТДокументыНаОснованииГрупп КАК ВТДокументыНаОснованииГрупп
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Итоговая КАК ВТ_Итоговая
		|		ПО ВТДокументыНаОснованииГрупп.Ссылка = ВТ_Итоговая.ДокументБУ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Заказы_РеализацияУпр.Заказ КАК Заказ,
		|	УЧ_РеализацияСерииНоменклатуры.Номенклатура КАК Номенклатура,
		|	УЧ_РеализацияСерииНоменклатуры.НомерСтрокиРеализации КАК НомерСтрокиРеализации,
		|	УЧ_РеализацияСерииНоменклатуры.Количество КАК Количество,
		|	УЧ_РеализацияСерииНоменклатуры.СерияНоменклатуры.ДатаПроизводства КАК СерияНоменклатурыДатаПроизводства
		|ПОМЕСТИТЬ ВТ_СерииНоменклатуры
		|ИЗ
		|	ВТ_Заказы_РеализацияУпр КАК ВТ_Заказы_РеализацияУпр
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.УЧ_ПеремещениеТоваров.СерииНоменклатуры КАК УЧ_РеализацияСерииНоменклатуры
		|		ПО ВТ_Заказы_РеализацияУпр.ДокументУУ = УЧ_РеализацияСерииНоменклатуры.Ссылка
		|			И (УЧ_РеализацияСерииНоменклатуры.СерияНоменклатуры.ДатаПроизводства <> ДАТАВРЕМЯ(1, 1, 1))
		|ГДЕ
		|	УЧ_РеализацияСерииНоменклатуры.Количество > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЗаказНаПеремещение.Ссылка КАК Ссылка,
		|	ЗаказНаПеремещение.Номер КАК Номер,
		|	ЗаказНаПеремещение.Дата КАК Дата,
		|	ЗаказНаПеремещение.Подразделение КАК Отправитель,
		|	ЗаказНаПеремещение.ПодразделениеПолучатель КАК Получатель,
		|	ПРЕДСТАВЛЕНИЕ(ЗаказНаПеремещение.Склад) КАК ОтправительПредставление,
		|	ПРЕДСТАВЛЕНИЕ(ЗаказНаПеремещение.СкладПолучатель) КАК ПолучательПредставление,
		|	ЗаказНаПеремещение.Организация.Код КАК Префикс,
		|	ЗаказНаПеремещение.ДатаПоступления КАК ДатаПоступления,
		|	ЗаказНаПеремещение.ЗаданиеСкладу КАК ЗаданиеСкладу
		|ИЗ
		|	Документ.ЗаказНаПеремещение КАК ЗаказНаПеремещение
		|ГДЕ
		|	ЗаказНаПеремещение.Ссылка В(&МассивОбъектов)
		|	И ЗаказНаПеремещение.Проведен
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЗаказНаПеремещениеТабличнаяЧасть.НомерСтроки КАК НомерСтроки,
		|	ЗаказНаПеремещениеТабличнаяЧасть.Номенклатура КАК Номенклатура,
		|	ЗаказНаПеремещениеТабличнаяЧасть.Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
		|	ЗаказНаПеремещениеТабличнаяЧасть.Номенклатура.Код КАК КолонкаКодов,
		|	ЗаказНаПеремещениеТабличнаяЧасть.Номенклатура.НаименованиеПолное КАК НоменклатураПредставление,
		|	ПРЕДСТАВЛЕНИЕ(ЗаказНаПеремещениеТабличнаяЧасть.Номенклатура.ЕдиницаИзмерения) КАК ПредставлениеБазовойЕдиницыИзмерения,
		|	ПРЕДСТАВЛЕНИЕ(ЗаказНаПеремещениеТабличнаяЧасть.ЕдиницаИзмерения) КАК ПредставлениеЕдиницыИзмеренияУпаковки,
		|	ЗаказНаПеремещениеТабличнаяЧасть.Количество КАК Количество,
		|	ЗаказНаПеремещениеТабличнаяЧасть.КоличествоУпаковок КАК КоличествоУпаковок,
		|	ВЫБОР
		|		КОГДА ЗаказНаПеремещениеТабличнаяЧасть.Количество = 0
		|			ТОГДА 0
		|		ИНАЧЕ ЗаказНаПеремещениеТабличнаяЧасть.Сумма / ЗаказНаПеремещениеТабличнаяЧасть.Количество
		|	КОНЕЦ КАК Цена,
		|	ЗаказНаПеремещениеТабличнаяЧасть.Сумма КАК Сумма,
		|	ЗаказНаПеремещениеТабличнаяЧасть.Ссылка КАК Ссылка,
		|	ЕСТЬNULL(ВТ_СерииНоменклатуры.Количество, 0) КАК КоличествоСерии,
		|	ЕСТЬNULL(ВТ_СерииНоменклатуры.СерияНоменклатурыДатаПроизводства, ДАТАВРЕМЯ(1, 1, 1)) КАК Серия,
		|	ЗаказНаПеремещениеТабличнаяЧасть.Номенклатура.Наименование КАК НоменклатураНаименование
		|ИЗ
		|	Документ.ЗаказНаПеремещение.ТабличнаяЧасть КАК ЗаказНаПеремещениеТабличнаяЧасть
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СерииНоменклатуры КАК ВТ_СерииНоменклатуры
		|		ПО ЗаказНаПеремещениеТабличнаяЧасть.Ссылка = ВТ_СерииНоменклатуры.Заказ
		|			И ЗаказНаПеремещениеТабличнаяЧасть.Номенклатура = ВТ_СерииНоменклатуры.Номенклатура
		|ГДЕ
		|	ЗаказНаПеремещениеТабличнаяЧасть.Ссылка В(&МассивОбъектов)
		|	И ЗаказНаПеремещениеТабличнаяЧасть.Ссылка.Проведен
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка,
		|	НомерСтроки
		|ИТОГИ
		|	МАКСИМУМ(Номенклатура),
		|	МАКСИМУМ(ТипНоменклатуры),
		|	МАКСИМУМ(КолонкаКодов),
		|	МАКСИМУМ(НоменклатураПредставление),
		|	МАКСИМУМ(ПредставлениеБазовойЕдиницыИзмерения),
		|	МАКСИМУМ(ПредставлениеЕдиницыИзмеренияУпаковки),
		|	МАКСИМУМ(Количество),
		|	МАКСИМУМ(КоличествоУпаковок),
		|	МИНИМУМ(Цена),
		|	МАКСИМУМ(Сумма),
		|	СУММА(КоличествоСерии),
		|	МАКСИМУМ(НоменклатураНаименование)
		|ПО
		|	Ссылка,
		|	НомерСтроки");

	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Результаты = Запрос.ВыполнитьПакет();
	
	Макет = Документы.ЗаказНаПеремещение.ПолучитьМакет("ПФ_MXL_ЗаказНаПеремещениеСерии");

	ОбластьЗаголовок 		= Макет.ПолучитьОбласть("Заголовок");
		
	ОбластьШапкаТаблицыНачало 	= Макет.ПолучитьОбласть("ШапкаТаблицы|НачалоСтроки");
	ОбластьСтрокаТаблицыНачало 	= Макет.ПолучитьОбласть("СтрокаТаблицы|НачалоСтроки");
	ОбластьПодвалТаблицыНачало 	= Макет.ПолучитьОбласть("ПодвалТаблицы|НачалоСтроки");
	
	ОбластьШапкаТаблицыКолонкаКодов 	= Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаКодов");
	ОбластьСтрокаТаблицыКолонкаКодов 	= Макет.ПолучитьОбласть("СтрокаТаблицы|КолонкаКодов");
	ОбластьПодвалТаблицыКолонкаКодов 	= Макет.ПолучитьОбласть("ПодвалТаблицы|КолонкаКодов");
	
	ОбластьШапкаТаблицыКолонкаКодов.Параметры.ИмяКолонкиКодов = КолонкаКодов; 
	
	ОбластьШапкаТаблицыКолонкаУпаковок 		= Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаУпаковок");
	ОбластьСтрокаТаблицыКолонкаУпаковок 	= Макет.ПолучитьОбласть("СтрокаТаблицы|КолонкаУпаковок");
	ОбластьПодвалТаблицыКолонкаУпаковок		= Макет.ПолучитьОбласть("ПодвалТаблицы|КолонкаУпаковок");
	
	ОбластьКолонкаТоваров = Макет.Область("КолонкаТоваров");
	
	Если НЕ ВыводитьКоды Тогда
		
		ОбластьКолонкаТоваров.ШиринаКолонки = ОбластьКолонкаТоваров.ШиринаКолонки + Макет.Область("КолонкаКодов").ШиринаКолонки;
		
	КонецЕсли;
	
	Если НЕ ВыводитьУпаковки Тогда
		
		ОбластьКолонкаТоваров.ШиринаКолонки = ОбластьКолонкаТоваров.ШиринаКолонки + Макет.Область("КолонкаУпаковокКоличество").ШиринаКолонки
		+ Макет.Область("КолонкаУпаковокПредставление").ШиринаКолонки; 		
		
	КонецЕсли;
	
	ОбластьШапкаТаблицыКолонкаТоваров 	= Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаТоваров");
	ОбластьСтрокаТаблицыКолонкаТоваров 	= Макет.ПолучитьОбласть("СтрокаТаблицы|КолонкаТоваров");
	ОбластьПодвалТаблицыКолонкаТоваров 	= Макет.ПолучитьОбласть("ПодвалТаблицы|КолонкаТоваров");
	
	ОбластьШапкаТаблицыКонец 	= Макет.ПолучитьОбласть("ШапкаТаблицы|КонецСтроки");
	ОбластьСтрокаТаблицыКонец 	= Макет.ПолучитьОбласть("СтрокаТаблицы|КонецСтроки");
	ОбластьПодвалТаблицыКонец 	= Макет.ПолучитьОбласть("ПодвалТаблицы|КонецСтроки");
	
	ОбластьПодписей       = Макет.ПолучитьОбласть("Подписи");
	ОбластьИтого          = Макет.ПолучитьОбласть("Итого");
		
	ВыборкаПоДокументам = Результаты[8].Выбрать();
	ВыборкаПоТабличнымЧастям = Результаты[9].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ПервыйДокумент = Истина;
	
	Пока ВыборкаПоДокументам.Следующий() Цикл
		
		Если НЕ ВыборкаПоТабличнымЧастям.НайтиСледующий(Новый Структура("Ссылка",ВыборкаПоДокументам.Ссылка)) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		ВыборкаПоСтрокамТЧ = ВыборкаПоТабличнымЧастям.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Если НЕ ПервыйДокумент Тогда
			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// ЗАГОЛОВОК
		ЗаполнитьЗначенияСвойств(РеквизитыДокумента, ВыборкаПоДокументам);
		ОбластьЗаголовок.Параметры.Заполнить(ВыборкаПоДокументам);
		ОбластьЗаголовок.Параметры.ТекстЗаголовка = СинонимДокумента + " № " + ВыборкаПоДокументам.Номер +  " от " + Формат(ВыборкаПоДокументам.Дата, "ДФ='дд ММММ гггг'") + " г."; 
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);
		
		// ШАПКА
		ТабличныйДокумент.Вывести(ОбластьШапкаТаблицыНачало);
		
		Если ВыводитьКоды Тогда
			
			ТабличныйДокумент.Присоединить(ОбластьШапкаТаблицыКолонкаКодов);
			
		КонецЕсли;
		
		ТабличныйДокумент.Присоединить(ОбластьШапкаТаблицыКолонкаТоваров);
		
		Если ВыводитьУпаковки Тогда
			
			ТабличныйДокумент.Присоединить(ОбластьШапкаТаблицыКолонкаУпаковок);
			
		КонецЕсли;
		
		ТабличныйДокумент.Присоединить(ОбластьШапкаТаблицыКонец);
		ВсегоНаименований = 0;
		Итого             = 0;
		СуммаТоваров      = 0;
		СуммаУслуг        = 0;
		ТипУслуга = Перечисления.ТипыНоменклатуры.Услуга;
		// СТРОКИ ТЧ
		НомерСтроки = 1;
		Пока ВыборкаПоСтрокамТЧ.Следующий() Цикл
			
			ВыборкаСерии = ВыборкаПоСтрокамТЧ.Выбрать();
				ОсталосьСписатьКоличество = ВыборкаПоСтрокамТЧ.Количество;
				ОсталосьСписатьСумма = ВыборкаПоСтрокамТЧ.Сумма; 
				ОсталосьСписатьКоличествоУпаковок = ВыборкаПоСтрокамТЧ.КоличествоУпаковок;
				Цена = ВыборкаПоСтрокамТЧ.Цена;
				
				Пока ВыборкаСерии.Следующий() И ОсталосьСписатьКоличество > 0 Цикл
					Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамТЧ.Номенклатура) Тогда
						Продолжить;
					КонецЕсли; 
					ОбластьСтрокаТаблицыНачало.Параметры.НомерСтроки = НомерСтроки;
					ТабличныйДокумент.Вывести(ОбластьСтрокаТаблицыНачало);
					Если ВыводитьКоды Тогда
						ОбластьСтрокаТаблицыКолонкаКодов.Параметры.Артикул = ВыборкаПоСтрокамТЧ["КолонкаКодов"];
						ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКолонкаКодов);
					КонецЕсли;
					
					//ОбластьСтрокаТаблицыКолонкаТоваров.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
					//ОбластьСтрокаТаблицыКолонкаТоваров.Параметры.Товар = ФормированиеПечатныхФормСервер.ПолучитьПредставлениеНоменклатурыДляПечати(ВыборкаПоСтрокамТЧ.НоменклатураПредставление);
					//ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКолонкаТоваров);
					
						

					СписатьКоличество = ?(ВыборкаСерии.КоличествоСерии > 0,Мин(ОсталосьСписатьКоличество,ВыборкаСерии.КоличествоСерии),ОсталосьСписатьКоличество);
					СписатьСумма = СписатьКоличество * Цена; 
					Если ВыводитьУпаковки Тогда
						СписатьКоличествоУпаковок =  ?(ВыборкаПоСтрокамТЧ.Количество = 0,0,ВыборкаПоСтрокамТЧ.КоличествоУпаковок/ВыборкаПоСтрокамТЧ.Количество * СписатьКоличество);
					КонецЕсли;	
					//ОбластьСтрокаНомера.Параметры.НомерСтроки = НомерСтроки;
					//ТабличныйДокумент.Вывести(ОбластьСтрокаНомера);
					//Если ВыводитьКоды Тогда
					//	ОбластьСтрокаТаблицыКолонкаКодов.Параметры.Артикул = ВыборкаПоСтрокамТЧ["КолонкаКодов"];
					//	ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКолонкаКодов);
					//КонецЕсли;
					ОбластьСтрокаТаблицыКонец.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
					ОбластьСтрокаТаблицыКолонкаТоваров.Параметры.Товар = ФормированиеПечатныхФормСервер.ПолучитьПредставлениеНоменклатурыДляПечати(ВыборкаПоСтрокамТЧ.НоменклатураНаименование);
					ОбластьСтрокаТаблицыКолонкаТоваров.Параметры.Серия = ВыборкаСерии.Серия;	
					ОбластьСтрокаТаблицыКонец.Параметры.Количество = СписатьКоличество;
					ОбластьСтрокаТаблицыКонец.Параметры.Цена = Цена;
					Если ВыводитьУпаковки Тогда
						ОбластьСтрокаТаблицыКолонкаУпаковок.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
						ОбластьСтрокаТаблицыКолонкаУпаковок.Параметры.КоличествоУпаковок = СписатьКоличествоУпаковок;
					КонецЕсли;
					//ТабличныйДокумент.Присоединить(ОбластьСтрокаДанных);
					ОбластьСтрокаТаблицыКонец.Параметры.Сумма = СписатьСумма;
					ОсталосьСписатьКоличество = ОсталосьСписатьКоличество - СписатьКоличество;	
					ОсталосьСписатьСумма = ОсталосьСписатьСумма - СписатьСумма; 
					Если ВыводитьУпаковки Тогда
						ОсталосьСписатьКоличествоУпаковок = ОсталосьСписатьКоличествоУпаковок - СписатьКоличествоУпаковок;
					КонецЕсли;	
					НомерСтроки = НомерСтроки+1;
					Если ОсталосьСписатьКоличество = 0 Тогда
						Если ОсталосьСписатьСумма <> 0 Тогда
							ОбластьСтрокаТаблицыКонец.Параметры.Сумма = СписатьСумма + ОсталосьСписатьСумма;  
						КонецЕсли;
						Если ВыводитьУпаковки Тогда
							Если ОсталосьСписатьКоличествоУпаковок <> 0 Тогда
								ОбластьСтрокаТаблицыКолонкаУпаковок.Параметры.КоличествоУпаковок = СписатьКоличествоУпаковок + ОсталосьСписатьКоличествоУпаковок;  
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;
					ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКолонкаТоваров);

					Если ВыводитьУпаковки Тогда
						ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКолонкаУпаковок);
					КонецЕсли;
					
					ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКонец);				
				КонецЦикла;
				
				
				
				Если ОсталосьСписатьКоличество > 0 Тогда
					СписатьКоличество = ОсталосьСписатьКоличество;
					СписатьСумма = ОсталосьСписатьСумма;
					Если ВыводитьУпаковки Тогда 
						СписатьКоличествоУпаковок = ОсталосьСписатьКоличествоУпаковок; 
					КонецЕсли;
					ОбластьСтрокаТаблицыНачало.Параметры.НомерСтроки = НомерСтроки;
					ТабличныйДокумент.Вывести(ОбластьСтрокаТаблицыНачало);
					Если ВыводитьКоды Тогда
						ОбластьСтрокаТаблицыКолонкаКодов.Параметры.Артикул = ВыборкаПоСтрокамТЧ["КолонкаКодов"];
						ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКолонкаКодов);
					КонецЕсли; 
					ОбластьСтрокаТаблицыКонец.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
					ОбластьСтрокаТаблицыКолонкаТоваров.Параметры.Товар = ФормированиеПечатныхФормСервер.ПолучитьПредставлениеНоменклатурыДляПечати(ВыборкаПоСтрокамТЧ.НоменклатураНаименование);
					ОбластьСтрокаТаблицыКолонкаТоваров.Параметры.Серия = Дата(1,1,1);	
					ОбластьСтрокаТаблицыКонец.Параметры.Количество = СписатьКоличество;
					ОбластьСтрокаТаблицыКонец.Параметры.Цена = Цена;
					Если ВыводитьУпаковки Тогда
						ОбластьСтрокаТаблицыКолонкаУпаковок.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
						ОбластьСтрокаТаблицыКолонкаУпаковок.Параметры.КоличествоУпаковок = СписатьКоличествоУпаковок;
					КонецЕсли;
					//ТабличныйДокумент.Присоединить(ОбластьСтрокаДанных);
					ОбластьСтрокаТаблицыКонец.Параметры.Сумма = СписатьСумма;
					НомерСтроки = НомерСтроки+1;  
					ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКолонкаТоваров);
					Если ВыводитьУпаковки Тогда
						ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКолонкаУпаковок);
					КонецЕсли;
                    ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКонец);
				КонецЕсли;
										
			
			//ОбластьСтрокаТаблицыНачало.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
			//ТабличныйДокумент.Вывести(ОбластьСтрокаТаблицыНачало);
			//
			//Если ВыводитьКоды Тогда
			//	
			//	ОбластьСтрокаТаблицыКолонкаКодов.Параметры.Артикул = ВыборкаПоСтрокамТЧ["КолонкаКодов"];
			//	ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКолонкаКодов);
			//	
			//КонецЕсли;
			//
			//ОбластьСтрокаТаблицыКолонкаТоваров.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
			//ОбластьСтрокаТаблицыКолонкаТоваров.Параметры.Товар = ФормированиеПечатныхФормСервер.ПолучитьПредставлениеНоменклатурыДляПечати(ВыборкаПоСтрокамТЧ.Номенклатура);
			//ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКолонкаТоваров);
			//
			//Если ВыводитьУпаковки Тогда
			//	
			//	ОбластьСтрокаТаблицыКолонкаУпаковок.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
			//	ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКолонкаУпаковок);
			//	
			//КонецЕсли;
			//
			//ОбластьСтрокаТаблицыКонец.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
			//ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКонец);	
			
			ВсегоНаименований = ВсегоНаименований + 1;
			Итого             = Итого + ВыборкаПоСтрокамТЧ.Сумма;
			Если ВыборкаПоСтрокамТЧ.ТипНоменклатуры = ТипУслуга Тогда
				СуммаУслуг = СуммаУслуг + ВыборкаПоСтрокамТЧ.Сумма;
			Иначе
				СуммаТоваров = СуммаТоваров + ВыборкаПоСтрокамТЧ.Сумма;
			КонецЕсли;
			
			
			
		КонецЦикла;
		
		ТабличныйДокумент.Вывести(ОбластьПодвалТаблицыНачало);
		
		Если ВыводитьКоды Тогда
			
			ТабличныйДокумент.Присоединить(ОбластьПодвалТаблицыКолонкаКодов);
			
		КонецЕсли;
		
		ТабличныйДокумент.Присоединить(ОбластьПодвалТаблицыКолонкаТоваров);
		
		Если ВыводитьУпаковки Тогда
			
			ТабличныйДокумент.Присоединить(ОбластьПодвалТаблицыКолонкаУпаковок);
			
		КонецЕсли;
		
		ТабличныйДокумент.Присоединить(ОбластьПодвалТаблицыКонец);
		
		// ИТОГО
		ОбластьИтого.Параметры.Итого = ФормированиеПечатныхФормСервер.ФорматСумм(Итого);
		ОбластьИтого.Параметры.СуммаУслуг = ФормированиеПечатныхФормСервер.ФорматСумм(СуммаУслуг);
		ОбластьИтого.Параметры.СуммаТоваров = ФормированиеПечатныхФормСервер.ФорматСумм(СуммаТоваров);
		ТабличныйДокумент.Вывести(ОбластьИтого);
								
		// ПОДПИСИ
		ОбластьПодписей.Параметры.Заполнить(ВыборкаПоДокументам);
		
		ТабличныйДокумент.Вывести(ОбластьПодписей);
				
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ПечатьСпискаЗаказов(ТабДок, Ссылка) Экспорт
	//{{_КОНСТРУКТОР_ПЕЧАТИ(ПечатьСпискаЗаказов)
	Макет = Документы.ЗаказПоставщику.ПолучитьМакет("ПечатьСпискаЗаказов");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаказПоставщику.ДатаПоступления КАК ДатаПоступления,
	|	ЗаказПоставщику.Договор,
	|	ЗаказПоставщику.Контрагент КАК Контрагент,
	|	ЗаказПоставщику.Номер,
	|	ЗаказПоставщику.Подразделение КАК Подразделение,
	|	ЗаказПоставщику.Статус,
	|	ЗаказПоставщику.СуммаДокумента КАК СуммаДокумента
	|ИЗ
	|	Документ.ЗаказПоставщику КАК ЗаказПоставщику
	|ГДЕ
	|	ЗаказПоставщику.Ссылка В(&Ссылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Подразделение,
	|	ДатаПоступления,
	|	Контрагент,
	|	СуммаДокумента";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Результат = Запрос.Выполнить().Выгрузить();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ТабДок.Очистить();
	
	Подразделения = Результат.Скопировать();
	Подразделения.Свернуть("Подразделение");
	Если Подразделения.Количество() = 1 Тогда
		ОбластьЗаголовок.Параметры.Магазин = "Магазин: " + Строка(Подразделения[0].Подразделение);
	КонецЕсли; 
	
	ТабДок.Вывести(ОбластьЗаголовок);
	
	ВставлятьРазделительСтраниц = Ложь;
	Для каждого Выборка Из Результат Цикл
		
		//Если ВставлятьРазделительСтраниц Тогда
		//	ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		//КонецЕсли;

		
		//ШТРИХКОД
		ЗначениеШтрихкода = Выборка.Номер;
		Рисунок = Шапка.Рисунки.КартинкаШтрихкода;
		
		КоличествоМиллиметровВПикселе = 0.26458;
		
		ПараметрыШтрихкода = Новый Структура;
		ПараметрыШтрихкода.Вставить("Ширина",	Окр(Рисунок.Ширина / КоличествоМиллиметровВПикселе));
		ПараметрыШтрихкода.Вставить("Высота",	Окр(Рисунок.Высота / КоличествоМиллиметровВПикселе));
		
		ПараметрыШтрихкода.Вставить("УровеньКоррекцииQR", 0);
		
		ПараметрыШтрихкода.Вставить("Штрихкод",				ЗначениеШтрихкода);
		ПараметрыШтрихкода.Вставить("ТипКода",				99);//СтруктураШаблона.ТипКода);
		ПараметрыШтрихкода.Вставить("ОтображатьТекст",		Истина);//СтруктураШаблона.ОтображатьТекст);
		ПараметрыШтрихкода.Вставить("РазмерШрифта",			12);//СтруктураШаблона.РазмерШрифта);
		
		ПараметрыШтрихкода.Вставить("УголПоворота", 0);//СтруктураШаблона.УголПоворота);
		
		Рисунок.Картинка = МенеджерОборудованияВызовСервера.ПолучитьКартинкуШтрихкода(ПараметрыШтрихкода);
		
		//ТабличныйДокумент.Вывести(ОбластьШтрихкода);

		Шапка.Параметры.Заполнить(Выборка);
		
		Если  Выборка.ДатаПоступления = НачалоДня(Выборка.ДатаПоступления) Тогда
			Шапка.Параметры.ДатаПоступления = Формат(Выборка.ДатаПоступления, "ДФ='dd.ММ.yyyy'");
		Иначе
			Шапка.Параметры.ДатаПоступления = Формат(Выборка.ДатаПоступления, "ДФ='dd.ММММ.yyyy ''в'' ЧЧ:мм '");
		КонецЕсли; 
		
		
		ТабДок.Вывести(Шапка);

		//ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	//}}
КонецПроцедуры

Функция ПечатьПриемТоваров(ТабДок,Ссылка) Экспорт
	ТабДок  = Новый ТабличныйДокумент;
	Макет = Документы.ЗаказНаПеремещение.ПолучитьМакет("ПриемТоваров");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаказНаПеремещение.Ссылка КАК Ссылка,
	|	ЗаказНаПеремещение.ДатаПоступления КАК ДатаПоступления,
	|	ЗаказНаПеремещение.ДатаДоставки КАК ДатаДоставки,
	|	ЗаказНаПеремещение.Контрагент КАК Контрагент,
	|	ЗаказНаПеремещение.Контрагент.ИНН КАК КонтрагентИНН,
	|	ЗаказНаПеремещение.Номер КАК Номер,
	|	ЗаказНаПеремещение.Дата КАК Дата
	|ИЗ
	|	Документ.ЗаказНаПеремещение КАК ЗаказНаПеремещение
	|ГДЕ
	|	ЗаказНаПеремещение.Ссылка В(&Ссылка)";
	
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Результат = Запрос.Выполнить().Выгрузить();
	
	Шапка = Макет.ПолучитьОбласть("Шапка");             
	ТабДок.Очистить();
	
	//ВставлятьРазделительСтраниц = Ложь;
	Для каждого Выборка Из Результат Цикл
		
		//Если ВставлятьРазделительСтраниц Тогда
		//	ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		//КонецЕсли;
		
		//Шапка.Параметры.ЗаявкаПоклажедателя = Выборка.Номер;
		
		Шапка.Параметры.ПредставлениеГрузополучателя = СокрЛП(Строка(Ссылка.Организация))+", "+СокрЛП(Строка(Ссылка.Организация.ИНН));
		
		ТекущаяДата = Формат(Выборка.Дата, "ДФ='дд ММММ'");	
		МесяцВозврата = Сред(ТекущаяДата, 4);
		Шапка.Параметры.ДеньВозврата =  День(Выборка.Дата);
		Шапка.Параметры.МесяцВозврата =  МесяцВозврата;
		Шапка.Параметры.ГодВозврата =  Год(Выборка.Дата);
		
		ТекущаяДата = Формат(Выборка.ДатаДоставки, "ДФ='дд ММММ'");	
		МесяцПрибытия = Сред(ТекущаяДата, 4);
		Шапка.Параметры.ДеньПрибытия =  День(Выборка.ДатаДоставки);
		Шапка.Параметры.МесяцПрибытия =  МесяцПрибытия;
		Шапка.Параметры.ГодПрибытия =  Год(Выборка.ДатаДоставки);
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	сабМаршрутныйЛист.Доставщик КАК Доставщик,
		|	сабМаршрутныйЛист.ТранспортноеСредство КАК ТранспортноеСредство
		|ИЗ
		|	Документ.сабМаршрутныйЛист.ТабличнаяЧасть КАК сабМаршрутныйЛистТабличнаяЧасть
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.сабМаршрутныйЛист КАК сабМаршрутныйЛист
		|		ПО сабМаршрутныйЛистТабличнаяЧасть.Ссылка = сабМаршрутныйЛист.Ссылка
		|ГДЕ
		|	сабМаршрутныйЛистТабличнаяЧасть.ЗаказКлиента = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Шапка.Параметры.МаркаГосНомерТС = ВыборкаДетальныеЗаписи.ТранспортноеСредство;
			Шапка.Параметры.ФИОВодителя = ВыборкаДетальныеЗаписи.Доставщик;
		КонецЦикла;
				
		ТабДок.Вывести(Шапка);
		
		ИтогоВес = 0;
		Строка = Макет.ПолучитьОбласть("Строка");
		Док = Ссылка.ПолучитьОбъект();
		Для Каждого Стр Из Док.ТабличнаяЧасть Цикл
			Строка.Параметры.ТМЦ = Стр.Номенклатура;
			Строка.Параметры.ЕдИзм = Стр.ЕдиницаИзмерения;
			Строка.Параметры.Количество = Стр.Количество;
			Строка.Параметры.Вес = Стр.Номенклатура.Вес*Стр.Количество;
			ИтогоВес = ИтогоВес+Строка.Параметры.Вес;
			//Строка.Примечание = "";
			ТабДок.Вывести(Строка);
		КонецЦикла;
		
		Подвал = Макет.ПолучитьОбласть("Подвал");
		Подвал.Параметры.ИтогоВес = ИтогоВес;
		ТабДок.Вывести(Подвал);
		
		//ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;

	Возврат ТабДок;

КонецФункции

Функция ПечатьОтпускТоваров(ТабДок,Ссылка) Экспорт
	ТабДок  = Новый ТабличныйДокумент;
	Макет = Документы.ЗаказНаПеремещение.ПолучитьМакет("ОтпускТоваров");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаказНаПеремещение.Ссылка КАК Ссылка,
	|	ЗаказНаПеремещение.ДатаПоступления КАК ДатаПоступления,
	|	ЗаказНаПеремещение.ДатаДоставки КАК ДатаДоставки,
	|	ЗаказНаПеремещение.Контрагент КАК Контрагент,
	|	ЗаказНаПеремещение.Контрагент.ИНН КАК КонтрагентИНН,
	|	ЗаказНаПеремещение.Номер КАК Номер,
	|	ЗаказНаПеремещение.Дата КАК Дата
	|ИЗ
	|	Документ.ЗаказНаПеремещение КАК ЗаказНаПеремещение
	|ГДЕ
	|	ЗаказНаПеремещение.Ссылка В(&Ссылка)";
	
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Результат = Запрос.Выполнить().Выгрузить();
	
	Шапка = Макет.ПолучитьОбласть("Шапка");             
	ТабДок.Очистить();
	
	//ВставлятьРазделительСтраниц = Ложь;
	Для каждого Выборка Из Результат Цикл
		
		//Если ВставлятьРазделительСтраниц Тогда
		//	ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		//КонецЕсли;
		
		//Шапка.Параметры.ЗаявкаПоклажедателя = Выборка.Номер;
		
		Шапка.Параметры.ПредставлениеГрузополучателя = СокрЛП(Строка(Ссылка.Организация))+", "+СокрЛП(Строка(Ссылка.Организация.ИНН));
		
		ТекущаяДата = Формат(Выборка.Дата, "ДФ='дд ММММ'");	
		МесяцВозврата = Сред(ТекущаяДата, 4);
		Шапка.Параметры.ДеньВозврата =  День(Выборка.Дата);
		Шапка.Параметры.МесяцВозврата =  МесяцВозврата;
		Шапка.Параметры.ГодВозврата =  Год(Выборка.Дата);
		
		ТекущаяДата = Формат(Выборка.ДатаДоставки, "ДФ='дд ММММ'");	
		МесяцПрибытия = Сред(ТекущаяДата, 4);
		Шапка.Параметры.ДеньПрибытия =  День(Выборка.ДатаДоставки);
		Шапка.Параметры.МесяцПрибытия =  МесяцПрибытия;
		Шапка.Параметры.ГодПрибытия =  Год(Выборка.ДатаДоставки);
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	сабМаршрутныйЛист.Доставщик КАК Доставщик,
		|	сабМаршрутныйЛист.ТранспортноеСредство КАК ТранспортноеСредство
		|ИЗ
		|	Документ.сабМаршрутныйЛист.ТабличнаяЧасть КАК сабМаршрутныйЛистТабличнаяЧасть
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.сабМаршрутныйЛист КАК сабМаршрутныйЛист
		|		ПО сабМаршрутныйЛистТабличнаяЧасть.Ссылка = сабМаршрутныйЛист.Ссылка
		|ГДЕ
		|	сабМаршрутныйЛистТабличнаяЧасть.ЗаказКлиента = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Шапка.Параметры.МаркаГосНомерТС = ВыборкаДетальныеЗаписи.ТранспортноеСредство;
			Шапка.Параметры.ФИОВодителя = ВыборкаДетальныеЗаписи.Доставщик;
		КонецЦикла;
				
		ТабДок.Вывести(Шапка);
		
		ИтогоВес = 0;
		Строка = Макет.ПолучитьОбласть("Строка");
		Док = Ссылка.ПолучитьОбъект();
		Для Каждого Стр Из Док.ТабличнаяЧасть Цикл
			Строка.Параметры.ТМЦ = Стр.Номенклатура;
			Строка.Параметры.ЕдИзм = Стр.ЕдиницаИзмерения;
			Строка.Параметры.Количество = Стр.Количество;
			Строка.Параметры.Вес = Стр.Номенклатура.Вес*Стр.Количество;
			ИтогоВес = ИтогоВес+Строка.Параметры.Вес;
			//Строка.Примечание = "";
			ТабДок.Вывести(Строка);
		КонецЦикла;
		
		Подвал = Макет.ПолучитьОбласть("Подвал");
		Подвал.Параметры.ИтогоВес = ИтогоВес;
		ТабДок.Вывести(Подвал);
		
		//ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;

	Возврат ТабДок;

КонецФункции

Функция КонтрольМинимальнойЦены(Ссылка) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	
	Макет = Документы.ЗаказКлиента.ПолучитьМакет("КонтрольМинимальнойЦены");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаказПоставщику.Дата КАК Дата,
	|	ЗаказПоставщику.Договор КАК Договор,
	|	ЗаказПоставщику.Комментарий КАК Комментарий,
	|	ЗаказПоставщику.Контрагент КАК Контрагент,
	|	ЗаказПоставщику.Номер КАК Номер,
	|	ЗаказПоставщику.Предприятие КАК Предприятие,
	|	ЗаказПоставщику.ТабличнаяЧасть.(
	|		НомерСтроки КАК НомерСтроки,
	|		Номенклатура КАК Номенклатура,
	|		Количество КАК Количество,
	|		Цена КАК Цена,
	|		0 КАК МинЦена,
	|		Сумма КАК Сумма,
	|		СтавкаНДС КАК СтавкаНДС,
	|		0 КАК ОтклонениеЦена,
	|		0 КАК ОтклонениеСумма
	|	) КАК ТабличнаяЧасть,
	|	ЗаказПоставщику.ЦенаВключаетНДС КАК ЦенаВключаетНДС,
	|	ЗаказПоставщику.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЗаказПоставщику КАК ЗаказПоставщику
	|ГДЕ
	|	ЗаказПоставщику.Ссылка В(&Ссылка)";
	
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьТабличнаяЧастьШапка = Макет.ПолучитьОбласть("ТабличнаяЧастьШапка");
	ОбластьТабличнаяЧасть = Макет.ПолучитьОбласть("ТабличнаяЧасть");
	ОбластьТабличнаяЧастьПодвал = Макет.ПолучитьОбласть("ТабличнаяЧастьПодвал");
	
	ТипМинЦены = справочники.сабМониторВнедрения.НайтиПоНаименованию("КонтрольМинимальнойЦеныПоТипуЦен", Истина).Значение;
	
	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ВыборкаЦен = Новый ТаблицаЗначений;
		
		Если ЗначениеЗаполнено(ТипМинЦены) Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			               |	ЦеныНоменклатурыСрезПоследних.Период КАК Период,
			               |	ЦеныНоменклатурыСрезПоследних.Номенклатура КАК Номенклатура,
			               |	ЦеныНоменклатурыСрезПоследних.ТипЦен КАК ТипЦен,
			               |	ЦеныНоменклатурыСрезПоследних.Цена КАК Цена
			               |ИЗ
			               |	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
			               |			&Период,
			               |			ТипЦен = &ТипЦен
			               |				И Номенклатура В (&Номенклатура)) КАК ЦеныНоменклатурыСрезПоследних";
			
			Запрос.УстановитьПараметр("ТипЦен", ТипМинЦены);
			Запрос.УстановитьПараметр("Период", Выборка.Дата);
			Запрос.УстановитьПараметр("Номенклатура", Выборка.ТабличнаяЧасть.Выгрузить().ВыгрузитьКолонку("Номенклатура"));
			
			Результат = Запрос.Выполнить();
			ВыборкаЦен = Результат.Выгрузить();
			
		КонецЕсли;

		ОбластьЗаголовок.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(ОбластьЗаголовок);

		Шапка.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Шапка, Выборка.Уровень());
		
		ТабДок.Вывести(ОбластьТабличнаяЧастьШапка);
		ВыборкаТЧ = Выборка.ТабличнаяЧасть.Выгрузить();
		
		СуммаОтклонениеИтого = 0;
		
		Для каждого ВыборкаТабличнаяЧасть Из ВыборкаТЧ Цикл
			
			ВыборкаТабличнаяЧасть.Цена = ?(Выборка.ЦенаВключаетНДС, ВыборкаТабличнаяЧасть.Цена, ВыборкаТабличнаяЧасть.Цена / (1 - ВыборкаТабличнаяЧасть.СтавкаНДС.Ставка/100)); 
			
			Если ВыборкаЦен.Количество() Тогда
				НайденныеСтрокиЦен = ВыборкаЦен.НайтиСтроки(Новый Структура("Номенклатура", ВыборкаТабличнаяЧасть.Номенклатура));
				Для каждого ТекНайдСтрока Из НайденныеСтрокиЦен Цикл
					ВыборкаТабличнаяЧасть.МинЦена = ТекНайдСтрока.Цена;
					ВыборкаТабличнаяЧасть.ОтклонениеЦена = ВыборкаТабличнаяЧасть.Цена - ВыборкаТабличнаяЧасть.МинЦена;
					ВыборкаТабличнаяЧасть.ОтклонениеСумма = ВыборкаТабличнаяЧасть.Цена * ВыборкаТабличнаяЧасть.Количество - ВыборкаТабличнаяЧасть.МинЦена * ВыборкаТабличнаяЧасть.Количество; 
					СуммаОтклонениеИтого = СуммаОтклонениеИтого + ВыборкаТабличнаяЧасть.ОтклонениеСумма;
				КонецЦикла;
			КонецЕсли;
			
			ОбластьТабличнаяЧасть.Параметры.Заполнить(ВыборкаТабличнаяЧасть);
			ТабДок.Вывести(ОбластьТабличнаяЧасть);
		КонецЦикла;
		
		ОбластьТабличнаяЧастьПодвал.Параметры.Заполнить(Выборка);
		ОбластьТабличнаяЧастьПодвал.Параметры.ОтклонениеСуммаИтого = СуммаОтклонениеИтого;
		ТабДок.Вывести(ОбластьТабличнаяЧастьПодвал);
		
		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

#КонецОбласти


Функция ПолучитьКонтакты(Ссылка) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	КонтрагентыКонтактнаяИнформация.АдресЭП
	|ИЗ
	|	Справочник.Контрагенты.КонтактнаяИнформация КАК КонтрагентыКонтактнаяИнформация
	|ГДЕ
	|	КонтрагентыКонтактнаяИнформация.Ссылка = &Ссылка
	|	И КонтрагентыКонтактнаяИнформация.Вид = &Вид";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка.Контрагент);
	Запрос.УстановитьПараметр("Вид", Справочники.ВидыКонтактнойИнформации.EmailКонтрагентаДляЗаказов);
	
	НачатьТранзакцию();
	Попытка
		РезультатЗапроса = Запрос.Выполнить();
		
		Если РезультатЗапроса.Пустой() Тогда
			Результат = Неопределено;
		Иначе
			МассивКонтактов = Новый Массив;
			МассивКонтактов.Добавить(Новый Структура("Адрес, Контакт, Представление", РезультатЗапроса.Выгрузить()[0].АдресЭП));
			Результат = МассивКонтактов;
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	////опасно, конечно. нужно проверять производительность
	//СтандартнаяОбработка = Ложь;
	//РеквизитыДокумента = БюджетныйНаСервере.ВернутьРеквизиты(Данные.Ссылка, "ВидОперации");
	//Если НЕ РеквизитыДокумента = Неопределено И ЗначениеЗаполнено(РеквизитыДокумента.ВидОперации) Тогда
	//	Представление = Строка(РеквизитыДокумента.ВидОперации) + " " + Строка(Данные.Номер) + " от " + Строка(Данные.Дата);	
	//КонецЕсли;
КонецПроцедуры
