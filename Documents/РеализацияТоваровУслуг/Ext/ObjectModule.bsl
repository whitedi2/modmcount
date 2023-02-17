﻿
&После("ПередЗаписью")
Процедура УУ_ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если Модифицированность() Тогда
		сабОбщегоНазначенияБУХ.УстановитьМодифицированностьБУДокумента(ЭтотОбъект, Ссылка, РежимЗаписи);	
	КонецЕсли;  
КонецПроцедуры

&После("ОбработкаЗаполнения")
Процедура УУ_ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказКлиента") Тогда  
		
		//+lud 17/10/22 Проверка повторного создания документов из заказа по обр. №7861 от 12.10.2022 {
		Отказ = сабОперОбщегоНазначения.ПроверкаСозданияНаОснованииНаСервере(ДанныеЗаполнения, "", СтандартнаяОбработка, ТипЗнч(Ссылка));
		Если Отказ.Признак = "##УжеСоздан" Тогда
			ВызватьИсключение "На основании заказа уже введен документ " + Отказ.Ссылка;
		ИначеЕсли Отказ.Признак = "##НеПроведен" Тогда
			ВызватьИсключение "Документ заказ клиента не проведен. Ввод на основании не возможен.";
		КонецЕсли;
		//}
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,,"Дата, Номер, ВозвратнаяТара, Проведен");
		ЭтотОбъект.ВидОперации = Перечисления.ВидыОперацийРеализацияТоваров.Товары;
		ЭтотОбъект.Заказ = ДанныеЗаполнения;
		ЭтотОбъект.СуммаВключаетНДС = Истина;
		ЭтотОбъект.ДокументБезНДС = Ложь;
		ЭтотОбъект.ДоговорКонтрагента = ДанныеЗаполнения.Договор;
		ЭтотОбъект.ТипЦен = ЭтотОбъект.ДоговорКонтрагента.ТипЦен;
		ЭтотОбъект.Дата = ДанныеЗаполнения.ДатаПоступления;
		ЭтотОбъект.ЭтоУниверсальныйДокумент = Истина;
		ЭтотОбъект.ВалютаДокумента = ДанныеЗаполнения.Валюта;
		Если Не ЗначениеЗаполнено(ЭтотОбъект.ВалютаДокумента) Тогда
			ЭтотОбъект.ВалютаДокумента = УЧ_Сервер.НациональнаяВалюта();		
		КонецЕсли;
		ОбособПодразделение = ДанныеЗаполнения.ПодразделениеКонтрагента.ОбособленноеПодразделение;
		Если ЗначениеЗаполнено(ОбособПодразделение) Тогда
			ЭтотОбъект.Грузополучатель = ОбособПодразделение;
		КонецЕсли;
		Для каждого ТекСтрока Из ДанныеЗаполнения.ТабличнаяЧасть Цикл
			НоваяСтрока = ЭтотОбъект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			НоваяСтрока.СтавкаНДС = сабОбщегоНазначенияБУХПовтИсп.СоотвСтавокНДСУУБУХ().Получить(ТекСтрока.СтавкаНДС);
			Если Не ЗначениеЗаполнено(ЭтотОбъект.Склад) Тогда
				ЭтотОбъект.Склад = ТекСтрока.Склад;	
			КонецЕсли;
		КонецЦикла;
		
		НовОбъект = Документы.РеализацияТоваровУслуг.СоздатьДокумент();
		ЗаполнитьЗначенияСвойств(НовОбъект, ДанныеЗаполнения,,"Дата, Номер, ВозвратнаяТара");
		НовОбъект.ВидОперации = Перечисления.ВидыОперацийРеализацияТоваров.Товары;
		НовОбъект.Заказ = ДанныеЗаполнения;
		НовОбъект.СуммаВключаетНДС = Истина;
		НовОбъект.ДокументБезНДС = Ложь;
		Для каждого ТекСтрока Из ДанныеЗаполнения.ТабличнаяЧасть Цикл
			НоваяСтрока = НовОбъект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			НоваяСтрока.СтавкаНДС = сабОбщегоНазначенияБУХПовтИсп.СоотвСтавокНДСУУБУХ().Получить(ТекСтрока.СтавкаНДС);
		КонецЦикла;
		
		ЗаполнениеДокументов.Заполнить(НовОбъект, ДанныеЗаполнения, Истина);
		
		ЭтотОбъект.Товары.Очистить();
		
		МассивНоменклатуры = Новый Массив;
		
		Для каждого ТекСтрока Из НовОбъект.Товары Цикл
			НоваяСтрока = ЭтотОбъект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			МассивНоменклатуры.Добавить(НоваяСтрока.Номенклатура);
		КонецЦикла;
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	СчетНаОплатуПокупателю.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.СчетНаОплатуПокупателю КАК СчетНаОплатуПокупателю
		|ГДЕ
		|	СчетНаОплатуПокупателю.Заказ = &Ссылка
		|	И СчетНаОплатуПокупателю.ПометкаУдаления = ЛОЖЬ";
		
		Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			ЭтотОбъект.СчетНаОплатуПокупателю = Выборка.Ссылка;		
		КонецЦикла;
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		| СправочникНомераГТД.Ссылка КАК НомерГТД,
		| СправочникНомераГТД.Код КАК Код,
		| СУММА(ЕСТЬNULL(ХозрасчетныйОстаткиИОбороты.КоличествоКонечныйОстаток, 0)) КАК КоличествоОстаток,
		| СУММА(ЕСТЬNULL(ХозрасчетныйОстаткиИОбороты.КоличествоОборотДт, 0)) КАК КоличествоПриход,
		| СУММА(ЕСТЬNULL(ХозрасчетныйОстаткиИОбороты.КоличествоОборотКт, 0)) КАК КоличествоРасход,
		| ЕСТЬNULL(ХозрасчетныйОстаткиИОбороты.Субконто1, НЕОПРЕДЕЛЕНО) КАК Номенклатура,
		| ЕСТЬNULL(ХозрасчетныйОстаткиИОбороты.Субконто3, НЕОПРЕДЕЛЕНО) КАК СтранаПроисхождения
		| ИЗ
		| Справочник.НомераГТД КАК СправочникНомераГТД
		| 	ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(
		| 			,
		| 			&Период,
		| 			Период,
		| 			,
		| 			Счет = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ГТД),
		| 			,
		| 			Субконто1 В (&Номенклатура)
		| 				И Организация = &Организация) КАК ХозрасчетныйОстаткиИОбороты
		| 	ПО СправочникНомераГТД.Ссылка = ХозрасчетныйОстаткиИОбороты.Субконто2
		| ГДЕ
		| НЕ СправочникНомераГТД.СтранаВвозаНеРФ
		| СГРУППИРОВАТЬ ПО
		| СправочникНомераГТД.Ссылка,
		| ЕСТЬNULL(ХозрасчетныйОстаткиИОбороты.Субконто1, НЕОПРЕДЕЛЕНО),
		| 	ЕСТЬNULL(ХозрасчетныйОстаткиИОбороты.Субконто3, НЕОПРЕДЕЛЕНО)";
		
		Запрос.УстановитьПараметр("Номенклатура", МассивНоменклатуры);
		Запрос.УстановитьПараметр("Организация", ЭтотОбъект.Организация);
		Запрос.УстановитьПараметр("Период", ЭтотОбъект.Дата);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выгрузить();
		
		Для каждого ТекСтрока Из ЭтотОбъект.Товары Цикл
			НуженГТД = ЗначениеЗаполнено(ТекСтрока.Номенклатура.СтранаПроисхождения);
			НайденГТД = Ложь;
			Если НуженГТД Тогда
				НайденныеСтрокиГТД = Выборка.НайтиСтроки(Новый Структура("Номенклатура", ТекСтрока.Номенклатура));
				Для каждого ТекНайдСтрока Из НайденныеСтрокиГТД Цикл
					Если ТекНайдСтрока.КоличествоОстаток > ТекСтрока.Количество Тогда
						ТекСтрока.НомерГТД = ТекНайдСтрока.НомерГТД;
						ТекСтрока.СтранаПроисхождения = ТекНайдСтрока.СтранаПроисхождения;
						НайденГТД = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
			Если НуженГТД И НЕ НайденГТД Тогда
				Сообщить("В реализации по заказу " + Строка(ДанныеЗаполнения.Ссылка) + " в строке " + Строка(ТекСтрока.НомерСтроки) + " не найдена ГТД на остатках. Необходимо подобрать ГТД вручную.");		
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&После("ОбработкаПроведения")
Процедура УУ_ОбработкаПроведения(Отказ, РежимПроведения)
	
	//меняем статус заказа
	Если НЕ ДополнительныеСвойства.Свойство("НеИзменятьСтатусЗаказа") И ЗначениеЗаполнено(Заказ) И ТипЗнч(Заказ) = Тип("ДокументСсылка.ЗаказКлиента") И Не Заказ.Статус = Перечисления.СтатусыЗаказовКлиентов.Отгружен Тогда		
		ЗаказОб = Заказ.ПолучитьОбъект();
		ЗаказОб.Статус = Перечисления.СтатусыЗаказовКлиентов.Отгружен;
		Если ЗаказОб.Проведен Тогда
			ЗаказОб.Записать(РежимЗаписиДокумента.Проведение);
		Иначе	
			ЗаказОб.Записать(РежимЗаписиДокумента.Запись);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&После("ОбработкаПроверкиЗаполнения")
Процедура УУ_ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если сабОбщегоНазначенияПовтИсп.ПолучитьСерийныйУчет() Тогда
	ТЗСерии = СерииНоменклатуры.Выгрузить();
	ТЗСерии.Свернуть("Номенклатура,ДатаПроизводства,СерияНоменклатуры","Количество");
	ТЗСерии.Сортировать("Номенклатура,ДатаПроизводства"); 
	СерииНоменклатуры.Очистить();
	Для Каждого СтрокаТовары ИЗ Товары Цикл
		СтруктураОтбора = Новый Структура("Номенклатура",СтрокаТовары.Номенклатура);
		НайденыеСтроки = ТЗСерии.НайтиСтроки(СтруктураОтбора);
		//удаляем элементы с пустой серией (для сортировки)
		Для каждого ЭлМассива Из НайденыеСтроки Цикл
			Если НЕ ЗначениеЗаполнено(ЭлМассива.СерияНоменклатуры) Тогда
				ТекИндекс = НайденыеСтроки.Найти(ЭлМассива);
				НайденыеСтроки.Удалить(ТекИндекс);
			КонецЕсли;
		КонецЦикла;  
		//добавляем элементы с пустой серией в конец массива(для сортировки)
		СтруктураОтбора = Новый Структура("Номенклатура,СерияНоменклатуры,",СтрокаТовары.Номенклатура, Справочники.СерииНоменклатуры.ПустаяСсылка());
		МассивПустыхСерий = ТЗСерии.НайтиСтроки(СтруктураОтбора);
		Для каждого ЭлМассива Из МассивПустыхСерий Цикл
			НайденыеСтроки.Добавить(ЭлМассива);
		КонецЦикла;
		ОсталосьРаспределить = СтрокаТовары.Количество;
		НоваяСтрокаСерий = Неопределено;
		Если ОсталосьРаспределить > 0 Тогда 
			СтрокаСПустойСерией = Неопределено;
			Для Каждого СтрокаСерии Из НайденыеСтроки Цикл 
				Распределить = Мин(ОсталосьРаспределить,СтрокаСерии.Количество);
				ОсталосьРаспределить = ОсталосьРаспределить - Распределить;
				НоваяСтрокаСерий = СерииНоменклатуры.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрокаСерий, СтрокаСерии,,"Количество,ДатаПроизводства");
				НоваяСтрокаСерий.Количество = Распределить;
				НоваяСтрокаСерий.НомерСтрокиРеализации = СтрокаТовары.НомерСтроки; 
				НоваяСтрокаСерий.ДатаПроизводства = ?(ЗначениеЗаполнено(НоваяСтрокаСерий.СерияНоменклатуры),НоваяСтрокаСерий.СерияНоменклатуры.ДатаПроизводства,Дата(1,1,1));
				СтрокаТовары.СерияНоменклатуры = НоваяСтрокаСерий.СерияНоменклатуры;	
				Если СтрокаСерии.Количество < Распределить Тогда
					ТзСерии.Удалить(СтрокаСерии);
				КонецЕсли;
				Если ОсталосьРаспределить = 0 Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если ОсталосьРаспределить > 0 Тогда 
				Если НоваяСтрокаСерий <> Неопределено И НЕ ЗначениеЗаполнено(НоваяСтрокаСерий.СерияНоменклатуры) Тогда
					НоваяСтрокаСерий.Количество = НоваяСтрокаСерий.Количество + ОсталосьРаспределить;
				Иначе
					НоваяСтрокаСерий = СерииНоменклатуры.Добавить();
					НоваяСтрокаСерий.Номенклатура = СтрокаТовары.Номенклатура;
					НоваяСтрокаСерий.Количество = ОсталосьРаспределить;
					НоваяСтрокаСерий.НомерСтрокиРеализации = СтрокаТовары.НомерСтроки;
					НоваяСтрокаСерий.ДатаПроизводства = Дата(1,1,1);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла; 
	СерииНоменклатуры.Свернуть("Номенклатура,ДатаПроизводства,ИдентификаторСтрокиРеализации,НомерСтрокиРеализации,СерияНоменклатуры,","Количество");
	ДополнительныеСвойства.Вставить("СинхронизироватьТЧСерииДокументаУУ",Истина);
	КонецЕсли;
КонецПроцедуры


//&После("ПриЗаписи")
//Процедура УУ_ПриЗаписи(Отказ) 
//	
//	Если Не Отказ Тогда
//		Если ДополнительныеСвойства.Свойство("СинхронизироватьТЧСерииДокументаУУ") Тогда
//			Если ДополнительныеСвойства.СинхронизироватьТЧСерииДокументаУУ Тогда
//				УстановитьПривилегированныйРежим(Истина);
//				ЗапросДокУУ = Новый Запрос;
//				ЗапросДокУУ.Текст = 
//				"ВЫБРАТЬ ПЕРВЫЕ 1
//				|	сабОбработкаДокументов.ДокументУУ КАК ДокументУУ,
//				|	сабОбработкаДокументов.ДатаОбработки КАК ДатаОбработки,
//				|	сабОбработкаДокументов.АвтообновленияЗаблокированы КАК АвтообновленияЗаблокированы
//				|ИЗ
//				|	РегистрСведений.сабОбработкаДокументов КАК сабОбработкаДокументов
//				|ГДЕ
//				|	сабОбработкаДокументов.ДокументБУ = &ДокБУ
//				|	И сабОбработкаДокументов.ДокументУУ.Дата ЕСТЬ НЕ NULL 
//				|
//				|УПОРЯДОЧИТЬ ПО
//				|	ДатаОбработки УБЫВ";
//				
//				ЗапросДокУУ.УстановитьПараметр("ДокБУ", Ссылка);
//				
//				РезультатЗапросаДокУУ = ЗапросДокУУ.Выполнить();
//				Если НЕ РезультатЗапросаДокУУ.Пустой() Тогда
//					ВыборкаДокУУ = РезультатЗапросаДокУУ.Выбрать();
//					ВыборкаДокУУ.Следующий();
//					ДокУУ = ВыборкаДокУУ.ДокументУУ;
//					Если ВыборкаДокУУ.АвтообновленияЗаблокированы Тогда
//						Возврат;
//					КонецЕсли;
//					ДокОбъектУУ = ДокУУ.ПолучитьОбъект(); 
//					сабОбщегоНазначенияБУХ.сабОбработкиЗаполненияУчпетныхДокументовОбработкаЗаполнения(ДокОбъектУУ, ЭтотОбъект, Неопределено, Истина); 
//					ДокОбъектУУ.СерииНоменклатуры.Очистить();  
//					Для Каждого СтрокаСерииНоменклатуры ИЗ СерииНоменклатуры Цикл
//						НоваяСтрока = ДокОбъектУУ.СерииНоменклатуры.Добавить(); 
//						ЗаполнитьЗначенияСвойств(НоваяСтрока,СтрокаСерииНоменклатуры);
//					КонецЦикла;
//					Если ДокОбъектУУ.Проведен Тогда
//						Попытка
//							ДокОбъектУУ.Записать(РежимЗаписиДокумента.Проведение); 
//						Исключение
//							Сообщить("Не удалось синхронизировать документ управленческого учета по причине: " + ОписаниеОшибки());
//						КонецПопытки;
//					Иначе 
//						Попытка
//							ДокОбъектУУ.Записать(); 
//						Исключение
//							Сообщить("Не удалось синхронизировать документ управленческого учета по причине: " + ОписаниеОшибки());
//						КонецПопытки;
//					КонецЕсли;
//				КонецЕсли;
//				УстановитьПривилегированныйРежим(Ложь);
//			КонецЕсли;
//		КонецЕсли;
//	КонецЕсли;
//	
//КонецПроцедуры

