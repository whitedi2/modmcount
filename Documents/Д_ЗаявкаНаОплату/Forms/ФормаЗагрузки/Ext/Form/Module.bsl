﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбластьЯчеек = ТабличныйДокумент.Область(1,1);
	ОбластьЯчеек.Обвести(Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1)); 
	ОбластьЯчеек.Текст = "Вид операции";
	ОбластьЯчеек.Примечание.Текст = "Оплата, Перечисление сотруднику, Оплата ВНХ";
	ОбластьЯчеек = ТабличныйДокумент.Область(1,2);
	ОбластьЯчеек.Обвести(Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1)); 
	ОбластьЯчеек.Текст = "Статья ДДС";
	ОбластьЯчеек.Примечание.Текст = "Код статьи";
	ОбластьЯчеек = ТабличныйДокумент.Область(1,3);
	ОбластьЯчеек.Обвести(Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1)); 
	ОбластьЯчеек.Текст = "Источник";
	ОбластьЯчеек = ТабличныйДокумент.Область(1,4);
	ОбластьЯчеек.Обвести(Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1)); 
	ОбластьЯчеек.Примечание.Текст = "Представление источника или номер счета или код элемента справочника";
	ОбластьЯчеек.Текст = "Сумма";
	ОбластьЯчеек = ТабличныйДокумент.Область(1,5);
	ОбластьЯчеек.Обвести(Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1)); 
	ОбластьЯчеек.Текст = "Ставка НДС";
	ОбластьЯчеек.Примечание.Текст = """Без НДС"", ""10%"", ""20%""";
	ОбластьЯчеек = ТабличныйДокумент.Область(1,6);
	ОбластьЯчеек.Обвести(Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1)); 
	ОбластьЯчеек.Текст = "Контрагент";
	ОбластьЯчеек = ТабличныйДокумент.Область(1,7);
	ОбластьЯчеек.Примечание.Текст = "Наименование или ИНН";
	ОбластьЯчеек.Обвести(Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1)); 
	ОбластьЯчеек.Текст = "Счет контрагента";
	ОбластьЯчеек.Примечание.Текст = "Представление счета или номер счета контрагента (по умолчанию подставит единственный счет)";
	ОбластьЯчеек = ТабличныйДокумент.Область(1,8);
	ОбластьЯчеек.Обвести(Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1)); 
	ОбластьЯчеек.Текст = "Назначение платежа";
	ОбластьЯчеек = ТабличныйДокумент.Область(1,9);
	ОбластьЯчеек.Обвести(Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1)); 
	ОбластьЯчеек.Текст = "Назначение платежа (учет) (по-умолчанию равно Назначению платежа)";
	ОбластьЯчеек = ТабличныйДокумент.Область(1,10);
	ОбластьЯчеек.Обвести(Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1), Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1)); 
	ОбластьЯчеек.Текст = "Примечание";
КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
	СтруктураЗагрузки = ЗагрузитьНаСервере();
	Закрыть(СтруктураЗагрузки);
КонецПроцедуры

&НаСервере
Функция ЗагрузитьНаСервере()
	
	СоответстияВидовОпераций = Новый Соответствие;
	СоответстияВидовОпераций.Вставить("Оплата", Перечисления.ВидыОперацийПлатежноеПоручение.Оплата);
	СоответстияВидовОпераций.Вставить("Перечисление сотруднику", Перечисления.ВидыОперацийПлатежноеПоручение.ПеречислениеСотруднику);
	СоответстияВидовОпераций.Вставить("Оплата ВНХ", Перечисления.ВидыОперацийПлатежноеПоручение.ОплатаВНХ);
	
	СоответстияСтавокНДС = Новый Соответствие;
	СоответстияСтавокНДС.Вставить("Без НДС", Справочники.СтавкиНДС.БезНДС);
	СоответстияСтавокНДС.Вставить("10%", Справочники.СтавкиНДС.НДС10);
	СоответстияСтавокНДС.Вставить("20%", Справочники.СтавкиНДС.НДС20);
	
	
	МассивСтруктур = Новый Массив;
	
	
	НомерСтроки = 2;
	ТекОбласть = ТабличныйДокумент.Область(НомерСтроки,1);
	Пока ЗначениеЗаполнено(ТекОбласть.Текст) Цикл
		
		СтруктураЗагрузки = Новый Структура;
		
		СтруктураЗагрузки.Вставить("ВидОперации", СоответстияВидовОпераций.Получить(ТабличныйДокумент.Область(НомерСтроки,1).Текст));
		
		СтруктураЗагрузки.Вставить("СтатьяДДС", Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоКоду(ТабличныйДокумент.Область(НомерСтроки,2).Текст));
		
		ИсточникСтр = ТабличныйДокумент.Область(НомерСтроки,3).Текст;
		Если ЗначениеЗаполнено(ИсточникСтр) Тогда
			СтруктураЗагрузки.Вставить("Источник", Справочники.БанковскиеСчета.НайтиПоНаименованию(ИсточникСтр, Истина));
			Если Не ЗначениеЗаполнено(СтруктураЗагрузки.Источник) Тогда
				СтруктураЗагрузки.Источник = Справочники.БанковскиеСчета.НайтиПоРеквизиту("НомерСчета", ИсточникСтр);
			КонецЕсли;
			Если Не ЗначениеЗаполнено(СтруктураЗагрузки.Источник) Тогда
				СтруктураЗагрузки.Источник = Справочники.Кассы.НайтиПоНаименованию(ИсточникСтр, Истина);
			КонецЕсли;
			Если Не ЗначениеЗаполнено(СтруктураЗагрузки.Источник) Тогда
				СтруктураЗагрузки.Источник = Справочники.Кассы.НайтиПоКоду(ИсточникСтр);
			КонецЕсли;
		Иначе
			СтруктураЗагрузки.Вставить("Источник", Справочники.БанковскиеСчета.ПустаяСсылка());	
		КонецЕсли;
		
		СтруктураЗагрузки.Вставить("СуммаДДС", ТабличныйДокумент.Область(НомерСтроки,4).Текст);
		
		СтруктураЗагрузки.Вставить("СтавкаНДС", СоответстияСтавокНДС.Получить(ТабличныйДокумент.Область(НомерСтроки,5).Текст));
		
		КонтрагентСтр = ТабличныйДокумент.Область(НомерСтроки,6).Текст;
		СтруктураЗагрузки.Вставить("Контрагент", Справочники.Контрагенты.НайтиПоНаименованию(КонтрагентСтр, Истина));
		Если Не ЗначениеЗаполнено(СтруктураЗагрузки.Контрагент) Тогда
			СтруктураЗагрузки.Контрагент = Справочники.Контрагенты.НайтиПоРеквизиту("ИНН", КонтрагентСтр);
		КонецЕсли;
		
		СчетКонтрагентСтр = ТабличныйДокумент.Область(НомерСтроки,7).Текст;
		Если ЗначениеЗаполнено(СчетКонтрагентСтр) Тогда
			СтруктураЗагрузки.Вставить("СчетКонтрагента", Справочники.БанковскиеСчета.НайтиПоНаименованию(СчетКонтрагентСтр, Истина));
			Если Не ЗначениеЗаполнено(СтруктураЗагрузки.СчетКонтрагента) Тогда
				СтруктураЗагрузки.СчетКонтрагента = Справочники.БанковскиеСчета.НайтиПоРеквизиту("НомерСчета", СчетКонтрагентСтр);
			КонецЕсли;
		Иначе
			СтруктураЗагрузки.Вставить("СчетКонтрагента", Справочники.БанковскиеСчета.ПустаяСсылка());	
		КонецЕсли;
		
		СтруктураЗагрузки.Вставить("НазначениеПлатежаБух", ТабличныйДокумент.Область(НомерСтроки,8).Текст);
		СтруктураЗагрузки.Вставить("НазначениеПлатежа", ТабличныйДокумент.Область(НомерСтроки,9).Текст);
		СтруктураЗагрузки.Вставить("Примечание", ТабличныйДокумент.Область(НомерСтроки,10).Текст);
		
		МассивСтруктур.Добавить(СтруктураЗагрузки);
		
		НомерСтроки = НомерСтроки + 1;
		ТекОбласть = ТабличныйДокумент.Область(НомерСтроки,1);
	КонецЦикла;
	
	Возврат МассивСтруктур;	

КонецФункции



