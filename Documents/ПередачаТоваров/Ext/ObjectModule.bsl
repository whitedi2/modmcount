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
		ЭтотОбъект.ВидОперации = Перечисления.ВидыОперацийПередачаТоваров.БезвозмезднаяПередача;
		ЭтотОбъект.Заказ = ДанныеЗаполнения;
		ЭтотОбъект.СуммаВключаетНДС = Истина;
		ЭтотОбъект.ДокументБезНДС = Ложь;
		ЭтотОбъект.ДоговорКонтрагента = ДанныеЗаполнения.Договор;
		ЭтотОбъект.ТипЦен = ЭтотОбъект.ДоговорКонтрагента.ТипЦен;
		ЭтотОбъект.Дата = ДанныеЗаполнения.ДатаПоступления;
		ЭтотОбъект.ЭтоУниверсальныйДокумент = Истина;
		ЭтотОбъект.ВалютаДокумента = ДанныеЗаполнения.Валюта;
		//Ответственным текущий пользователь
		ЭтотОбъект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
		//

		Если Не ЗначениеЗаполнено(ЭтотОбъект.ВалютаДокумента) Тогда
			ЭтотОбъект.ВалютаДокумента = УЧ_Сервер.НациональнаяВалюта();		
		КонецЕсли;
		Для каждого ТекСтрока Из ДанныеЗаполнения.ТабличнаяЧасть Цикл
			НоваяСтрока = ЭтотОбъект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			НоваяСтрока.СтавкаНДС = сабОбщегоНазначенияБУХПовтИсп.СоотвСтавокНДСУУБУХ().Получить(ТекСтрока.СтавкаНДС);
			Если Не ЗначениеЗаполнено(ЭтотОбъект.Склад) Тогда
				ЭтотОбъект.Склад = ТекСтрока.Склад;	
			КонецЕсли;
		КонецЦикла;
		
		НовОбъект = Документы.ПередачаТоваров.СоздатьДокумент();
		ЗаполнитьЗначенияСвойств(НовОбъект, ДанныеЗаполнения,,"Дата, Номер, ВозвратнаяТара");
		НовОбъект.ВидОперации = Перечисления.ВидыОперацийПередачаТоваров.БезвозмезднаяПередача;
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
		Для каждого ТекСтрока Из НовОбъект.Товары Цикл
			НоваяСтрока = ЭтотОбъект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
		КонецЦикла;
		
		СтатьяРасходов = Справочники.ПрочиеДоходыИРасходы.ПредопределенныйЭлемент("РасходыПоБезвозмезднойПередаче");
		
		СчетЗатрат = ПланыСчетов.Хозрасчетный.ПрочиеРасходы;
		СчетУчетаНДС = ПланыСчетов.Хозрасчетный.ПрочиеРасходы;
		Субконто1 = СтатьяРасходов;
		СубконтоНДС1 = СтатьяРасходов;
		
	КонецЕсли;
КонецПроцедуры

Функция ПараметрыУстановкиСвойствСубконто()
	
	Результат = БухгалтерскийУчетКлиентСервер.ПараметрыУстановкиСвойствСубконтоПоШаблону(
	"Субконто", "ПодразделениеЗатрат", "Субконто", "ПодразделениеЗатрат", "СчетЗатрат");
	
	Результат.ДопРеквизиты.Вставить("Организация", ЭтотОбъект.Организация);
	
	Возврат Результат;
	
КонецФункции

Функция ПараметрыУстановкиСвойствСубконтоНДС()
	
	Результат = БухгалтерскийУчетКлиентСервер.ПараметрыУстановкиСвойствСубконтоПоШаблону(
	"СубконтоНДС", "", "СубконтоНДС", "", "СчетУчетаНДС");
	
	Результат.ДопРеквизиты.Вставить("Организация", ЭтотОбъект.Организация);
	
	Возврат Результат;
	
КонецФункции

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
				Если Не ЗначениеЗаполнено(СтрокаТовары.СерияНоменклатуры) Тогда
					СтрокаТовары.СерияНоменклатуры = НоваяСтрокаСерий.СерияНоменклатуры;
				КонецЕсли;
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


