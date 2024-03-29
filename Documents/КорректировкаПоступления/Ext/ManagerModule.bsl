﻿
&После("ЗаполнитьПоДокументу")
Процедура УУ_ЗаполнитьПоДокументу(Объект)

	ЗаполнитьСерииИзДокументаОснования(Объект.ДокументПоступления, Объект.Товары, Объект.СерииНоменклатуры);
	//Если сабОбщегоНазначенияПовтИсп.ПолучитьСерийныйУчет() Тогда
	//	Если ТипЗнч(Объект.ДокументПоступления) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") 
	//		ИЛИ ТипЗнч(Объект.ДокументПоступления) = Тип("ДокументСсылка.КорректировкаПоступления")
	//		ИЛИ ТипЗнч(Объект.ДокументПоступления) = Тип("ДокументСсылка.ВозвратТоваровПоставщику") Тогда
	//		Запрос = Новый Запрос;
	//		Запрос.Текст = 
	//		"ВЫБРАТЬ
	//		|	ДокументОснованиеТовары.НомерСтроки КАК НомерСтроки,
	//		|	ДокументОснованиеТовары.Номенклатура КАК Номенклатура,
	//		|	ДокументОснованиеТовары.СерияНоменклатуры КАК СерияНоменклатуры
	//		|ИЗ " + Объект.ДокументПоступления.Метаданные().ПолноеИмя() + ".Товары КАК ДокументОснованиеТовары
	//		|ГДЕ
	//		|	ДокументОснованиеТовары.Ссылка = &Ссылка";
	//		
	//		Запрос.УстановитьПараметр("Ссылка",  Объект.ДокументПоступления);
	//		
	//		РезультатЗапроса = Запрос.Выполнить();
	//		
	//		Выборка = РезультатЗапроса.Выбрать();
	//		
	//		Для Каждого СтрокаТЧТоваты Из Объект.Товары Цикл
	//			Выборка.Сбросить();
	//			СтрутураДляПоискаСтроки = Новый Структура("НомерСтроки, Номенклатура",СтрокаТЧТоваты.НомерСтроки,СтрокаТЧТоваты.Номенклатура);
	//			Если Выборка.НайтиСледующий(СтрутураДляПоискаСтроки) Тогда
	//				СтрокаТЧТоваты.СерияНоменклатуры = 	Выборка.СерияНоменклатуры;
	//			КонецЕсли;
	//		КонецЦикла;
	//		
	//		Объект.СерииНоменклатуры.Очистить();
	//		Для Каждого СтрокаТЧСерииНоменклатуры Из Объект.ДокументПоступления.СерииНоменклатуры Цикл
	//			НоваяСтрокаТЧСерииНоменклатуры = Объект.СерииНоменклатуры.Добавить();
	//			ЗаполнитьЗначенияСвойств(НоваяСтрокаТЧСерииНоменклатуры,СтрокаТЧСерииНоменклатуры);
	//			НоваяСтрокаТЧСерииНоменклатуры.КоличествоДоИзменения = СтрокаТЧСерииНоменклатуры.Количество;
	//		КонецЦикла;
	//	КонецЕсли;
	//КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьСерииИзДокументаОснования(ДокументОснование, ОсновнаяТЧ, СерииНоменклатурыТЧ) Экспорт
	
	Если сабОбщегоНазначенияПовтИсп.ПолучитьСерийныйУчет() Тогда
		Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") 
			ИЛИ ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.КорректировкаПоступления")
			ИЛИ ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ВозвратТоваровПоставщику") Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ДокументОснованиеТовары.НомерСтроки КАК НомерСтроки,
			|	ДокументОснованиеТовары.Номенклатура КАК Номенклатура,
			|	ДокументОснованиеТовары.СерияНоменклатуры КАК СерияНоменклатуры
			|ИЗ " + ДокументОснование.Метаданные().ПолноеИмя() + ".Товары КАК ДокументОснованиеТовары
			|ГДЕ
			|	ДокументОснованиеТовары.Ссылка = &Ссылка";
			
			Запрос.УстановитьПараметр("Ссылка",  ДокументОснование);
			
			РезультатЗапроса = Запрос.Выполнить();
			
			Выборка = РезультатЗапроса.Выбрать();
			
			Для Каждого СтрокаТЧТоваты Из ОсновнаяТЧ Цикл
				Выборка.Сбросить();
				СтрутураДляПоискаСтроки = Новый Структура("НомерСтроки, Номенклатура",СтрокаТЧТоваты.НомерСтроки,СтрокаТЧТоваты.Номенклатура);
				Если Выборка.НайтиСледующий(СтрутураДляПоискаСтроки) Тогда
					СтрокаТЧТоваты.СерияНоменклатуры = 	Выборка.СерияНоменклатуры;
				КонецЕсли;
			КонецЦикла;
			
			СерииНоменклатурыТЧ.Очистить();
			Для Каждого СтрокаТЧСерииНоменклатуры Из ДокументОснование.СерииНоменклатуры Цикл
				НоваяСтрокаТЧСерииНоменклатуры = СерииНоменклатурыТЧ.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрокаТЧСерииНоменклатуры,СтрокаТЧСерииНоменклатуры);
				НоваяСтрокаТЧСерииНоменклатуры.КоличествоДоИзменения = СтрокаТЧСерииНоменклатуры.Количество;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
